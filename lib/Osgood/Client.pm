package Osgood::Client;

use Moose;

use HTTP::Request;
use LWP::UserAgent;
use URI;
use XML::XPath;
use CGI;

use Osgood::EventList::Serialize::JSON;

has 'error' => ( is => 'rw', isa => 'Str' );
has 'url' => ( is => 'rw', isa => 'URI', default => sub { new URI('http://localhost'); });
has 'list' => ( is => 'rw', isa => 'Maybe[Osgood::EventList]' );
has 'timeout' => ( is => 'rw', isa => 'Int', default => 30 );
has 'serializer' => ( is => 'rw', isa => 'Osgood::EventList::Serialize', default => sub { new Osgood::EventList::Serialize::JSON() });

our $VERSION = '1.1.3';
our $AUTHORITY = 'cpan:GPHAT';

=head1 NAME

Osgood::Client - Client for the Osgood Passive, Persistent Event Queue

=head1 DESCRIPTION

Provides a client for sending events to or retrieving events from an Osgood
queue.

=head1 SYNOPSIS

To send some events:

  my $event = new Osgood::Event(
	object => 'Moose',
	action => 'farted',
	date_occurred => DateTime->now()
  );
  my $list = new Osgood::EventList(events => [ $event ])
  my $client = new Osgood::Client(
	url => 'http://localhost',
	list => $list
  );
  my $retval = $client->send();
  if($list->size() == $retval) {
    print "Success :)\n";
  } else {
    print "Failure :(\n";
  }

To query for events

  use DateTime;
  use Osgood::Client;
  use URI;

  my $client = new Osgood::Client(
      url => new URI('http://localhost:3000'),
  );
  $client->query({ object => 'Moose', action => 'farted' });
  if($client->list->size() == 1) {
      print "Success\n";
  } else {
      print "Failure\n";
  }



=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Osgood::Client object.

=back

=head2 Class Methods

=over 4

=item list

Set/Get the EventList.  For sending events, you should set this.  For
retrieving them, this will be populated by query() returns.

=item send

Send events to the server.

=cut
sub send {
	my $self = shift();

    # my $serializer = new Osgood::EventList::Serializer(list => $self->list());
  	my $ser = $self->serializer->serialize($self->list());

	my $ua = new LWP::UserAgent();

	my $req = new HTTP::Request(POST => $self->url->canonical().'/event/add');
	$req->content_type('application/x-www-form-urlencoded');
	$req->content('ser=' . CGI::escape($ser));

	my $res = $ua->request($req);

	if($res->is_success()) {

		my $xpresp = new XML::XPath(xml => $res->content());
		my $count = $xpresp->find('/response/@count');

		my $err = $xpresp->find('/response/@error');
		$self->error($err->string_value());

		return $count->string_value();
	} else {
		$self->error($res->status_line());
		return 0;
	}
}

=item query

Query the Osgood server for events.  Takes a hashref in the following format:

  {
    id => X,
    object => 'obj',
    action => 'foo',
    date => '2007-12-11'
  }

At least one key is required.

A true or false value is returned to denote the success of failure of the
query.  If false, then the error will be set in the error accessor.  On
success the list may be retrived from the list accessor.

Implicitly sets $self->list(undef), to clear previous results.

=cut

sub query {
	my $self = shift();
	my $params = shift();

    $self->list(undef);

	if((ref($params) ne 'HASH') || !scalar(keys(%{ $params }))) {
		die('Must supply a hash of parameters to query.');
	}

	my $ua = new LWP::UserAgent();

	my $evtparams = delete($params->{params}) || {};
	my $query = join('&',
		map({ "$_=".$params->{$_} } keys(%{ $params })),
		map({ "parameter.$_=$evtparams->{$_}" } keys %$evtparams)
	);

	my $req = new HTTP::Request(POST => $self->url->canonical().'/event/list?'.$query);

	my $res = $ua->request($req);

	if($res->is_success()) {
		$self->list($self->serializer->deserialize($res->content()));
		return 1;
	} else {
		$self->error($res->status_line());
		return 0;
	}
}

=item timeout

The number of seconds to wait before timing out.

=item url

The url of the Osgood queue we should contact.  Expects an instance of URI.

=item error

Returns the error message (if there was one) for this client.  This should
be called if query() or send() do not return what you expect.

=item serializer

Allows you to set a custom serializer object.  JSON is the default, but you
could use the XML serializer by setting this value to an instance of
Osgood::Client::EventList::Serialize::XML.

=back

=head1 PERFORMANCE

Originally Osgood used a combination of XML::DOM and XML::XPath for
serialization.  After some testing it has switched to using JSON, as JSON::XS
is considerably faster.  In tests on my machine (dual quad-core xeon) it takes
about 10 seconds to deserialize 10_000 simple events.

Please keep in mind that the sending of events will also have a cost, as
insertion into the database takes time.  See the accompanying PERFORMANCE
section of Osgood::Server

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 CONTRIBUTORS

Mike Eldridge (diz)

=head1 SEE ALSO

perl(1), Osgood::Event, Osgood::EventList

=head1 COPYRIGHT AND LICENSE

Copyright 2008 by Magazines.com, LLC

You can redistribute and/or modify this code under the same terms as Perl
itself.

=cut

1;

package Osgood::EventList::Serialize::JSON;
use Moose;

extends 'Osgood::EventList::Serialize';

has 'content_type'  => ( is => 'ro', isa => 'Str', default => 'application/json');

use DateTime::Format::ISO8601;
use Osgood::Event;
use Osgood::EventList;
use JSON;

=head1 NAME

Osgood::EventList::Serializer::JSON - JSON Deserializer for EventLists

=head1 DESCRIPTION

(Des|S)erializes an EventList from JSON.

=head1 NOTE

You'd do well to install JSON::XS, as it will this module up quite a bit,
especially for large lists.

=head1 SYNOPSIS

my $serializer = new Osgood::EventList::Deserializer();
my $xml = $serializer->serialize($list);
my $new_list = $serializer->deserialize($xml);

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Osgood::Deserialize object.

=back

=head2 Class Methods

=over 4

=item serialize

Serialized the EventList to XML, returns an XML string.

=cut
sub serialize {
	my $self = shift();
	my $list = shift();

    my @events = ();
	foreach my $event (@{ $list->events() }) {
        my %int_event = (
            id              => $event->id(),
            object          => $event->object(),
            action          => $event->action(),
            date_occurred   => $event->date_occurred->iso8601(),
            params          => $event->params()
        );
        push(@events, \%int_event);
    }


    return encode_json(\@events);
}

=item deserialize

Deserialize the XML.  Returns an EventList.

=cut
sub deserialize {
	my $self = shift();
	my $json = shift();

    my $dec_list = decode_json($json);

	my $list = new Osgood::EventList();
	foreach my $ev (@{ $dec_list }) {

		my $event = new Osgood::Event(
			object	=> $ev->{'object'},
			action	=> $ev->{'action'},
			date_occurred => DateTime::Format::ISO8601->parse_datetime(
				$ev->{'date_occurred'}
			),
		);
		if($ev->{'id'}) {
		    $event->id($ev->{'id'});
		}
		if($ev->{'params'}) {
		    $event->params($ev->{'params'});
		}

		$list->add_to_events($event);
	}

    return $list;
}

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1)

=head1 LICENSE

You can redistribute and/or modify this code under the same terms as Perl
itself.

=cut

1;
package Osgood::Event;
use Moose;

use DateTime;

has 'id' => ( is => 'rw', isa => 'Int'  );
has 'action' => ( is => 'rw', isa => 'Str', required => 1 );
has 'date_occurred' => (
	is => 'rw',
	isa => 'DateTime',
	default => sub { DateTime->now() }
);
has 'object' => ( is => 'rw', isa => 'Str', required => 1 );
has 'params' => ( is => 'rw', isa => 'HashRef', default => sub{ {} } );

=head1 NAME

Osgood::Event - An Osgood Event

=head1 DESCRIPTION

Events are characterized by an object and an action, which could be though
of as a noun and a verb.  The date_occurred is also important and, hopefully,
self-explanatory.  To round out the event there is a params method that
accepts a HashRef for name value pairs.

Note: object and action names are limited to 64 characters.

=head1 SYNOPSIS

  my $event = new Osgood::Event(object => 'Test', action => 'create');

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Osgood::Event object.  Requires an object and action.  If no
date_occurred is specifed, then the DateTime->now() is used.

=back

=head2 Class Methods

=over 4

=item action

The action this event represents.

=item date_occurred

The date and time this event occurred

=item object

The object this event pertains to.

=item params

A HashRef of name-value pairs for this event.

=item set_param

Allows setting a single name value pair directly.

=cut
sub set_param {
	my $self	= shift();
	my $key		= shift() or die('Must supply a key and value to set_param.');
	my $value	= shift();

	$self->params->{$key} = $value;
}

=item get_param

Get the value of the specifed key.

=cut
sub get_param {
	my $self	= shift();
	my $key 	= shift() or die('Must supply a key to get_param.');

	return $self->params->{$key};
}

=back

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), Osgood::EventList

=head1 COPYRIGHT AND LICENSE

Copyright 2008 by Magazines.com, LLC

You can redistribute and/or modify this code under the same terms as Perl
itself.

=cut

1;
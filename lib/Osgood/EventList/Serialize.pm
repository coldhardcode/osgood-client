package Osgood::EventList::Serialize;
use Moose;

has 'version' => ( is => 'rw', isa => 'Int', default => 1 );

=head1 NAME

Osgood::EventList::Serialize - Serialize for EventLists

=head1 DESCRIPTION

Base class EventList serialization.  Shouldn't be used directly.

=head1 SYNOPSIS

  package MySerializer;
  use Moose;
  
  extends 'Osgood::EventList::Serialize;

  sub serialize {
      # .. Serialize some stuff!
  }
  
  sub deserialize {
      # .. Deserialize some stuff!
  }
  
  1;
=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Osgood::EventList::Serialize object.

=back

=head2 Class Methods

=over 4

=item serialize

Serialize the EventList.  Returns the serialized version of same.

=cut
sub serialize {
    die('Stub method.');
}

=item serialize

Deserialize the EventList.  Returns an EventList.

=cut
sub deserialize {
    die('Stub method.');
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
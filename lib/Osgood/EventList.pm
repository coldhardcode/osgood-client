package Osgood::EventList;
use Moose;
use MooseX::Iterator;

has 'list' => (
    is => 'rw',
    isa => 'ArrayRef',
    required => 1,
    default => sub { [] }
);

has '_iterator' => (
    is => 'ro',
    isa => 'MooseX::Iterator::Array',
    default => sub { MooseX::Iterator::Array->new( collection => shift->list ) },
    lazy => 1
);

sub get_highest_id {
	my ($self) = @_;

    my $high = undef;
    foreach my $event (@{ $self->list }) {
        if(!defined($high) || ($high < $event->{id})) {
            $high = $event->{id};
        }
    }

    return $high;
}

sub has_next {
    my ($self) = @_;

    return $self->_iterator->has_next;
}

sub next {
    my ($self) = @_;

    return Osgood::Event->new($self->_iterator->next);
}

sub size {
    my ($self) = @_;

    return scalar(@{ $self->list });
}

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

Osgood::EventList - A list of Osgood events.

=head1 DESCRIPTION

A list of events.

=head1 SYNOPSIS

  my $list = Osgood::EventList->new;
  $list->add_to_events($event);
  print $list->size."\n";

  # or consume an existing list
  my $iter = $list->iterator;
  while($iter->has_next) {
    my $event = $iter->next;
  }

=head1 ATTRIBUTES

=head2 events

Set/Get the ArrayRef of events in this list.

=head1 METHODS

=head2 add_to_events

Add the specified event to the list.

=head2 next

=head2 size

Returns the number of events in this list.

=head2 get_highest_id

Retrieves the largest id from the list of events.  This is useful for keeping
state with an external process that needs to 'remember' the last event id
it handled.

=head1 AUTHOR

Cory 'G' Watson <gphat@cpan.org>

=head1 SEE ALSO

perl(1), L<Osgood::Event>

=head1 COPYRIGHT AND LICENSE

Copyright 2008-2009 by Magazines.com, LLC

You can redistribute and/or modify this code under the same terms as Perl
itself.

=cut
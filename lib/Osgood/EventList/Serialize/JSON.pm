package Osgood::EventList::Serialize::JSON;
use Moose;

extends 'Osgood::EventList::Serialize';

has 'content_type'  => ( is => 'ro', isa => 'Str', default => 'application/json');

use DateTime::Format::ISO8601;
use Osgood::Event;
use Osgood::EventList;
use JSON::XS;

=head1 NAME

Osgood::EventList::Serializer::JSON - JSON (Des|S)erializer for EventLists

=head1 DESCRIPTION

(Des|S)erializes an EventList from JSON.

=head1 SYNOPSIS

my $serializer = new Osgood::EventList::Serializer();
my $json = $serializer->serialize($list);
my $new_list = $serializer->deserialize($json);

=head1 METHODS

=head2 new

Creates a new Osgood::Serialize object.

=head2 serialize

Serializes the EventList to JSON, returns a JSON string.

=cut
sub serialize {
    my ($self, $list) = @_;

    my @events = ();
    foreach my $event (@{ $list->events }) {
        my %int_event = (
            id              => $event->id,
            object          => $event->object,
            action          => $event->action,
            date_occurred   => $event->date_occurred->iso8601,
            params          => $event->params
        );
        push(@events, \%int_event);
    }

    return encode_json(\@events);
}

=head2 deserialize

Deserialize the JSON.  Returns an EventList.

=cut
sub deserialize {
    my ($self, $json, $decoded) = @_;

    my $dec_list;
    if($decoded) {
        $dec_list = $json;
    } else {
        $dec_list = decode_json($json);
    }

    my $list = Osgood::EventList->new;
    foreach my $ev (@{ $dec_list }) {

        my $event = Osgood::Event->new(
                object  => $ev->{'object'},
                action  => $ev->{'action'},
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
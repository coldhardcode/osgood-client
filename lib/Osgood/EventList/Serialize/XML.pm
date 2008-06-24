package Osgood::EventList::Serialize::XML;
use Moose;

extends 'Osgood::EventList::Serialize';

has 'content_type'  => ( is => 'ro', isa => 'Str', default => 'text/xml');

use DateTime::Format::ISO8601;
use Osgood::Event;
use Osgood::EventList;
use XML::XPath;
use XML::DOM;

=head1 NAME

Osgood::EventList::Deserializer - XML Serializer for EventLists

=head1 DESCRIPTION

(Des|S)erializes an EventList from XML.

=head1 SYNOPSIS

  my $serializer = new Osgood::EventList::Deserializer();
  my $xml = $serializer->serialize($list);
  my $new_list = $serializer->deserialize($xml);
 

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Osgood::Serialize::XML object.

=back

=head2 Class Methods

=over 4

=item serialize

Serialized the EventList to XML, returns an XML string.

=cut
sub serialize {
	my $self = shift();
	my $list = shift();

	my $doc = new XML::DOM::Document;
	my $root = $doc->createElement('eventlist');
	$doc->appendChild($root);

	my $version = $doc->createElement('version');
	$version->addText($self->version());
	$root->appendChild($version);

	my $events = $doc->createElement('events');

	foreach my $event (@{ $list->events() }) {
		my $ev = $doc->createElement('event');

		if(defined($event->id())) {
			my $id = $doc->createElement('id');
			$id->addText($event->id());
			$ev->appendChild($id);
		}

		my $obj = $doc->createElement('object');
		$obj->addText($event->object());
		$ev->appendChild($obj);

		my $act = $doc->createElement('action');
		$act->addText($event->action());
		$ev->appendChild($act);

		my $do = $doc->createElement('date_occurred');
		$do->addText($event->date_occurred->iso8601());
		$ev->appendChild($do);

		if(scalar(keys(%{ $event->params() }))) {
			my $params = $doc->createElement('params');

			foreach my $key (keys(%{ $event->params() })) {
				my $param = $doc->createElement('param');

				my $name = $doc->createElement('name');
				$name->addText($key);
				$param->appendChild($name);
				my $value = $doc->createElement('value');
				$value->addText($event->get_param($key));
				$param->appendChild($value);

				$params->appendChild($param);
			}
			$ev->appendChild($params);
		}

		$events->appendChild($ev);
	}

	$root->appendChild($events);

	my $string = $doc->toString();
	$doc->dispose();
	return $string;
}

=item deserialize

Deserialize the XML.  Returns an EventList.

=cut
sub deserialize {
	my $self = shift();
	my $xml = shift();

	my $list = new Osgood::EventList();

	my $xp = new XML::XPath(xml => $xml);
	my $events = $xp->find('/eventlist/events/event');
	foreach my $node ($events->get_nodelist()) {

		my $id = $xp->find('id', $node);
		my $obj = $xp->find('object', $node);
		my $act = $xp->find('action', $node);
		my $docc = $xp->find('date_occurred', $node);

		my $event = new Osgood::Event(
			object	=> $obj->string_value(),
			action	=> $act->string_value(),
			date_occurred => DateTime::Format::ISO8601->parse_datetime(
				$docc->string_value()
			)
		);
		if(defined($id) && ($id->string_value() ne '')) {
			$event->id($id->string_value());
		}

		$list->add_to_events($event);

		my $params = $xp->find('params/param', $node);
		if($params->size() > 0) {
			foreach my $pnode ($params->get_nodelist()) {
				my $name = $xp->find('name', $pnode);
				my $value = $xp->find('value', $pnode);

				$event->set_param(
					$name->string_value(), $value->string_value()
				);
			}
		}
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
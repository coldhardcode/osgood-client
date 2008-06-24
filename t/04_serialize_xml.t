use Test::More;

BEGIN {
    eval "use XML::DOM";
    plan $@ ? (skip_all => 'Needs XML::DOM for testing') : ( tests => 22 );
	use_ok('Osgood::EventList::Serialize::XML');
}

use Osgood::Event;
use Osgood::EventList;

use XML::XPath;

my $list = new Osgood::EventList;

my $event = new Osgood::Event(object => 'Test', action => 'create', params => { key3 => undef });
$event->id(101);
$event->set_param('key1', 'value1');
$event->set_param('key2', 'value2');
$list->add_to_events($event);

my $event2 = new Osgood::Event(object => 'Test2', action => 'create2');
$list->add_to_events($event2);

my $ser = new Osgood::EventList::Serialize::XML();
isa_ok($ser, 'Osgood::EventList::Serialize::XML', 'isa Osgood::EventList::Serialize::XML');

my $xml = $ser->serialize($list);

my $xp = new XML::XPath(xml => $xml);

my $evsnd = $xp->find('/eventlist/events');
cmp_ok($evsnd->size(), '==', 1, 'One events node');

my $evnd = $xp->find('/eventlist/events/event');
cmp_ok($evnd->size(), '==', 2, 'Two event nodes');

my $evind = $xp->find('/eventlist/events/event/id');
cmp_ok($evind->size(), '==', 1, 'One id');

my $evond = $xp->find('/eventlist/events/event/object');
cmp_ok($evond->size(), '==', 2, 'Two objects');

my $evand = $xp->find('/eventlist/events/event/action');
cmp_ok($evand->size(), '==', 2, 'Two actions');

my $evdnd = $xp->find('/eventlist/events/event/date_occurred');
cmp_ok($evdnd->size(), '==', 2, 'Two dates');

my $evpnd = $xp->find('/eventlist/events/event/params/param');
cmp_ok($evpnd->size(), '==', 3, '3 params');

my $evpnnd = $xp->find('/eventlist/events/event/params/param/name');
cmp_ok($evpnnd->size(), '==', 3, '3 param names');

my $evpvnd = $xp->find('/eventlist/events/event/params/param/value');
cmp_ok($evpvnd->size(), '==', 3, '3 param values');

my $slist = $ser->deserialize($xml);

cmp_ok($slist->size(), '==', 2, '2 Events in Deserialized list');
cmp_ok($slist->events->[0]->id(), '==', 101, 'Id');
cmp_ok($slist->events->[0]->object(), 'eq', 'Test', 'First event name');
cmp_ok($slist->events->[0]->action(), 'eq', 'create', 'First action name');
cmp_ok($slist->events->[0]->get_param('key1'), 'eq', 'value1', 'First event param1');
cmp_ok($slist->events->[0]->get_param('key2'), 'eq', 'value2', 'First event param2');
ok(!$event->date_occurred->compare($slist->events->[0]->date_occurred()), 'First event date');
ok(!defined($slist->events->[1]->id()), 'No Id for second');
cmp_ok($slist->events->[1]->object(), 'eq', 'Test2', 'Second event name');
cmp_ok($slist->events->[1]->action(), 'eq', 'create2', 'Second action name');
ok(!$event2->date_occurred->compare($slist->events->[1]->date_occurred()), 'Second event date');
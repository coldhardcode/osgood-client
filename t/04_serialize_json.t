use Test::More tests => 13;

BEGIN {
	use_ok('Osgood::EventList::Serialize::JSON');
}

use Osgood::Event;
use Osgood::EventList;

my $list = new Osgood::EventList;

my $event = new Osgood::Event(object => 'Test', action => 'create', params => { key3 => undef });
$event->id(101);
$event->set_param('key1', 'value1');
$event->set_param('key2', 'value2');
$list->add_to_events($event);

my $event2 = new Osgood::Event(object => 'Test2', action => 'create2');
$list->add_to_events($event2);

my $ser = new Osgood::EventList::Serialize::JSON();
isa_ok($ser, 'Osgood::EventList::Serialize::JSON', 'isa Osgood::EventList::Serialize::JSON');

my $json = $ser->serialize($list);

my $slist = $ser->deserialize($json);

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
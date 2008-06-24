use Test::More tests => 4;

BEGIN {
	use_ok('Osgood::EventList::Serialize::JSON');
}

use Osgood::Event;
use Osgood::EventList;

use XML::XPath;

my $list = new Osgood::EventList;

my $ser = new Osgood::EventList::Serialize::JSON();
isa_ok($ser, 'Osgood::EventList::Serialize::JSON', 'isa Osgood::EventList::Serialize::JSON');

my $json = $ser->serialize($list);

my $slist = $ser->deserialize($json);
isa_ok($slist, 'Osgood::EventList', 'isa Osgood::EventList');

cmp_ok($slist->size(), '==', 0, 'Zero events');

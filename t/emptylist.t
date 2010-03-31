use Test::More;

use Osgood::Event;
use Osgood::EventList;

my $list = Osgood::EventList->new;

cmp_ok($list->size, '==', 0, 'Zero events');

done_testing;
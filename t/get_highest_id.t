use Test::More;

BEGIN { use_ok('Osgood::EventList'); }

use Osgood::Event;

my $list = Osgood::EventList->new(
    list => [
        { object => 'Test', action => 'create', id => 14 },
        { object => 'Test', action => 'create', id => 89 },
        { object => 'Test', action => 'create', id => 5 },
        { object => 'Test', action => 'create', id => 8 }
    ]
);
isa_ok($list, 'Osgood::EventList', 'isa Osgood::EventList');

cmp_ok($list->size, '==', 4, '1 event in list');
cmp_ok($list->get_highest_id, '==', 89, 'Highest Id');

done_testing;
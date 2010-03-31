use Test::More;

BEGIN { use_ok('Osgood::EventList'); }

use Osgood::Event;

{
    my $list = Osgood::EventList->new;
    isa_ok($list, 'Osgood::EventList', 'isa Osgood::EventList');

    cmp_ok($list->size, '==', 0, 'No events in list');
}

{
    my $list = Osgood::EventList->new(list => [ { object => 'Test', action => 'create' } ]);

    cmp_ok($list->size, '==', 1, '1 event in list');

    my $count = 0;

    while($list->has_next) {
        $list->next;
        $count++;
    }
    cmp_ok($count, '==', 1, '1 items in iterator');
}

done_testing;
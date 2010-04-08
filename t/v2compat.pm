use Test::More;

BEGIN { use_ok('Osgood::EventList'); }

use Osgood::Event;

{
    my $list = Osgood::EventList->new(list => [ { object => 'Test', action => 'create' } ]);

    cmp_ok($list->size, '==', 1, '1 event in list');

    my $count = 0;
    my $iter = $list->iterator;
    while($iter->has_next) {
        $iter->next;
        $count++;
    }
    cmp_ok($count, '==', 1, '1 items in iterator');
}

done_testing;
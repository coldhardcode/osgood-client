use Test::More;

BEGIN { use_ok('Osgood::Event'); }

my $event = Osgood::Event->new(object => 'Test', action => 'create');
isa_ok($event, 'Osgood::Event', 'isa Osgood::Event');

cmp_ok(ref($event->params), 'eq', 'HASH');
isa_ok($event->date_occurred, 'DateTime', 'date_occurred isa DateTime');

done_testing;
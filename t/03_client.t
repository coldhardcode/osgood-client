use Test::More tests => 2;

BEGIN { use_ok('Osgood::Client'); }

my $client = Osgood::Client->new;
isa_ok($client, 'Osgood::Client', 'isa Osgood::Client');

use Test::More tests => 2;

BEGIN { use_ok('Osgood::Client'); }

my $client = new Osgood::Client;
isa_ok($client, 'Osgood::Client', 'isa Osgood::Client');

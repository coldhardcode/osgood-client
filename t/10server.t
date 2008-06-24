use strict;

use Test::More;

my $osurl = $ENV{'OSGOOD_SERVER_URL'};

plan skip_all => 'Set $ENV{OSGOOD_SERVER_URL} to run this test.' unless $osurl;

plan tests => 7;

use DateTime;
use Osgood::Client;
use Osgood::Event;
use Osgood::EventList;
use URI;

my $uri = new URI($ENV{'OSGOOD_SERVER_URL'});
my $client = new Osgood::Client({ url => $uri });

my $event = new Osgood::Event(
	object => 'Person',
	action => 'sneezed',
	date_occurred => DateTime->now()
);
my $list = new Osgood::EventList(events => [ $event ]);

$client->list($list);
my $retval = $client->send();
cmp_ok($list->size(), 'eq', $retval, 'add correct number');

$client->list(undef);

$retval = $client->query({
     object => 'Person',
     action => 'sneezed',
});

ok($retval, 'query succeeded');
isa_ok($client->list(), 'Osgood::EventList');
ok($client->list->size(), 'got events');
my $iterator = $client->list->iterator();
my $nevent = $iterator->next();
isa_ok($nevent, 'Osgood::Event');
cmp_ok($nevent->object(), 'eq', 'Person', 'Event object');
cmp_ok($nevent->action(), 'eq', 'sneezed', 'Event action');


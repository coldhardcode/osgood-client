use inc::Module::Install;

name 		'Osgood-Client';
all_from	'lib/Osgood/Client.pm';

requires    'CGI';
requires	'DateTime'	=> '0.41';
requires	'DateTime::Format::ISO8601' => '0.06';
requires    'JSON'  => '2.07';
recommends  'JSON::XS';
requires	'LWP::UserAgent';
requires	'Moose'		=> '0.26';
requires	'MooseX::Iterator' => '0.07';
requires 	'URI';
requires    'XML::XPath'=> '1.13';

feature 'XML Serialization (slower)',
    -default    => 0,
    'XML::DOM'  => '1.44';


auto_install;

WriteAll;

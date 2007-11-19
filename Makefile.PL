use strict;
use warnings;
use inc::Module::Install;

name 'Pidgin-Status-CPAN';
all_from 'lib/Pidgin/Status/CPAN.pm';

requires 'Net::DBus';
requires 'CPANPLUS';
requires 'Moose';

build_requires 'Test::More';
build_requires 'ok';

WriteAll();

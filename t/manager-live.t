#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

plan 'skip_all' => "this isn't really a test; set RUN_DUMB_TESTS=1 to run"
  unless $ENV{RUN_DUMB_TESTS};

use Net::DBus;
use Pidgin::Status::CPAN::Manager;

plan tests => 2;

my $sm = Pidgin::Status::CPAN::Manager->new;
$sm->set_message('This is a test.');
pass('set the message?');
diag 'sleeping for a bit';
sleep 5;
$sm->restore_message;
pass('restored message');

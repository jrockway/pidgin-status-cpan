#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 3;

use ok 'Pidgin::Status::CPAN::Manager';
use ok 'Pidgin::Status::CPAN';
use ok 'CPANPLUS::Dist::PidginStatusMessage';

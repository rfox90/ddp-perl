#!/usr/bin/perl -w
use strict;

use Protocol::DDP;
use AnyEvent;

my $ddp = Protocol::DDP->new;

$ddp->connect();

AnyEvent->condvar->recv;



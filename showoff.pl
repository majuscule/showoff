#!/usr/bin/env perl

use strict;
use warnings;

use URI::Encode qw/uri_encode/;
use List::Util qw/shuffle/;
use Proc::ProcessTable;

my $dir = "$ENV{HOME}/.config/uzbl/control";
my $url = 'https://duckduckgo.com';
my $delay = 5;

my @queries = (
    'dig duckduckgo.com',
    'movie the dark night',
    'amazon headphones',
    'github zeroclickinfo',
);

my @pids = grep {
    exists $_->{'exec'}
        and defined $_->{'exec'}
        and $_->{'exec'} =~ m:^/usr/bin/uzbl:;
} @{new Proc::ProcessTable->table};

my $fifo = 'uzbl_fifo_' . $pids[0]->{pid};

open my $control, ">$dir/$fifo";
select $control;
$|++;

while ("long live dax") {
    for (shuffle @queries) {
        print $control "uri $url/?q=" . uri_encode($_) . "\n";
        sleep $delay;
    }
}

close $control;

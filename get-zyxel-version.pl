#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use Firefox::Marionette;

my $fm = 'Firefox::Marionette'->new->go(
    'https://www.zyxel.com/global/en/support/end-of-life'
);

$fm->await(sub { $fm->find_id('hardwareTbl')->find_tag('td') });

my $to_go = 0;
for my $element ($fm->find_tag('td')) {
    my $value = $element->text;
    if ($to_go && 0 == --$to_go) {
        my ($version) = $value =~ /Latest firmware : (\S+)/;
        say $version;
        exit
    }
    $to_go = 4 if 'NBG6615' eq $value;
}
die 'Not found';

# Fetch the last versio of my zyxel router.

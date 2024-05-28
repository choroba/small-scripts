#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use Firefox::Marionette;
use Time::Piece;

my $fm = 'Firefox::Marionette'->new->go(
    'https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0068973'
);

$fm->await(sub { $fm->find_class('style-two') });
for my $h3 ($fm->find_tag('h3')) {
    if ($h3->text =~ /^(\w+ \d+, \d+) (version [0-9.]+ )\([0-9]+\)/) {
        my $release_date = 'Time::Piece'->strptime($1, '%b %d, %Y');
        if ($release_date <= localtime) {
            say $2;
            last
        }
    }
}

# Fetch the latest zoom client version from the Angular heavy zoom page.

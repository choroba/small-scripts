#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use Firefox::Marionette;

my $fm = 'Firefox::Marionette'->new->go(
    'https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0068973'
);

$fm->await(sub { $fm->find_class('style-two') });
for my $h3 ($fm->find_tag('h3')) {
    if ($h3->text =~ /( version [0-9.]+ )\([0-9]+\)/) {
        say $1;
        last
    }
}

# Fetch the latest zoom client version from the Angular heavy zoom page.

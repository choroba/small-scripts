#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use Firefox::Marionette;

my $fm = 'Firefox::Marionette'->new->go(
    'https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0061222'
);

$fm->await(sub { $fm->find_tag('article') });
my $column;
for my $th ($fm->find_tag('th')) {
    if ('Linux' eq $th->text) {
        $column = $th->attribute('data-col');
        last
    }
}
die 'Linux not found.' if ! defined $column;

for my $td ($fm->find_tag('td')) {
    if (0 == $column--) {
        my $version = $td->text;
        say $version =~ s/version|\(.*//gr;
        last
    }
}

# Fetch the latest zoom client version from the Angular heavy zoom page.

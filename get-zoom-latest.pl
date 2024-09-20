#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use Firefox::Marionette;

my $fm = 'Firefox::Marionette'->new->go(
    'https://zoom.us/download?os=linux'
);

$fm->await(sub { $fm->find_tag('h2') });

my $stage = "START";
my $column;
for my $element ($fm->find_class('version-detail')) {
    my $version = $element->text;
    say $version =~ s/Version |\(.*//gr;
    exit
}
die 'Not found';

# Fetch the latest zoom client version from the Angular heavy zoom page.

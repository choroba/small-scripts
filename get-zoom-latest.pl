#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use Firefox::Marionette;

my $fm = 'Firefox::Marionette'->new->go(
    'https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0061222'
);

$fm->await(sub { $fm->find_tag('article') });

my $stage = "START";
my $column;
for my $element ($fm->find('(//h2 | //th | //td)')) {
    if ('START' eq $stage
        && 'h2' eq $element->tag_name
        && 'Released' eq $element->text
    ) {
        $stage = 'RELEASED';

    } elsif ('RELEASED' eq $stage
             && 'th' eq $element->tag_name
             && 'Linux' eq $element->text
    ) {
        $column = $element->attribute('data-col');
        $stage = 'TABLE';

    } elsif ('TABLE' eq $stage
             && 'td' eq $element->tag_name
             && 0 == $column--
    ) {
        my $version = $element->text;
        say $version =~ s/version|\(.*//gr;
        exit
    }
}
die 'Linux not found.';

# Fetch the latest zoom client version from the Angular heavy zoom page.

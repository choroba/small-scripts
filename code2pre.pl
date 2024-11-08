#!/usr/bin/perl
use warnings;
use strict;

# Translate code that would have worked in <code> tags on PerlMonks
# into code that works in <pre> tags.

my %T = ('&' => '&amp;',
         '<' => '&lt;',
         '[' => '&#91;');
while (<>) {
    s/([&<\[])/$T{$1}/g;
    print
}

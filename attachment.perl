#!/usr/bin/perl
#-*- cperl -*-

use warnings;
use strict;

use Encode;

binmode STDOUT, ':utf8';
my $encoding = shift;
my $encoder  = find_encoding($encoding)
    or die "Encoding $encoding not found\n";

$_ = do { local $/ = undef; <> };
s/\r//g;                          # no windows line ends
s/=\n//g;                         # remove = at the line end
s/=([0-9A-F]{2})/chr hex $1/ge;   # convert =FF codes to chars
my $s = $encoder->decode($_);
print $s;


__END__

=head1 USAGE

 attachment.perl encoding mail1.txt

=head1 DESCRIPTION

Converts text from e-mails encoded with =AF style.

=head1 AUTHOR

(c) E. Choroba 2012

=cut

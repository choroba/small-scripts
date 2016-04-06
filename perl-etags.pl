#!/usr/bin/perl
use warnings;
use strict;
use feature qw{ say };

use List::MoreUtils qw{ any };
use Path::Tiny qw{ path };


sub wanted {
    my ($path, $state) = @_;
    return if $path->is_dir
           || $path !~ /\.p[lm]$/;

    my $code = $path->slurp;
    my %found;
    for my $regex (
                   qr/^(\s* (sub | method) \s+ (\w+)) /xm,
                   qr/^(\s* (alias) \s+ (\w+)) /xm,
                   qr/^(\s* (has) \s+ (?:["']\+?)? (\w+)) /xm,
                   qr/^(\s* (has) \s+ \[ \s* qw \s* . \s* ([^)\]\/>]+)) /xm,
                   qr/^(\s* \{? \s* (package) \s+ ([\w:]+)) /xm,
                  ) {
        while ($code =~ /$regex/g) {
            my ($full, $keyword, $funcs) = ($1, $2, $3);
            for my $func (split ' ', $funcs) {
                my $pos = pos($code) - length $full;
                my $nl_count = substr($code, 0, $pos) =~ tr/\n//;
                my ($single_line) = $full =~ /(.*\Q$func\E.*)/g;
                $found{$keyword}{$func} = [$nl_count + 1, $pos, $single_line];
            }
        }
    }
    return unless keys %found;

    say "\cl";
    my $string = join "\n",
                 map {
                     my $keyword = $_;
                     map "$found{$keyword}{$_}[2]\x7f\x01"
                         . "$found{$keyword}{$_}[0],$found{$keyword}{$_}[1]",
                     keys %{ $found{$keyword} }
                 }
                 keys %found;
    say $path, ',', 1 + length $string;
    say $string;
}


sub main {
    path('.')->visit(\&wanted, { recurse => 1 });
}


main();

=head1 NAME

perl-etags.pl

=head1 SYNOPSIS

cd /project/root && perl-etags.pl > TAGS

=head1 DESCRIPTION

Creates TAGS file similar to what the command C<etags> produces, but
tries to handle C<Moose> keywords as well (C<has>, C<alias>).

=head1 AUTHOR

(c) 2016 E. Choroba

=cut

__END__

# Tested on the following:
# ------------------------

#!/usr/bin/perl
use warnings;
use strict;

package Etags::Test;
use Moose;
use MooseX::Aliases;

has bare => (is => 'rw');

has 'quoted' => (is => 'rw');

has "double_quoted" => (is => 'rw');

has [qw[ list1 list2 ]] => (is => 'ro');

has [qw[ multi
         line
      ]] => (is => 'ro');

sub method {}

sub
method2 {}

alias m2 => 'method2';

use MooseX::Declare;

class Etags::Test2 {
    method method3 (Num $count) {}
}

{ package Inner::Package;

}

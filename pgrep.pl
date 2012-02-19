#!/usr/bin/env perl

use strict 'vars';
use vars qw/$regex $str/;

eval { $regex = qr/$ARGV[0]/i } or
    do { die "$ARGV[0] unvalid regex pattern!\n" };
$str = scalar @ARGV == 2? $ARGV[1]: $ARGV[0];
foreach (<STDIN>) {
    print $_ if $_ =~ s/$regex/\1$str/gi;
}

__END__

=pod

=encoding UTF-8

=head1 NAME

pget - perl grep

=head1 DESCRIPTION

用 perl 正则来处理管道输出.

=head1 AUTHOR

xiaomo(wxm4ever@gmail.com)

=cut

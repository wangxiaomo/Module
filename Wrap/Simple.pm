#!/usr/bin/perl
package Wrap::Simple;

use warnings;
use strict 'vars';

use Exporter;
use vars qw/$VERSION @ISA @EXPORT @EXPORT_OK/;

$VERSION     = "1.0";
$VERSION     = eval $VERSION;

@ISA         = qw/Exporter/;
@EXPORT      = qw/can wrap/;
@EXPORT_OK   = @EXPORT;

=pod

=head1 NAME

Wrap::Simple - a simple wrapper for perl

=head1 INTERFACES

=over 4

=item can

B<can> 用来检测传递的参数是否可执行，如果可执行则返回该函数引用。参数分为两种，一为函数名，
此时通过检测 main 包中的符号表来检测是否可执行。另外一种方式为代码引用，此时通过 B<ref()> 
方式来检测。

    sub foo { print "foo ...\n" }
    
    my $p1 = 'foo';
    my $p2 = \&foo;

    print can $p1;
    print can $p2;

=cut

sub can {
    my $func = shift;
    return $func if $func and ref $func eq 'CODE';
    if (grep { $_ eq $func } keys %::) {
        *f = $::{$func};
        return \&f;
    }
    return 0;
}

=item wrap

B<wrap> 用来封装函数并返回函数引用。第一个参数为要封装的函数，剩余的参数为封装列表。
修饰符暂时只有 pre 和 post。

    sub foo1 { ... }
    sub foo2 { ... }
    sub foo3 { ... }
    sub foo4 { ... }

    my $ref = wrap 'foo', pre=>\&foo1, pre=>\&foo2, pre=>'foo3', post=>\&foo4;
    $ref->("Hello World");

=cut

sub wrap {
    my $func       = shift;
    my $funp       = can $func;
    my @pre_funcs  = ();
    my @post_funcs = ();
    die "$func unvalid!" unless ref $funp eq 'CODE';
    die "@_ unvalid. Perhaps not be in pair." if scalar(@_)%2;

    while (@_) {
        my $p1 = shift;
        my $p2 = shift;
        my $pf = can $p2;
        die "$p2 unvalid!" unless ref $pf eq 'CODE';
        if ($p1 eq 'pre') {
            push @pre_funcs,  $pf;
        } elsif ($p1 eq 'post') {
            push @post_funcs, $pf;
        } else {
            die "$p1 delegation error!";
        }
    }
    
    return sub {
        my $param = shift;
        map $_->(), @pre_funcs;
        $func->($param);
        map $_->(), @post_funcs;
    }
}

=back

=head1 EXAMPLE

    sub core { print "core function with param ",shift, "\n" }
    sub foo1 { print "foo1\n" }
    sub foo2 { print "foo2\n" }
    sub foo3 { print "foo3\n" }
    sub foo4 { print "foo4\n" }

    my $ref = wrap 'core', pre=>'foo1', pre=>\&foo2, pre=>\&foo3, post=>\&foo4;
    $ref->('Hello World');

=head1 LOG

=over 4

=item Mon Feb  6 22:06:42 HKT 2012

模块外与模块内符号表混乱，需要进一步FIX。当使用函数名而不是函数引用时，会发生
该类问题。

FIXED。需要通过%::哈希表来得到具体的符号表，然后形成相应的引用。

=back

=head1 AUTHOR

xiaomo(wxm4ever@gmail.com)

=cut

1;

__END__

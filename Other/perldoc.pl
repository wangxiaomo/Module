#!/usr/bin/env perl
use strict 'vars';
use vars qw/%opt/;
use Getopt::Std;

# unshift . to @INC
# 提高当前路径的搜索优先级
BEGIN { 
    unshift @INC, ".";
    map { $_ .= '/' } @INC;
}

our $DEBUG;
sub read_pod;
sub pod_path;
sub usage;

getopts('v h l m', \%opt);

$DEBUG = 1 if $opt{v};
# 处理 $ARGV[0]
usage if $opt{h} or not $ARGV[0];
my $pod = $ARGV[0];
$pod =~ s/::/\//g;

foreach my $path (@INC) {
    next if not -e $path;
    my $cmd = <<CMD;
find $path -regextype posix-awk -iregex ".*$pod(.pod|.pl|.pm)"
CMD
    print $cmd if $DEBUG;
    my $ret = `$cmd`;
    if ($ret) {
        my @pods = split "\n", $ret;
        print scalar @pods, " Results\n" if $DEBUG;
        if (scalar @pods == 1) {
            read_pod $pods[0];
        } else {
            foreach my $p (@pods) {
                print $p,"?";
                $_ = <STDIN> and chomp;
                read_pod $p if $_ eq 'y';
            }
        }
        last;
    }
}

#---------------------------------------------------------------

sub usage {
    print <<USAGE;

gperldoc [-v|--verbose][-h|--help] expression

#=============================================
-v
--verbose
    verbose

-h
--help
    usage


                Author: xiaomo
                E-mail: wxm4ever\@gmail.com
                Date  : 2012/01/29


USAGE
    exit;
}

sub read_pod {
    my $pod = shift;
    my $cmd = "perldoc ";
    $cmd .= " -m " if $opt{m};
    pod_path $pod if $opt{l};
    $cmd .= $pod;
    print "command: $cmd\n" if $DEBUG;
    system($cmd) and exit;
}

sub pod_path {
    my $path = shift;
    print "path: " if $DEBUG;
    print $path,"\n";
    exit;
}

__END__

=pod

=encoding UTF-8

=head1 NAME

gperldoc - perldoc++

=head1 DESCRIPTION

标准 perldoc 有两题：

=over 4

=item @INC 顺序

标准 perldoc 按照 @INC 路径来搜索模块，这种搜索优先级不利于我们对 pod 进行
编写或者翻译。

=item 模块名称

标准 perldoc 的参数为精确的模块名称，有些时候我们并不知道模块名哪些字母是
大写，哪些字母是小写。又或者我们根本因为大小写混写而浪费时间。所以我们需要
一个更加宽容的参数要求。

=back

=head1 SYNOPSIS

    #gperldoc -v

    #gperldoc -l moose::manual

    #gperldoc -m moose::manual

    #gperldoc run

=head1 Author

xiaomo(wxm4ever@gmail.com)

=cut


use warnings;
use strict 'vars';
use vars qw/%opt $title $index $trees $in $out/;

#use Smart::Comments;
use Carp qw/croak/;
use File::Basename;

#-----------------------------------------------------

sub build_wiki_file {
    my $pod  = shift;
    my ($name, $dir) = fileparse($pod);

    my $wiki     = $out . substr($dir, length($in)) . $name;
    my $wiki_dir = dirname $wiki;
    my $cmd  = "mkdir -p $wiki_dir && pod2text $pod $wiki";
    `$cmd`;
}

sub build_wiki {
    my $root  = shift;
    my @stack = ();
    ### @stack
    opendir IN, $root or croak;
    my @dirs = map { $root . "/" . $_ } 
                 grep { $_ ne "." and $_ ne ".." } readdir IN;
    ### @dirs
    foreach my $file (@dirs) {
        ### FILE: $file
        if (-d $file) {
            unshift @stack, build_wiki($file);
        } elsif (-f $file) {
            next if $file =~ /(pm|pod|pl)^/;
            unshift @stack, $file;
            build_wiki_file($file);
        } else {
            warn "$file is not a standard pod file\n";
        }
    }
    return \@stack;
}

sub writer {
    my ($data, $file) = @_;
    open OUT, ">", $file;
    print OUT $data;
}

sub make_index_html {
    my $html = <<HTML;
<html>
<head>
<title>$title</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<frameset cols="25%,75%">
    <frame src="left.html" />
    <frame name="main" src="$index" />
</frameset>
</html>
HTML
    $html    = eval { $html };
    ### $html
    my $file = "$out/index.html";
    writer $html, $file; 
}

sub get_sider_html {
    my $items = shift;
    my $html  = "<ul>";
    ### @$trees
    foreach my $item (@$items) {
        if (ref $item) {
            # 提取出该级目录名
            my $item_name = basename($item->[0]);
            $item->[0] =~ /(?:.*)\/(.*)\/$item_name/;
            $html = $html . "<li><a>$1</a>"; 
            $html = $html . get_sider_html($item);
            $html = $html . "</li>";
        } else {
            $item = substr $item, length($in)+1;
            $html = $html . "<li><a href=\"$item\" target=\"main\">$item</a></li>";
        }
    }
    $html .= "</ul>";
    return $html;
}

sub make_sider_html {
    my $html = get_sider_html($trees);
    my $file = "$out/left.html";
    writer $html, $file;
}

#-------------------------------------------------------

use Getopt::Std;
getopts('i:t:', \%opt);
### %opt
($title, $index) = ("WiKi", "default.html");
$title = $opt{t} if defined $opt{t};
$index = $opt{i} if defined $opt{i};
($in, $out)      = map { basename $_ } @ARGV;

$trees  = build_wiki($in);
make_index_html();
make_sider_html();

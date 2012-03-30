package BinTree;
use warnings;
use strict 'vars';

package Helper;
sub LVR {
    my ($node, $func) = @_;
    LVR($node->{LEFT}, $func) if defined($node->{LEFT});
    $func->($node->{DATA});
    LVR($node->{RIGHT}, $func) if defined($node->{RIGHT});
}

package TreeNode;
sub new {
    my $class = shift;
    my $self  = {
        DATA    =>  {},
        LEFT    =>  undef,
        RIGHT   =>  undef,
    };
    bless $self, $class;
}

package Tree;
sub new {
    my $class = shift;
    my $self  = {
        NODENUMS    =>  0,
        ROOT        =>  undef,
    };
    bless $self, $class;
}

sub get_nodes_num {
    my $self = shift;
    return $self->{NODENUMS};
}

sub get_root {
    my $self = shift;
    return $self->{ROOT};
}

sub do_LVR {
    my $self = shift;
    my $func = shift;
    return if $self->{NODENUMS} == 0;
    my $root = $self->{ROOT};
    Helper::LVR($root, $func);
}

1;

package main;
my $nodeA = TreeNode->new;
$nodeA->{DATA}->{'data'} = "i'm node A";
my $nodeB = TreeNode->new;
$nodeB->{DATA}->{'data'} = "i'm node B";
my $nodeC = TreeNode->new;
$nodeC->{DATA}->{'data'} = "i'm node C";
$nodeA->{LEFT}  = $nodeB;
$nodeA->{RIGHT} = $nodeC;

my $tree = Tree->new;
$tree->{NODENUMS} = 3;
$tree->{ROOT}     = $nodeA;

use Smart::Comments;
### $tree

my $f = sub {
    my $data = shift;
    print $data->{data}, "\n";
};
$tree->do_LVR($f);

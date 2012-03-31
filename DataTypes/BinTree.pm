package BinTree;
use warnings;
use strict 'vars';

package Helper;
sub METHOD {
    my $param  = shift;
    my $method = {
        LEVEL_VIEW  =>  \&LEVEL_VIEW,
        LVR         =>  \&LVR,
        VLR         =>  \&VLR,
        LRV         =>  \&LRV,
    };
    return $method->{$param};
}

sub LEVEL_VIEW {
    my ($node, $func) = @_;
    use Queue;
    my $queue = Queue->new;
    my $add_node_to_queue; $add_node_to_queue = sub {
        my $node = shift;
        $queue->add($node);
        $add_node_to_queue->($node->{LEFT})  if defined($node->{LEFT});
        $add_node_to_queue->($node->{RIGHT}) if defined($node->{RIGHT});
    };

    $add_node_to_queue->($node);
    while ($queue->size) {
        my $node = $queue->get;
        $func->($node);
    }
}

sub LVR {
    my ($node, $func) = @_;
    LVR($node->{LEFT}, $func) if defined($node->{LEFT});
    $func->($node);
    LVR($node->{RIGHT}, $func) if defined($node->{RIGHT});
}
sub VLR {
    my ($node, $func) = @_;
    $func->($node);
    VLR($node->{LEFT}, $func) if defined($node->{LEFT});
    VLR($node->{RIGHT}, $func) if defined($node->{RIGHT});
}
sub LRV {
    my ($node, $func) = @_;
    LRV($node->{LEFT}, $func) if defined($node->{LEFT});
    LRV($node->{RIGHT}, $func) if defined($node->{RIGHT});
    $func->($node);
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

sub do_recursion_view {
    my ($self, $recursion_method, $func) = @_;
    ### $recursion_method
    return if $self->{NODENUMS} == 0;
    $recursion_method->($self->{ROOT}, $func);
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
    my $node = shift;
    print $node->{DATA}->{data}, "\n";
};
$tree->do_LVR($f);
$tree->do_recursion_view(
    Helper::METHOD("LVR"),
    $f
);
Helper::METHOD("LEVEL_VIEW")->($tree->{ROOT}, $f);

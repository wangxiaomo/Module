package ThreadBinTree;
use warnings;
use strict 'vars';

package TreeNode;
sub new {
    my $class = shift;
    my $self  = {
        DATA    =>  {},
        LTHREAD =>  0,
        RTHREAD =>  0,
        LEFT    =>  undef,
        RIGHT   =>  undef,
    };
    bless $self, $class;
}

package Tree;
sub new {
    my $class = shift;
    my $self  = {
        ROOT    =>  TreeNode->new,
        NODENUMS=>  0,
    };
    bless $self, $class;
}

sub _LVR {
    my $node = shift;
    my $func = shift;
    _LVR($node->{LEFT},  $func) if defined($node->{LEFT});
    $func->($node);
    _LVR($node->{RIGHT}, $func) if defined($node->{RIGHT});
}

sub pretreat {
    my $self = shift;
    return if $self->{NODENUMS} == 0;

    use Queue;
    my $queue     = Queue->new;
    my $root      = $self->{ROOT};
    my $node      = $root->{LEFT};
    my $mark      = sub {
        my $node = shift;
        $queue->add($node);
    };
    _LVR($node, $mark);
    my $nodes = [];
    while($queue->size){
        push @$nodes, $queue->get;
    }
    my $size = scalar @$nodes;
    unshift @$nodes, $root;
    push    @$nodes, $root;
    foreach my $i (1 .. $size){
        if (not defined($nodes->[$i]->{LEFT})) {
            $nodes->[$i]->{LTHREAD} = 1;
            $nodes->[$i]->{LEFT}    = $nodes->[$i-1];
        }
        if (not defined($nodes->[$i]->{RIGHT})) {
            $nodes->[$i]->{RTHREAD} = 1;
            $nodes->[$i]->{RIGHT}   = $nodes->[$i+1];
        }
    }
}   

sub view {
    my ($self, $func) = @_;
    return if $self->{NODENUMS} == 0;
    use Queue;
    my $queue = Queue->new;

    my $root = $self->{ROOT};
    my $walk = sub {
        my $node = shift;
        while($node->{LTHREAD} == 0){
            $node = $node->{LEFT};
        }
        return $node;
    }; 
    
    my $node = $walk->($root->{LEFT});
    $queue->add($node);
    my $next = $node->{RIGHT};
    while($next != $root){
        $queue->add($next);
        $next = $next->{RIGHT};
    }
    
    # thread view inorder
    while($queue->size){
        my $node = $queue->get;
        $func->($node);
    }
}

1;

__END__
package main;
my $nodeA = TreeNode->new;
$nodeA->{DATA}->{data} = "i'm nodeA!";
my $nodeB = TreeNode->new;
$nodeB->{DATA}->{data} = "i'm nodeB!";
my $nodeC = TreeNode->new;
$nodeC->{DATA}->{data} = "i'm nodeC!";

$nodeA->{LEFT}    = $nodeB;
$nodeA->{RIGHT}   = $nodeC;

my $tree = Tree->new;
$tree->{NODENUMS} = 3;
$tree->{ROOT}->{LEFT} = $nodeA;

=comment

$nodeB->{LTHREAD} = 1;
$nodeB->{LEFT}    = $tree->{ROOT};
$nodeB->{RTHREAD} = 1;
$nodeB->{RIGHT}   = $nodeA;
$nodeC->{LTHREAD} = 1;
$nodeC->{LEFT}    = $nodeA;
$nodeC->{RTHREAD} = 1;
$nodeC->{RIGHT}   = $tree->{ROOT};

=cut

my $f = sub {
    my $node = shift;
    print $node->{DATA}->{data}, "\n";
};
$tree->pretreat;
$tree->view($f);

__END__
线索二叉树为了方便加入一个空的头结点。

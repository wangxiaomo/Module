package BinSearchTree;
use warnings;
use strict;

package TreeNode;
sub new {
    my $class = shift;
    my $self  = {
        KEY     =>  0,
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
sub _add {
    my $self = shift;
    my $node = shift;
    if ($self->{NODENUMS} == 0) {
        $self->{ROOT} = $node;
    } else {
        my $root = $self->{ROOT};
        my $key  = $node->{KEY};
        my $walk; $walk = sub {
            my $node = shift;
            if ($key >= $node->{KEY}) {
                return $node unless defined($node->{RIGHT});
                $walk->($node->{RIGHT});
            } else {
                return $node unless defined($node->{LEFT});
                $walk->($node->{LEFT});
            }
        };

        my $target = $walk->($root);
        if ($key >= $target->{KEY}) {
            $target->{RIGHT}  = $node;
        } else {
            $target->{LEFT} = $node;
        }
    }
    $self->{NODENUMS} += 1;
}

sub add {
    my $self = shift;
    foreach my $node (@_) {
        $self->_add($node);
    }
}

sub _LVR {
    my $node = shift;
    my $func = shift;
    _LVR($node->{LEFT},  $func) if defined $node->{LEFT};
    $func->($node);
    _LVR($node->{RIGHT}, $func) if defined $node->{RIGHT};
}

sub do_LVR {
    my $self = shift;
    return if $self->{NODENUMS} == 0;
    my $func = shift;
    _LVR($self->{ROOT}, $func);
}

1;

__END__
package main;
my $tree = Tree->new;
my $nodeA = TreeNode->new;
$nodeA->{KEY} = 2;
my $nodeB = TreeNode->new;
$nodeB->{KEY} = 1;
my $nodeC = TreeNode->new;
$nodeC->{KEY} = 3;
$tree->add($nodeA,$nodeB,$nodeC);

use Smart::Comments;
### $tree
my $f = sub { my $node = shift; print $node->{KEY}, "\n"; };
$tree->do_LVR($f);

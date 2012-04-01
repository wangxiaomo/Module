package Heap;
use warnings;
use strict 'vars';

package DataNode;
sub new {
    my $class = shift;
    my $self  = {
        KEY     =>  0,
    };
    bless $self, $class;
}

package Heap;
sub new {
    my $class = shift;
    my $self  = {
        FLAG    =>  '>',
        DATA    =>  [0,],
    };
    bless $self, $class;
}

sub _add {
    my $self = shift;
    my $data = shift;
    if ($self->{DATA}->[0] == 0) {
        push @{$self->{DATA}}, $data;
    } else {
        my $size   = $self->{DATA}->[0];
        my $op     = $self->{FLAG};
        my $i      = $size+1;
        my $father = int($i/2);
        my $check  = sub {
            my ($a, $b) = @_;
            if ($op eq '>') {
                return $a>$b;
            } else {
                return $a<$b;
            }
        };

        while ($father and $check->($data->{KEY}, $self->{DATA}->[$father])){
            $self->{DATA}->[$i] = $self->{DATA}->[$father];
            $i      = int($i/2);
            $father = int($i/2);
        }
        $self->{DATA}->[$i] = $data;
    }       
    $self->{DATA}->[0] += 1;
}

sub push {
    my $self = shift;
    foreach my $data (@_) {
        $self->_add($data);
    }
}

sub pop {
    my $self = shift;
    return $self->{DATA}->[0]
        if $self->{DATA}->[0] == 0;
    
    my $node = $self->{DATA}->[1];
    $self->{DATA}->[0] -= 1;

    my $size = $self->{DATA}->[0];
    my $last = pop @{$self->{DATA}};
    $self->_add($last);

    return $node;   
}

1;
__END__
package main;
my $heap  = Heap->new;
$heap->{FLAG} = '<';
my $dataA = DataNode->new;
$dataA->{KEY} = 5;
my $dataB = DataNode->new;
$dataB->{KEY} = 3;

$heap->push($dataA,$dataB);
print $heap->{DATA}->[0],"\n";
print $heap->{DATA}->[1]->{KEY},"\n";
print $heap->{DATA}->[2]->{KEY},"\n";

my $node = $heap->pop;
print $node->{KEY}, "\n";

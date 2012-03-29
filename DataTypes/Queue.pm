package Queue;
use warnings;
use strict 'vars';

sub new {
    my $class = shift;
    my $self  = [];
    bless $self, $class;
}

sub add {
    my $self = shift;
    push @$self, @_;
}

sub get {
    my $self = shift;
    shift @$self;
}

sub size {
    my $self = shift;
    scalar @$self;
}

package main;
my $q = Queue->new;
$q->add(1,2,3,4,5);

while(1){
    last unless $q->size;
    my $elem = $q->get;
    print $elem, "\n";
}

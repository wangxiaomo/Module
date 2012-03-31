package Stack;
use warnings;
use strict 'vars';

sub new {
    my $class = shift;
    my $self  = [];
    bless $self, $class;
}

sub stack_push {
    my $self = shift;
    push @$self, @_;
}

sub stack_pop {
    my $self = shift;
    pop @$self;
}

sub size {
    my $self = shift;
    scalar @$self;
}

1;

__END__

package main;
my $s = Stack->new;
$s->stack_push(1, 2, 3, 4, 5);

while(1){
    last unless $s->size;
    my $elem = $s->stack_pop;
    print $elem, "\n";
}

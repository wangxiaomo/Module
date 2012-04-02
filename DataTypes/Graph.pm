package Graph;
use warnings;
use strict 'vars';
use Carp qw/carp croak/;

sub new {
    my $class = shift;
    my $self  = {
        VERTEXS     =>  [],
        EDGES       =>  [],
        VERTEXNUMS  =>  0,
        EDGENUMS    =>  0,
    };
    bless $self, $class;
}

sub _is_in_graph {
    my $self   = shift;
    my $vertex = shift;
    
    #TODO:
} 

sub add_vertex {
    my $self   = shift;
    my $vertex = shift;
    #TODO:
    push @{$self->{VERTEXS}}, $vertex;
    $self->{VERTEXNUMS} += 1;
}

sub add_edge {
    my $self = shift;
    my $edge = shift;
    #TODO:
}

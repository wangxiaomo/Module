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
        VALUEFLAG   =>  0,
    };
    bless $self, $class;
}

sub _is_in_graph {
    my $self   = shift;
    my $vertex = shift;
    
    return grep {
        $vertex eq $_
    } @{$self->{VERTEXS}};
} 

sub add_vertex {
    my $self   = shift;
    my $vertex = shift;
    if (not $self->_is_in_graph($vertex)) {
        carp "Vertex $vertex Have Already Been Added!";
        return;
    }
    push @{$self->{VERTEXS}}, $vertex;
    $self->{VERTEXNUMS} += 1;
}

sub add_edge {
    my $self = shift;
    my $edge = shift;
    #TODO:   
}


use Carp qw/croak/;
use Smart::Comments;

sub sorted {
    my $ref   = shift;
    my $total = scalar @$ref;
    foreach my $k (0..$total-1) {
        return 0
            if grep { $ref->[$k] > $_ } @$ref[$k..$total-1];
    }
    return 1;
}

sub bin_search {
    my ($ref, $target) = @_;
    croak "Not a Reference!"
        if not ref $ref;
    croak "Not a Sorted Array!"
        if not sorted($ref);
    my ($begin, $middle, $end) = 
            (0, 0, scalar @$ref);
    while ($begin <= $end) {
        $middle = int(($begin+$end)/2);
        if ($ref->[$middle] == $target) {
            return $middle;
        } elsif ($ref->[$middle] > $target) {
            $end   = $middle-1;
        } else {
            $begin = $middle+1;
        }
    }
    return -1;
}

#--------------------------------------------
my $a = [1,2,4];
print bin_search($a, 5);

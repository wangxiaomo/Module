
use warnings;
use strict 'vars';
use Smart::Comments;

sub fail {
    my $param = shift;
    my @pat   = ();
    if (ref $param) {
        @pat = @$param;
    } else {
        @pat = split //,$param;
    }
    my $size = scalar @pat;
    my $failures = [-1,];

    foreach my $k (1..$size-1) {
        my $last = $failures->[$k-1];
        if ($pat[$k] eq $pat[$last+1]){
            $failures->[$k] = $last+1;
        } else {
            $failures->[$k] = -1;
        }
    }
    return $failures;
}

sub search {
    my ($str, $pat) = @_;
    my @str  = split //,$str;
    my @pat  = split //,$pat;
    my ($lens, $lenp) = map { scalar @$_ } (\@str, \@pat);
    my $failures = fail(\@pat);
    
    my ($i, $j) = (0,0);
    while ($i<$lens and $j<$lenp) {
        if ($str[$i] eq $pat[$j]) {
            $i++ and $j++;
        } elsif ($j == 0) {
            $i++;
        } else {
            $j = $failures->[$j-1]+1;
        }
    }
    return $j==$lenp?$i-$lenp:-1;
}

my $s = "abcdaabcab";
my $p = "cd";
use Data::Dumper;
print Dumper(fail($p));
print search($s, $p),"\n";

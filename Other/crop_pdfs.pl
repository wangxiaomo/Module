
use warnings;
use strict 'vars';

use Smart::Comments;

my $directory = $ARGV[0]
        or die "HELP: perl $0 TARGET_DIRECTORY\n";
### $directory
# java -jar briss.jar -s 
my $crop_cmd  = $ENV{BRISS}
        or die "please export BRISS environment varible!";

my $pdfs      = get_all_pdfs($directory);
foreach my $pdf (@$pdfs) {
    $pdf =~ s/ /\\ /g;
    my $cmd = $crop_cmd . "\"" . $pdf . "\"";
    print "executing: $cmd\n";
    system $cmd;
}
=comment

in order to prevent the same name's problem.
this program is not for the people who wants to recursion walking.

=cut

sub get_all_pdfs {
    my $path = shift;
    my $dh; opendir $dh, $path
                or die "opendir $path error!";

    my $pdfs = [];
    while (defined(my $file = readdir $dh)) {
        my $pdf_file = $path . $file;
        next if not -f $pdf_file;
        push @$pdfs, $pdf_file if $pdf_file =~ /pdf$/i;
    }
    close $dh;
    return $pdfs;
}


__END__
TODO:
    文件名转义

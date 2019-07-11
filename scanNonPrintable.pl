use strict;
use File::Spec;
doIt(".");
exit;
sub doIt {
    my $dspec = shift;

    opendir(DIR, $dspec);
    my @contents = readdir(DIR);
    closedir DIR;

    foreach my $content (@contents) {
        if($content eq ".git" || $content eq "." || $content eq "..") {
            next;
        }
        my $spec = File::Spec->catfile($dspec, $content);
        if(-d "$spec") {
            doIt($spec);
        }
        else {
            open(IFP, "<$spec");
            my $lines = do { local $/; <IFP> };
            close IFP;
            my $cc = 0;
            my $lc = 0;
            foreach my $c (split //, $lines) {
                my $o = ord($c);
                if(($o >= 32 && $o <= 126) ||
                    $o == 9) {
                    next;
                }
                if($o == 10) {
                    $lc++;
                    next;
                }
                print "$spec (line $lc, char $cc) (char='$c', ord='$o')\n";
                $cc++;
            }
        }
    }
}

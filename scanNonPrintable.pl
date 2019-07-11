use strict;
use File::Spec;
$| = 1;
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
            if($content !~ /\.js$/) {
                next;
            }
            #if(-B "$spec") {
            #    #print "$spec (BINARY)\n";
            #    next;
            #}
            open(IFP, "<$spec");
            my $lines = do { local $/; <IFP> };
            close IFP;
            my $cc = -1;
            my $lc = 1;
            foreach my $c (split //, $lines) {
                $cc++;
                my $o = ord($c);
                if(($o >= 32 && $o <= 126) ||
                    $o == 9) {
                    next;
                }
                if($o == 10) {
                    $cc = -1;
                    $lc++;
                    next;
                }
                print "$spec (line #$lc, line char #$cc, ord='$o')\n";
                last;
            }
        }
    }
}

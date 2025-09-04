#! /usr/bin/perl

use strict;
use Net::SMTP::Multipart;
use threads;
use threads::shared;
use Time::HiRes qw( usleep );

my $confBindir    = '/usr/bin/';

my $sendCount     = 100;
my $sendThread    = 5;
my $sendSleep     = 75000;
my $sendHost      = 'eri.kusastro.kyoto-u.ac.jp';
my $sendFrom      = 'minet@kusastro.kyoto-u.ac.jp';
my $sendDomain    = 'kusastro.kyoto-u.ac.jp';
my $sendTimeout   = 60;
my $sendSubHead   = 'BURST MAIL TEST - ';
my $sendText      = 'test mail.';
my $sendUserList  = 'users.dat';

my %data : shared;

my @sendArrTo;
my ($rand, $mailto, $sbj, $fname);
my @files;

print "Initializing To database.\n";
open(USERS, $sendUserList);
foreach (<USERS>) {
    chomp;
    push(@sendArrTo, $_);
}
close(USERS);

print "Initializing attachment file database.\n";
opendir(DIR, $confBindir);
foreach (readdir(DIR)) {
    $fname = $confBindir . '/' . $_;
    if ((-f $fname) && (-r $fname)) {push(@files, $_); }
}
closedir(DIR);

print <<__END_MES;
Now. OK. Let's go.
Starting burstmail.

------------- BURSTMAIL -------------
ATTACHMENT DATA SRC   : $confBindir
TOTAL MAIL COUNT      : $sendCount
SMTP THREAD COUNT     : $sendThread
SMTP TARGET HOST NAME : $sendHost
MAIL FROM             : $sendFrom
SMTP TARGET DOAMIN    : $sendDomain
__END_MES
$data{'count'} = 0;
for (my $cnt = 0; $cnt < $sendThread; ++$cnt) {
    my $th = threads->new(\&sendMail, $cnt);
    $th->detach;
#    print "Created thread $cnt\n";
}

while (($sendCount == 0) || ($data{'count'} < $sendCount)) {
#    print "Waiting\n";
    usleep($sendSleep);
}

exit;

sub sendMail ($) {
    my ($thid) = @_;
    while (($sendCount == 0) || ($data{'count'} < $sendCount)) {
        my $con = Net::SMTP::Multipart->new($sendHost, Timeout => $sendTimeout);
        $rand = int(rand($#sendArrTo + 1));
        $mailto = $sendArrTo[$rand] . '@' . $sendDomain;
        $rand = int(rand($#files + 1));
        $fname = $confBindir . '/' . $files[$rand];
        $sbj = $sendSubHead . $fname;
        $con->Header(To => $mailto, Subj => $sbj, From => $sendFrom);
        $con->Text($sendText);
        $con->FileAttach($fname);
        $con->quit;

        print "Send mail $data{'count'} by $thid\n";
        ++$data{'count'};
        usleep($sendSleep);
    }
#    print "Thread $thid end\n";
}


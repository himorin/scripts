#! /usr/bin/perl

use strict;

use threads;
use threads::shared;
use Time::HiRes qw/ usleep tv_interval gettimeofday /;
use IO::Socket;
use Carp;

use constant TRUE      => 1;
use constant FALSE     => 0;
use constant HTTP_UA   => "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)";


my $cur_dr : shared;
my $cur_dl : shared;
my $cur_tl : shared;

my $conf_osec : shared;
my $conf_url;
my $conf_unit;

$cur_dl = FALSE;

# command option
my ($copt, $cid, $cval);
$conf_osec = 1; # default 1 sec
$conf_unit = 1; # default 1kb
foreach (@ARGV) {
    $copt = lc($_);
    if ($copt =~ /^-([a-z]+)=([0-9]+)$/) {
        $cid = $1;
        $cval = $2;
        if ($cid eq 'sec') {$conf_osec = $cval; }
        elsif ($cid eq 'unit') {$conf_unit = $cval; }
    } elsif ($copt =~ /^http:\/\//) {
        $conf_url = $copt;
    }
}
$conf_unit *= 1024;

if ($conf_url eq '') {
    &printUsage();
    exit;
}

# connect
my $c_host;
my $c_tout = 2;
if ($conf_url =~ /^http:\/\/([^\/]+)\//) {
    $c_host = $1;
} elsif ($conf_url =~ /^http:\/\/([^\/]+)$/) {
    $c_host = $1;
} else {
    &printUsage();
    print "Cannot use $conf_url\n";
    exit;
}
if (index($c_host, ':') eq -1) {$c_host .= ':80'; }

my $sock = IO::Socket::INET->new($c_host);
if (! defined($sock)) {
    print "Could not connect $conf_url / $c_host\n";
    exit;
}

# start
$cur_dr = 0;
$cur_tl = 0;
$cur_dl = TRUE;
my $th_out = threads->new(\&printDR, 0);
$th_out->detach;

# send request
$c_host =~ s/^([^:]+):[0-9]+$/$1/;
if ($conf_url =~ /^http:\/\/([^\/]+)(\/.*)$/) {$conf_url = $2; }
else {$conf_url = '/'; }
my ($cur_line, $cur_vol);
print "Using URL : $conf_url\n";
print $sock "GET $conf_url HTTP/1.1\n";
print $sock "Host: $c_host\n";
print $sock "User-Agent: " . HTTP_UA . "\n";
print $sock "\n";
while (($cur_line = $sock->getline())) {
    $cur_line =~ s/[\r\n]+$//g;
    if ($cur_line eq '') {last; }
    if ($cur_line =~ /^HTTP\/[^ ]+ (.*)$/) {print "Answer    : $1\n"; }
    if ($cur_line =~ /^Content-Length: ([0-9]+)/i) {print "Length    : $1\n"; }
    if ($cur_line =~ /^Content-Type: (.*)$/i) {print "Type      : $1\n"; }
}
print "START-----\n";
# retrieve data
$cur_line = ' ' x $conf_unit;
while (! $sock->eof) {
    $cur_vol = $sock->read($cur_line, $conf_unit);
    if (! defined($cur_vol)) {next; }
    $cur_dr += $cur_vol / 1024;
}

# final
sleep($conf_osec);
$cur_dl = FALSE;
sleep($conf_osec);
exit;

sub printDR {
    my ($thid) = @_;
    my ($tv_start, $tv_now, $cdr);
    my $pvl = 3;
    while ($cur_dl == TRUE) {
        $tv_start = gettimeofday();
        usleep($conf_osec * 1000000);
        $tv_now = gettimeofday();
        $cdr = $cur_dr;
        $cur_dr = 0;
        $tv_start = $tv_now - $tv_start;
        $cur_tl += $cdr;
        $cdr /= $tv_start;
        print &printVal($tv_start, $pvl) . " sec : " . &printVal($cdr, $pvl) . " kB/s\n";
        $tv_start = $tv_now;
    }
    print "Total data: " . &printVal($cur_tl, $pvl) . "kB\n";
}

sub printVal {
    my ($val, $dig) = @_;
    my $pos = index($val, '.');
    if ($pos == -1) {
        $val .= '.';
        $val .= '0' x $dig;
    } else {
        $pos += $dig + 1;
        $val = substr($val, 0, $pos);
    }
    return $val;
}

sub printUsage {
    print "httpspeed.pl (option) <URL>\n";
    print " option : \"-xxx=val\" (val = number)\n";
    print "   sec   = output interval\n";
    print "   unit  = socket data read unit (kB)\n";
}


#! /usr/bin/perl

use strict;
use Net::SNMP qw(:snmp);
use Time::HiRes qw(gettimeofday usleep tv_interval);
use Data::Dumper;

# ifEntry 1.3.6.1.2.1.2.2.1
# .1.3.6.1.2.1.2.2.1.7.    AdminStatus
# .1.3.6.1.2.1.2.2.1.13.   ifInDiscards
# .1.3.6.1.2.1.2.2.1.14.   ifInErrors
# .1.3.6.1.2.1.2.2.1.19.   ifOutDiscards
# .1.3.6.1.2.1.2.2.1.20.   ifOutErrors
# IF-MIB::ifHCInOctets/IF-MIB::ifHCOutOctets
# .1.3.6.1.2.1.31.1.1.1.6.   Counter64 ifHCInOctets
# .1.3.6.1.2.1.31.1.1.1.10.  Counter64 ifHCOutOctets
my %oids = (
    'stat' => '.1.3.6.1.2.1.2.2.1.7',
    'idis' => '.1.3.6.1.2.1.2.2.1.13',
    'ierr' => '.1.3.6.1.2.1.2.2.1.14',
    'odis' => '.1.3.6.1.2.1.2.2.1.19',
    'oerr' => '.1.3.6.1.2.1.2.2.1.20',
    'ioct' => '.1.3.6.1.2.1.31.1.1.1.6',
    'ooct' => '.1.3.6.1.2.1.31.1.1.1.10',
);
my @oid_out = keys(%oids);

# <script> IP ports_(in,)
if ($#ARGV != 2) {
    print "<script> IP ports_(in,) interval\n";
    print " e.g. <script> 127.0.0.1 10101,10102 60\n";
    exit;
}
my $target_ip = $ARGV[0];
my @target_if = split(/,/, $ARGV[1]);
my $target_iv = $ARGV[2];

my ($session, $error) = Net::SNMP->session(
    -hostname => $target_ip,
    -community => 'public',
    -version => 'snmpv2c',
);
if (! defined $session) {
    print "ERROR on connecting to $target_ip: $error\n";
    exit;
}

my $last_val = {};
# make initial hash
my ($ch, $cif, $ctime, $c_res);
foreach $cif (@target_if) {
    $ch = {};
    foreach (@oid_out) {$ch->{$_} = 0; }
    $last_val->{$cif} = $ch;
}
&PrintHead();
# measure routine overhead
my ($cmst, $cmlen, $cslep);
$cmst = [gettimeofday];
$cmlen = ($target_iv - tv_interval($cmst) - $cmlen) * 1000000;
&PrintLine($cmst, $last_val, $last_val);
$cmlen = tv_interval($cmst);

# loop
while (1) {
    if (defined($ctime)) {
        $cslep = ($target_iv - tv_interval($ctime) - $cmlen) * 1000000;
        if ($cslep > 0.0) {usleep($cslep); }
    }
    $ctime = [gettimeofday];
    $c_res = &GetDefValues($session, \@target_if);
    &PrintLine($ctime, $c_res, $last_val);
}
$session->close();

exit;

sub PrintHead {
    my ($tif, $toid);
    print "TIME(msec): ";
    foreach $tif (@target_if) {
        foreach $toid (@oid_out) {
            print "$tif.$toid diff ";
        }
    }
    print "\n";
}

sub PrintLine {
    my ($ctime, $chash, $ohash) = @_;
    printf "%d.%06d: ", $ctime->[0], $ctime->[1];
    my ($tif, $toid, $cv, $ov);
    foreach $tif (@target_if) {
        foreach $toid (@oid_out) {
            $cv = $chash->{$tif}->{$toid};
            $ov = $ohash->{$tif}->{$toid};
            print $cv . " " . ($cv - $ov) . " ";
            $ohash->{$tif}->{$toid} = $cv;
        }
    }
    print "\n";
}

sub GetDefValues {
    my ($session, $if) = @_;
    my $res = {};
    my ($ckey, $coid, $cres, $chash);
    foreach (keys %oids) {
        $ckey = $_;
        $coid = $oids{$ckey};
        if (! defined($cres = &GetSNMPTable($session, $coid))) {
            next;
        }
        foreach (@$if) {
            if (defined($res->{$_})) {$chash = $res->{$_}; }
            else {$chash = {}; }
            if (defined($cres->{$coid . '.' . $_})) {
                $chash->{$ckey} = $cres->{$coid . '.' . $_};
            }
            $res->{$_} = $chash;
        }
    }
    return $res;
}

sub GetSNMPTable {
    my ($session, $oid) = @_;
    return $session->get_table( -baseoid => $oid );
}


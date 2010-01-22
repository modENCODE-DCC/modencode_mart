#!/usr/bin/perl
use strict;
my $root_dir;
BEGIN {
  $root_dir = $0;
  $root_dir =~ s/[^\/]*$//;
  $root_dir = "./" unless $root_dir =~ /\//;
  push @INC, $root_dir;
}

use Config::IniFiles;
use Getopt::Long;
use ModENCODE::Parser::LWChado;

print "initializing...\n";
my ($unique_id, $config, $no_insert, $no_create, $force);
$no_insert=1;
$no_create=1;
$force=0;
$config = $root_dir . 'chado2mart.ini';
my $option = GetOptions ("unique_id=s"    => \$unique_id,
                         "config=s"       => \$config,
			 "no_insert=i"      => \$no_insert,
			 "no_create=i"      => \$no_create,
			 "force_recreate=i" => \$force    ) or usage();
usage() unless defined($unique_id);
usage() unless -e $config;
my %ini;
tie %ini, 'Config::IniFiles', (-file => $config);
print $no_insert;
print $no_create;
print $force;
####ok##########




sub usage {
    my $usage = qq[$0 -unique_id <submission_id> -config <config_file> --no_insert <0|1> --no_create <0|1> --force_recreate <0|1>];
    print "Usage: $usage\n";
}

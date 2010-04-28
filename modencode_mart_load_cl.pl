#!/usr/bin/perl
use strict;
use warnings;

my ($root_dir, $schema_dump_dir);
BEGIN {
  $root_dir = $0;
  $root_dir =~ s/[^\/]*$//;
  $root_dir = "./" unless $root_dir =~ /\//;
  $schema_dump_dir = $root_dir . 'Mart';
  push @INC, $root_dir;
  push @INC, $schema_dump_dir;
}

use Data::Dumper;
use Config::IniFiles;
use Getopt::Long;
use ModENCODE::Parser::LWChado;
use GEO::LWReporter;
use Loader::TransfacTranscriptionalFactorMain_Loader;
use Loader::TransfacBindingSitesMain_Loader;
use Loader::TransfacDevelopmentalStageDm_Loader;
use Loader::TransfacTissueDm_Loader;

print "initializing...\n";
my ($unique_id, $config, $gff, $species, $pname, $devstage, $tissue, $sex);
$config = $root_dir . 'config/modencode_mart.ini';
my $option = GetOptions ("unique_id=s"    => \$unique_id,
                         "config=s"       => \$config,
			 "gff=s"          => \$gff,
			 "species=s"      => \$species,
			 "tf=s"           => \$pname,
                         "devstage=s"     => \$devstage,
                         "tissue=s"       => \$tissue,
                         "sex=s"          => \$sex) or usage();
usage() unless defined($unique_id);
usage() unless -e $config;
usage() unless defined($species) && ($species eq 'fly' || $species eq 'worm');
usage() unless defined($pname);
usage() unless defined($gff);
usage() unless defined($devstage) || defined($tissue);
usage() unless defined($sex);

$species = 'Caenorhabditis elegans' if lc($species) eq 'worm';
$species = 'Drosophila melanogaster' if lc($species) eq 'fly';

my %ini;
tie %ini, 'Config::IniFiles', (-file => $config);


my $tfl = new Loader::TransfacTranscriptionalFactorMain_Loader({
    dcc_id => $unique_id,
    config => \%ini,
    species => $species,
    pname => $pname 
});
$tfl->info;
my $tf = $tfl->load; #a tf table dbix::class 

if ($devstage) {
    my $devl = new Loader::TransfacDevelopmentalStageDm_Loader({
	config => \%ini,
	tf_id_key => $tf->tf_id_key,
	official_name => $devstage,
	species => $species,
	sex => $sex
    });
    $devl->load();
}

if ($tissue) {
    my $tl = new Loader::TransfacTissueDm_Loader({
	config => \%ini,
	tf_id_key => $tf->tf_id_key,
	official_name => $tissue,
	species => $species,
	sex => $sex	
    });
    $tl->load();
}

my $bsl = new Loader::TransfacBindingSitesMain_Loader({
    config => \%ini,
    species => $species,
    tf_id_key => $tf->tf_id_key
});
$bsl->load($gff);


sub usage {
    my $usage = qq[$0 -unique_id <submission_id> -config <config_file> -species <worm|fly> -tf <trancription factor> -devstage <development stage> -sex <sex> -cellline <cellline> -gff <gff3 file>];
    print "Usage: $usage\n";
    exit 2;
}

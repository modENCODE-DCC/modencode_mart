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
use Pipeline::Pipeline;

print "initializing...\n";
my ($unique_id, $config, $no_insert, $no_create, $force, $gff);
$no_insert=1;
$no_create=1;
$force=0;
$config = $root_dir . 'config/modencode_mart.ini';
my $option = GetOptions ("unique_id=s"    => \$unique_id,
                         "config=s"       => \$config,
			 "no_insert=i"      => \$no_insert,
			 "no_create=i"      => \$no_create,
			 "force_recreate=i" => \$force,
			 "gff=s" => \$gff) or usage();
usage() unless defined($unique_id);
usage() unless -e $config;
my %ini;
tie %ini, 'Config::IniFiles', (-file => $config);

my $pipe = new Pipeline::Pipeline({
    'config' => \%ini});
my ($reader, $experiment) = $pipe->load_experiment($unique_id);
print $experiment->to_string();

####ok##########
my $reporter = new GEO::LWReporter({
    'unique_id' => $unique_id,
    'reader' => $reader,
    'experiment' => $experiment});
$reporter->set_all();
######need ModENCODE::Chado::Data object for tgt_gene, strain, devstage, cellline, etc.

my $species = $reporter->get_organism();
my $pname = $reporter->get_tgt_gene();
my $devstage = $reporter->get_devstage();
my $sex = $reporter->get_sex();
my $antibody = $reporter->get_antibody();
print $pname;
print $devstage;
print $sex;
print $antibody;
$pname = $antibody unless $pname;

my $tfl = new Loader::TransfacTranscriptionalFactorMain_Loader({
    dcc_id => $unique_id,
    config => \%ini,
    species => $species,
    pname => $pname 
});
$tfl->info;
my $tf = $tfl->load; #a tf table dbix::class 
for my $col (qw[tf_id_key
                dcc_id
                species 
                gene_id 
                public_name
                tf_chromosome_name
                tf_chromosome_start
                tf_chromosome_end
                tf_chromosome_strand
                ]) {
    print $tf->$col, "\n";
}

my $devl = new Loader::TransfacDevelopmentalStageDm_Loader({
    config => \%ini,
    tf_id_key => $tf->tf_id_key,
    official_name => $devstage,
    species => $species,
    sex => $sex
});
$devl->load();

my $bsl = new Loader::TransfacBindingSitesMain_Loader({
    config => \%ini,
    species => $species,
    tf_id_key => $tf->tf_id_key
});

$gff = $pipe->download_gff() unless $gff;
$bsl->load($gff);

###cool till this, loaded tf, devstage, bs, bs_gene 4 table!!!
###shall try the mart interface.

sub usage {
    my $usage = qq[$0 -unique_id <submission_id> -config <config_file> --no_insert <0|1> --no_create <0|1> --force_recreate <0|1>];
    print "Usage: $usage\n";
    exit 2;
}

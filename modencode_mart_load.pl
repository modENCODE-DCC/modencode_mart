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

print "initializing...\n";
my ($unique_id, $config, $no_insert, $no_create, $force);
$no_insert=1;
$no_create=1;
$force=0;
$config = $root_dir . 'config/modencode_mart.ini';
my $option = GetOptions ("unique_id=s"    => \$unique_id,
                         "config=s"       => \$config,
			 "no_insert=i"      => \$no_insert,
			 "no_create=i"      => \$no_create,
			 "force_recreate=i" => \$force    ) or usage();
usage() unless defined($unique_id);
usage() unless -e $config;
my %ini;
tie %ini, 'Config::IniFiles', (-file => $config);

my ($reader, $experiment) = load_experiment(\%ini, $unique_id);
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
print $pname;
my $tfl = new Loader::TransfacTranscriptionalFactorMain_Loader({
    config => \%ini,
    species => $species,
    pname => $pname
});
$tfl->info;
my $tf = $tfl->load; #a tf table dbix::class 
for my $col (qw[tf_id_key
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
###cool till this 



sub load_experiment {
    my ($ini, $id) = @_;
    my $name = $ini->{pipeline}{dbname};
    my $host = $ini->{pipeline}{host};
    my $user = $ini->{pipeline}{username};
    my $pass = $ini->{pipeline}{password};
    my $reader = new ModENCODE::Parser::LWChado({
	'dbname' => $name,
	'host' => $host,
	'username' => $user,
	'password' => $pass});
    #search path for this dataset, this is fixed by modencode chado db
    #my $schema = $ini->{pipeline}{pathprefix}. $unique_id . $ini->{pipeline}{pathsuffix} . ',' . $ini->{pipeline}{schema};
    my $schema = $ini->{pipeline}->{schema};
    my $experiment_id = $reader->set_schema($schema);
    print "connected schema $schema.\n";
    print "loading experiment ...";
    $reader->load_experiment($experiment_id);
    my $experiment = $reader->get_experiment();
    print "done\n";
    return ($reader, $experiment);
};



sub usage {
    my $usage = qq[$0 -unique_id <submission_id> -config <config_file> --no_insert <0|1> --no_create <0|1> --force_recreate <0|1>];
    print "Usage: $usage\n";
    exit 2;
}

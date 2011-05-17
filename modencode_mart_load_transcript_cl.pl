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
use Loader::TranscriptionFeatureMain_Loader;
#use Loader::

print "initializing...\n";
#my ($unique_id, $config, $gff, $species, $pname, $devstage, $tissue, $sex);
my ($unique_id, $config, $gff, $species, $devstage, $tissue, $sex);
$config = $root_dir . 'config/modencode_transcriptome.ini';
my $option = GetOptions ("id=s"           => \$unique_id,
                         "config:s"       => \$config,
			 "gff=s"          => \$gff,
			 "sp=s"           => \$species,
			 #"tf=s"           => \$pname,
                         "devstage:s"     => \$devstage,
                         "tissue:s"       => \$tissue,
                         "sex:s"          => \$sex) or usage();
usage("unique submission id needed.") unless defined($unique_id);
usage("configure file $config not exists.") unless -e $config;
usage("please specify the species.") unless defined($species);
#usage() unless defined($pname);
usage("gff file $gff not exists.") unless -e $gff;
#usage("please specify devstage or tissue.") unless defined($devstage) || defined($tissue);
#usage() unless defined($sex);
my %ini;
tie %ini, 'Config::IniFiles', (-file => $config);

$species = uniform_species($species);
$devstage = uniform_devstage($devstage);
$tissue = uniform_tissue($tissue);
$sex = uniform_sex($sex);

my $fl = new Loader::TranscriptionFeatureMain_Loader({
    config => \%ini,
    dcc_id => $unique_id,
    species => $species,
    devstage => $devstage,
    tissue => $tissue,
    sex => $sex
});
$fl->load($gff);


sub usage {
    my $hint = shift;
    my $usage = qq[$0 -id <submission_id> -cfg <config_file> -sp <species> -devstage <development stage> -sex <sex> -tissue <tissue> -gff <gff3 file>];
    print "Usage: $usage\n";
    print "$hint\n";
    exit 2;
}

sub uniform_species {
    my $sp = lc(shift);
    my %map = ('worm' => 'Caenorhabditis elegans',
	       'fly' => 'Drosophila melanogaster');
    return $map{$sp} if exists $map{$sp};
    return undef;
}

sub uniform_devstage {
    my $devstage = lc(shift);
    return $devstage;
}

sub uniform_tissue {
    my $tissue = lc(shift);
    return $tissue;
}

sub uniform_sex {
    my $sex = lc(shift);
    return $sex;
}

package Loader::TranscriptionFeatureMain_Loader;
#this package shall accept a GFF3Rec and populate Transcritome__Feature__main
#table. return a feature_id_key

use strict;
use warnings;
use Carp qw/croak/;
use Data::Dumper;
use Class::Std;
use base 'Loader';
use Schema;
use GFF3::GFF3Rec;
use Loader::TranscriptionFeatureFeatureDm_Loader;

my %dcc_id         :ATTR( :name<dcc_id>        :default<undef>);
my %config         :ATTR( :name<config>        :default<undef>);
my %species        :ATTR( :name<species>       :default<undef>);
my %devstage       :ATTR( :name<devstage>      :default<undef>);
my %tissue         :ATTR( :name<tissue>        :default<undef>);
my %sex            :ATTR( :name<sex>           :default<undef>);
my %db             :ATTR( :name<db>            :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config dcc_id species]) {
        my $v = $args->{$p};
        defined $v || croak 'need parameter $p';
        my $f = "set_" . $p;
        $self->$f($v);
    }
    for my $p (qw[devstage tissue sex]) {
        my $v = $args->{$p};
	if (defined $v) {
	    my $f = "set_" . $p;
	    $self->$f($v);
	}
    }    
    my $db = $self->connect_gff();
    $self->set_db($db);
    return $self;
}

sub load {
    my ($self, $gff) = @_;
    #use the 'mart' part in config
    my $schema = Schema->connect($self->connectinfo('mart'));
    my $annodbh = $self->get_db();
    my @columns = qw[dcc_id
                     species
                     ts_chromosome_name
                     ts_chromosome_start
                     ts_chromosome_end
                     ts_chromosome_strand
                     ts_type
                     assembly_version
                     ts_length
                    ];
    
    my $p = __PACKAGE__; $p =~ s/^Loader:://; $p =~ s/_Loader$//;
    my $ts_rs = $schema->resultset($p);
    my $assembly_version;
    my $dcc_id = $self->get_dcc_id();
    my $species = $self->get_species();
    my $devstage = $self->get_devstage();
    my $tissue = $self->get_tissue();
    my $sex = $self->get_sex();

    open my $gffh, "<", $gff;    
    while(my $line = <$gffh>) {
	chomp $line;
	next if $line =~ /^\s*$/;
	if ($line =~ /^##genome-build/) {
	    my @flds = split /\s+/, $line;
	    $assembly_version = $flds[-1];
	}
	if ($line !~ /^#/) {
	    my $rec = new GFF3::GFF3Rec({line => $line});
	    my $st = $rec->get_start(),
	    my $end = $rec->get_end(),
	    my @data = ($dcc_id
			$species,
			$rec->get_seqid(),
			$st,
			$end,
			$rec->get_strand(),
			$rec->get_type(),
			$assembly_version,
			abs($st-$end+1),
		);
	    my ($ts) = $ts_rs->populate([\@columns,
					 \@data
					]);
	    my $tsell = new Loader::TranscriptionExpressionLevelDm_Loader({config => $self->get_config(),
									   species => $species,
									   devstage => $devstage,
									   tissue => $tissue,
									   sex => $sex,
									   ts_id_key => $ts->ts_id_key,
									   prediction_status => $rec->get_prediction_status(),
									   expression_length => $rec->get_dpcm_bases(),
									   expression_level => $rec->get_dpcm(),
									  });
	    $tsell->load();
	}
    }
}

1;

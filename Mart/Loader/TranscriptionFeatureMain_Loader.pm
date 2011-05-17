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
    my $self = shift;
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
                     prediction_status
                    ];
    my $p = __PACKAGE__; $p =~ s/^Loader:://; $p =~ s/_Loader$//;
}

1;

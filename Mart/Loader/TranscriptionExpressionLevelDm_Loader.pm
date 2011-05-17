package Loader::TranscriptionFeatureMain_Loader;
#this package shall accept a GFF3Rec and populate Transcritome__Feature__main
#table. return a feature_id_key

use strict;
use warnings;
use Carp qw/croak/;
use Class::Std;
use base 'Loader';
use Schema;

my %dcc_id         :ATTR( :name<dcc_id>        :default<undef>);
my %config         :ATTR( :name<config>        :default<undef>);
my %species        :ATTR( :name<species>       :default<undef>);
my %db             :ATTR( :name<db>            :default<undef>);


sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config dcc_id species]) {
        my $v = $args->{$p};
        defined $v || croak 'need parameter $p';
        my $f = "set_" . $p;
        $self->$f($v);
    }
    my $db = $self->connect_gff();
    $self->set_db($db);
    return $self;
}

sub load {
    my $self = shift;
    #use the 'mart' part in config
    my $schema = Schema->connect($self->connectinfo('mart'));
    
}

1;

package Loader::TranscriptionExpressionLevelDm_Loader;

use strict;
use warnings;
use Carp qw/croak/;
use Class::Std;
use base 'Loader';
use Schema;

my %config         :ATTR( :name<config>        :default<undef>);
my %species        :ATTR( :name<species>       :default<undef>);
my %devstage       :ATTR( :name<devstage>      :default<undef>);
my %tissue         :ATTR( :name<tissue>        :default<undef>);
my %sex            :ATTR( :name<sex>           :default<undef>);
my %ts_id_key      :ATTR( :name<ts_id_key>     :default<ts_id_key>);
my %expression_length      :ATTR( :name<expression_length>       :default<undef> );
my %expression_level            :ATTR( :name<expression_level>             :default<undef> );
my %prediction_status :ATTR( :name<prediction_status> :default<undef> );


sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config species ts_id_key]) {
        my $v = $args->{$p};
        defined $v || croak 'need parameter $p';
        my $f = "set_" . $p;
        $self->$f($v);
    }
    for my $p (qw[devstage tissue sex expression_length expression_level prediction_status]) {
        my $v = $args->{$p};
	if (defined $v) {
	    my $f = "set_" . $p;
	    $self->$f($v);
	}
    }     
    return $self;
}

sub load {
    my $self = shift;
    #use the 'mart' part in config
    my $schema = Schema->connect($self->connectinfo('mart'));
    my @columns = qw[ts_id_key
                     express_length
                     express_level
                     prediction_status
                     devstage
                     tissue
                     sex 
                    ];
    my $p = __PACKAGE__; $p =~ s/^Loader:://; $p =~ s/_Loader$//;
    my $exp_rs = $schema->resultset($p);
    my @data = ($self->get_ts_id_key,
		$self->get_express_length,
		$self->get_express_level,
		$self->get_prediction_status,
		$self->get_devstage,
		$self->get_tissue,
		$self->get_sex
	);
    my ($exp) = $exp_rs->populate([\@columns,
				   \@data
				  ]);
    return $exp->expression_level_id;
}

1;

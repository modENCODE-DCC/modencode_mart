package Loader::TransfacDevelopmentalStageDm_Loader;

use strict;
use warnings;
use Carp qw/croak/;
use Data::Dumper;
use Class::Std;
use base 'Loader';
use Schema;

my %config    :ATTR(:name<config>     :default<undef>);
my %tf_id_key :ATTR(:name<tf_id_key>  :default<undef>);
my %official_name :ATTR(:name<official_name>   :default<undef>);
my %species   :ATTR( :name<species>       :default<undef>);
my %sex      :ATTR( :name<sex>       :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config species tf_id_key sex official_name]) {
	my $v = $args->{$p};
	defined $v || croak 'need parameter $p';
	my $f = "set_" . $p;
	$self->$f($v);
    }
    return $self;
}

sub load {
    my ($self) = @_;
    my $schema = Schema->connect($self->connectinfo('mart'));
    my @columns = qw[tf_id_key
                     official_name
                     species
                     sex
                    ];
    my @data = ($self->get_tf_id_key,
		$self->get_official_name,
		$self->get_species,
		$self->get_sex
	);
    my $p = __PACKAGE__; $p =~ s/^Loader:://; $p =~ s/_Loader$//;
    my $dev_rs = $schema->resultset($p);
    $dev_rs->populate([\@columns,
		       \@data
		      ]);
}

1;

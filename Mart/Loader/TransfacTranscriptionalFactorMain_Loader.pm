package Loader::TransfacTranscriptionalFactorMain_Loader;
#this package shall know how to get info to populate a 
#TransfacTranscriptionalFactorMain object

use strict;
use warnings;
use Carp qw/croak/;
use Data::Dumper;
use Class::Std;
use base 'Loader';
use Schema;

my %dcc_id         :ATTR( :name<dcc_id>        :default<undef>);
my %config         :ATTR( :name<config>        :default<undef>);
my %species        :ATTR( :name<species>       :default<undef>);
my %id             :ATTR( :name<id>            :default<undef>);
my %pname          :ATTR( :name<pname>         :default<undef>);
my %chr_name       :ATTR( :name<chr_name>      :default<undef>);
my %chr_st         :ATTR( :name<chr_st>        :default<undef>);
my %chr_end        :ATTR( :name<chr_end>       :default<undef>);
my %chr_strand     :ATTR( :name<chr_strand>    :default<undef>);
my %desc           :ATTR( :name<desc>          :default<undef>);
my %db             :ATTR( :name<db>        :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config dcc_id species pname]) {
	my $v = $args->{$p};
	defined $v || croak 'need parameter $p';
	my $f = "set_" . $p;
	$self->$f($v);
    }
    my $db = $self->connect_gff();
    $self->set_db($db);
    return $self;
}

sub info {
    my $self = shift;
    my $db = $self->get_db();
    my $name = $self->get_pname();
    my @f = $db->get_features_by_name($name);
    unless (scalar(@f) == 1) {
	warn("more than one feature share the name $name");
    }
    my $f = $f[0];
    print Dumper($f);
    my $load_id = $f->load_id;
    $load_id =~ s/^Gene://g;
    $self->set_id($load_id);
    $self->set_chr_st($f->start);
    $self->set_chr_end($f->end);
    $self->set_chr_strand($f->strand);
    $self->set_chr_name($f->seq_id);
}

sub load {
    my $self = shift;
    my $schema = Schema->connect($self->connectinfo('mart'));
    my @columns = qw[species 
                     gene_id
                     public_name
                     tf_chromosome_name
                     tf_chromosome_start
                     tf_chromosome_end
                     tf_chromosome_strand
                     dcc_id
                     ];
    my @data = ($self->get_species,
		$self->get_id,
		$self->get_pname,
		$self->get_chr_name,
		$self->get_chr_st,
		$self->get_chr_end,
		$self->get_chr_strand,
		$self->get_dcc_id,
	);
    my $p = __PACKAGE__; $p =~ s/^Loader:://; $p =~ s/_Loader$//;
    my $tf_rs = $schema->resultset($p);
    my ($tf) = $tf_rs->populate([\@columns,
				 \@data
				]);
    print Dumper($tf);
    return $tf;
}

1;

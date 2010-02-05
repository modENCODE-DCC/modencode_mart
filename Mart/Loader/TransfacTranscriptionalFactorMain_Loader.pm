package Loader::TransfacTranscriptionalFactorMain_Loader;
#this package shall know how to get info to populate a 
#TransfacTranscriptionalFactorMain object

use strict;
use warnings;
use Carp qw/croak/;
use Class::Std;
use base 'Loader';

my %config         :ATTR( ;name<config>        :default<undef>);
my %species        :ATTR( :name<species>       :default<undef>);
my %id             :ATTR( :name<id>            :default<undef>);
my %pname          :ATTR( :name<pname>         :default<undef>);
my %chr_name       :ATTR( :name<chr_name>      :default<undef>);
my %chr_st         :ATTR( :name<chr_st>        :default<undef>);
my %chr_end        :ATTR( :name<chr_end>       :default<undef>);
my %chr_strand     :ATTR( :name<chr_strand>    :default<undef>);
my %desc           :ATTR( :name<desc>          :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config species pname]) {
	my $v = $args->{$p};
	defined $v || croak 'need parameter $p';
	my $f = "set_" . $p;
	$self->$f($v);
    }
    $self->connect();
    return $self;
}

sub id {
}

sub chr {
}

sub desc {
}

1;

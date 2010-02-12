package Loader;

use strict;
use warnings;
use Carp qw/croak/;
use Data::Dumper;
use Class::Std;
use Bio::DB::SeqFeature::Store;

my %config         :ATTR( :name<config>        :default<undef>);
my %species        :ATTR( :name<species>       :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config species]) {
	my $v = $args->{$p};
	my $f = "set_" . $p;
	$self->$f($v) if defined $v;
    }
    return $self;
}

sub connectinfo {
    my ($self, $name) = @_;
    my $dbtype = $config{ident $self}->{$name}->{type};
    my $dbname = $config{ident $self}->{$name}->{name};
    my $host = $config{ident $self}->{$name}->{host};
    my $port = $config{ident $self}->{$name}->{port};
    my $user = $config{ident $self}->{$name}->{user};
    my $pass = $config{ident $self}->{$name}->{password};
    my $dsn = "dbi:$dbtype:dbname=$dbname;host=$host;port=$port";
    return ($dsn, $user, $pass);
}

sub connect_gff {
    my $self = shift;
    my $organism;
    if ($species{ident $self} eq 'Caenorhabditis elegans') {
	$organism = 'worm';
    }
    if ($species{ident $self} eq 'Drosophila melanogaster') {
	$organism = 'fly';
    }

    my ($dsn, $user, $pass) = $self->connectinfo($organism);

    my $db = Bio::DB::SeqFeature::Store->new(-dsn  => $dsn,
					     -user => $user,
					     -pass => $pass);
    return $db;
}

1;

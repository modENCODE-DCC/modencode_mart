package Loader::Loader;

use strict;
use warnings;
use Class::Std;
use Bio::DB::Seqfeature::Store;

my %config         :ATTR( ;name<config>        :default<undef>);
my %species        :ATTR( :name<species>       :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config species]) {
	my $v = $args->{$p};
	defined $v || croak 'need parameter $p';
	my $f = "set_" . $p;
	$self->$f($v);
    }
    return $self;
}

sub connect {
    my $self = shift;
    my $organism;
    if ($species{ident $self} eq 'Caenorhabditis elegans') {
	$organism = 'worm';
    }
    if ($species{ident $self} eq 'Drosophila melanogaster') {
	$organism = 'fly';
    }    
    my $dbtype = $config{ident $self}->{$organism}->{type};
    my $dbname = $config{ident $self}->{$organism}->{name};
    my $host = $config{ident $self}->{$organism}->{host};
    my $port = $config{ident $self}->{$organism}->{port};
    my $user = $config{ident $self}->{$organism}->{user};
    my $password = $config{ident $self}->{$organism}->{password};
    my $adaptor = "DBI::$dbtype";
    my $dsn = "dbi:$dbtype:dbname=$dbname;host=$host;port=$port";
    my $db = Bio::DB::SeqFeature::Store->new( -adaptor => $adaptor,
					      -dsn     => $dsn,
					      -create  => 1 );
    return $db;
}

1;

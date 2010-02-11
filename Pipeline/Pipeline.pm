package Pipeline::Pipeline;
use strict;
use warnings;
use Carp qw/croak/;
use Data::Dumper;
use Class::Std;
use ModENCODE::Parser::LWChado;

my %config         :ATTR( :name<config>        :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config]) {
	my $v = $args->{$p};
	defined $v || croak 'need parameter $p';
	my $f = "set_" . $p;
	$self->$f($v);
    }
    return $self;
}

sub load_experiment {
    my ($self, $id) = @_;
    my $ini = $self->get_config();
    my $name = $ini->{pipeline}{dbname};
    my $host = $ini->{pipeline}{host};
    my $user = $ini->{pipeline}{username};
    my $pass = $ini->{pipeline}{password};
    my $reader = new ModENCODE::Parser::LWChado({
	'dbname' => $name,
	'host' => $host,
	'username' => $user,
	'password' => $pass});
    #search path for this dataset, this is fixed by modencode chado db
    #my $schema = $ini->{pipeline}{pathprefix}. $unique_id . $ini->{pipeline}{pathsuffix} . ',' . $ini->{pipeline}{schema};
    my $schema = $ini->{pipeline}->{schema};
    my $experiment_id = $reader->set_schema($schema);
    print "connected schema $schema.\n";
    print "loading experiment ...";
    $reader->load_experiment($experiment_id);
    my $experiment = $reader->get_experiment();
    print "done\n";
    return ($reader, $experiment);
};    

sub 

1;

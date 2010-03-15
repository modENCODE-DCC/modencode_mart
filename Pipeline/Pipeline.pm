package Pipeline::Pipeline;
use strict;
use warnings;
use Carp qw/croak/;
use Data::Dumper;
use Class::Std;
use ModENCODE::Parser::LWChado;
use LWP::UserAgent;

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

###the following code are taken from Lincoln's AWG script for downloading gff
###small changes are made
sub download_gff {
    my ($self, $id) = @_;
    my $ini = $self->get_config();
    my $url = $ini->{gff}->{url};
    my $save = $ini->{gff}->{save};
    $url .= '/' unless $url =~ /\/$/;
    $save .= '/' unless $save =~ /\/$/;
    my $agent = LWP::UserAgent->new();
    _traverse($agent, $url, $id, $save);
}

sub _traverse {
    my ($agent, $url, $id, $save) = @_;
    warn "Traversing $url\n";

    my $response = $agent->get($url);
    unless ($response->is_success) {
        warn "FAILED: ",$response->status_line;
        return;
    }
    my $content   = $response->decoded_content;
    $content      =~ s/&amp;/&/g;
    my ($head,$base) = $url =~ m!^(http://[^/]+)(/[^?]+)!;
    my @dirs         = $content =~ /"($base\?path=.+&root=extracted)"/g;
    my @gff_files    = $content =~ m!href="(.+/get_file/.+\.gff.*?)"!ig;
    @dirs            = grep {!/ws\d+/} @dirs;  # do NOT pick up prelifted files
    _traverse($agent, "$head$_", $save) foreach @dirs;
    _download($agent, "$head$_", $save) foreach @gff_files;
}

sub _download {
    my ($agent, $url, $id, $save) = @_;
    warn "Downloading $url\n";
    my ($id,$fname) = $url =~ /\/(\d+)\/.+?([^\/]+)$/;
    my $dest = $save . $id . '.' . $fname;
    unless (-e $dest) {
	my $response = $agent->mirror($url, $dest);
	unless ($response->is_success) {
	    warn "FAILED: ",$response->status_line;
	    return;
	}
	else {
	    warn "$url => $dest\n";
	}    
    }
}

1;

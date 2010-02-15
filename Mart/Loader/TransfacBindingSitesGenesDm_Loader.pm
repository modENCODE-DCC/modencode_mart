package Loader::TransfacBindingSitesGenesDm_Loader;
#this package shall provide a function that can be called 
#when load TransfacBindingSites table to 
#load the distance to binding sites nearby features into TransfacBindingSitesGenes table.

use strict;
use warnings;
use Carp qw/croak/;
use Data::Dumper;
use Class::Std;
use base 'Loader';
use Schema;

my %config    :ATTR(:name<config>     :default<undef>);
my %species   :ATTR(:name<species>       :default<undef>);
my %bs_id_key :ATTR(:name<bs_id_key>  :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config species bs_id_key]) {
	my $v = $args->{$p};
	defined $v || croak 'need parameter $p';
	my $f = "set_" . $p;
	$self->$f($v);
    }
    return $self;
}

sub load {
    #accept a bio-db-seqfeature handle, a gff3rec obj.
    my ($self, $db, $rec) = @_;

    my $schema = Schema->connect($self->connectinfo('mart'));
    my $p = __PACKAGE__; $p =~ s/^Loader:://; $p =~ s/_Loader$//;
    my $bsg_rs = $schema->resultset($p);    

    my @columns = qw[bs_id_key
                     gene_id
                     distance
                    ];

    my $cutoff = $self->get_config()->{'mart'}{'distance_cutoff'};
    print "distance cutoff: $cutoff\n";
    my ($chr, $bs_st, $bs_end) = ($rec->get_seqid(),
				  $rec->get_start(),
				  $rec->get_end()
	);
    my $bs_pt = ($bs_st + $bs_end) / 2; #integer!
    my $rg_min = $bs_pt - $cutoff > 0 ? $bs_pt - $cutoff : 0;
    my $rg_max = $bs_pt + $cutoff;
    print "region: center $bs_pt, min $rg_min, max $rg_max\n";
    #more location, feature type control could go into here
    my $it = $db->segment($chr, $rg_min, $rg_max)->get_seq_stream(-type => 'gene');
    while (my $ft = $it->next_seq) {
	print "Warning!!! a gene in gff3 db contains no id.\n", Dumper($ft) unless defined($ft->id);
	print "Warning!!! a gene in gff3 db contains no load_id.\n", Dumper($ft) unless defined($ft->load_id);
	if ( defined($ft->id) ) {
	    my $dst = abs(($ft->start + $ft->end) / 2 - $bs_pt);
	    print join(" ", ('Gene', $ft->id, $ft->load_id, 'distance', $dst, "\n"));
	    my @data = ($self->get_bs_id_key,
			$ft->load_id,
			$dst
		);
	    $bsg_rs->populate([\@columns,
			       \@data
			      ]);
	}
    }	    
} 

1;

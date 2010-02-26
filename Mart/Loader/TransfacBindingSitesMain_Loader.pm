package Loader::TransfacBindingSitesMain_Loader;
#this package shall accept a tf_id_key and a GFF3::Rec of bindingsites
#and populate the TransfacBindingSitesMain table.

use strict;
use warnings;
use Carp qw/croak/;
use Data::Dumper;
use Class::Std;
use base 'Loader';
use Schema;
use GFF3::GFF3Rec;
use Loader::TransfacBindingSitesGenesDm_Loader;


my %config    :ATTR(:name<config>     :default<undef>);
my %species   :ATTR( :name<species>       :default<undef>);
my %tf_id_key :ATTR(:name<tf_id_key>  :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config species tf_id_key]) {
	my $v = $args->{$p};
	defined $v || croak 'need parameter $p';
	my $f = "set_" . $p;
	$self->$f($v);
    }
    return $self;
}

sub load {
    my ($self, $gff) = @_;
    print $gff;
    my $schema = Schema->connect($self->connectinfo('mart'));
    my $db = $self->connect_gff();
    my @columns = qw[tf_id_key
                     dcc_id
                     species
                     gene_id
                     public_name
                     tf_chromosome_name
                     tf_chromosome_start
                     tf_chromosome_end
                     concise_description
                     bs_chromosome_name
                     bs_chromosome_start
                     bs_chromosome_end
                     bs_chromosome_strand
                     bs_length
                     q_value
                     bs_sequence
                    ];

    my $tf = $schema->resultset('TransfacTranscriptionalFactorMain')->find($self->get_tf_id_key);
    my $p = __PACKAGE__; $p =~ s/^Loader:://; $p =~ s/_Loader$//;
    my $bs_rs = $schema->resultset($p);
    open my $gffh, "<", $gff;
    while (my $line = <$gffh>) {
	chomp $line;
	next if $line =~ /^#/;
	next if $line =~ /^\s*$/;
	my $rec = new GFF3::GFF3Rec({line => $line});
	my ($chr, $start, $end, $strand) = ($rec->get_seqid(),
					    $rec->get_start(),
					    $rec->get_end(),
					    $rec->get_strand()
	    );
	my $stat = $rec->get_score();
	if ($stat eq '.') {
	    my $qvalue = $rec->get_qvalue();
	    if ( defined($qvalue) ) {
		$stat = $qvalue;
	    } else {
		$stat = undef;
	    }
	}
	#if $strand == 0;
	#my $segment = $db->segment($chr, $start, $end);
	#$segment->seq->seq, "\n";
	my @data = ($tf->get_column('tf_id_key'),
		    $tf->get_column('dcc_id'),
		    $tf->get_column('species'),
		    $tf->get_column('gene_id'),
		    $tf->get_column('public_name'),
		    $tf->get_column('tf_chromosome_name'),
		    $tf->get_column('tf_chromosome_start'),
		    $tf->get_column('tf_chromosome_end'),
		    $tf->get_column('concise_description'),
		    $chr,
		    $start,
		    $end,
		    $strand,
		    abs($start-$end+1)
		    $stat,
		    $db->segment($chr, $start, $end)->seq->seq
	    );
	print join(' ', @data), "\n";
	my ($bs) = $bs_rs->populate([\@columns,
				     \@data
				    ]);
	print "bs id: ", $bs->bs_id_key, "\n";
	#load relationship
	my $bsgl = new Loader::TransfacBindingSitesGenesDm_Loader({config => $self->get_config(),
								   species => $self->get_species(),
								   bs_id_key => $bs->bs_id_key
								  });
	$bsgl->load($db, $rec, 'gene');
    }
    close $gffh;
}

1;

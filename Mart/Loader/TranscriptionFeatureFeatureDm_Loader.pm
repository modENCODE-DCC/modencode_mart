package Loader::TranscriptionFeatureFeatureDm_Loader;
#this package shall provide a function that can be called 
#to load various dimension tables depending on the types
#this could be used for both transcriptional factor binding site
#and transcriptional features!!!
# 

use strict;
use warnings;
use Carp qw/croak/;
use Data::Dumper;
use Class::Std;
use base 'Loader';
use Schema;

my %config    :ATTR(:name<config>     :default<undef>);
my %ft_id_key :ATTR(:name<ft_id_key>  :default<undef>);
my %ft        :ATTR(:name<ft>         :default<undef>);
my %dbh       :ATTR(:name<dbh>        :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config species ft_id_key ft]) {
	my $v = $args->{$p};
	defined $v || croak 'need parameter $p';
	my $f = "set_" . $p;
	$self->$f($v);
    }
    return $self;
}

sub load {
    #accept a bio-db-seqfeature handle, a gff3rec obj.
    my ($tbl, $type) = @_;
    my $schema = Schema->connect($self->connectinfo('mart'));
    my $ffd_rs = $schema->resultset($tbl);    
    my @columns = qw[ts_id_key
                     feature_id
                     feature_name
                     feature_type
                     feature_chromosome
                     feature_start
                     feature_end
                     feature_strand
                     distance
                     relative_position
                    ];
 
    my %cutoff_map = (gene => gene_distance_cutoff,
		      exon => exon_distance_cutoff,
		      intron => intron__distance_cutoff,
		      CDS => cds__distance_cutoff,
		      transcript => transcript__distance_cutoff,
		      polyA_site => polya_distance_cutoff,
		      TSS => tss_distance_cutoff,
		      transcription_end_site => tes_distance_cutoff,
		      SL1_acceptor_site => sl1_distance_cutoff,
		      SL2_acceptor_site => sl2_distance_cutoff
	);
    my $cutoff = $cutoff_map{$type};
    
    my ($chr, $st, $end) = ($rec->get_seqid(),
			    $rec->get_start(),
			    $rec->get_end()
	);
    my $pt = int(($st+$end)/2);
    my $len = abs($st-$end+1);
    my $rg_min = $pt - $cutoff > 0 ? $pt - $cutoff : 0;
    my $rg_max = $pt + $cutoff;
    print "region: center $pt, min $rg_min, max $rg_max\n";
    #more location, feature type control could go into here
    my $it = $db->segment($chr, $rg_min, $rg_max)->get_seq_stream(-type => $type);
    while (my $ft = $it->next_seq) {
	if ( defined($ft->id) ) { # NO landmark genes
	    my $dst;
#	    $dst = bs_ft_tss_dst($bs_pt, $ft) if $type eq 'gene';
#	    $dst = bs_ft_midpt_dst($bs_pt, $bs_len, $ft) if $type eq 'exon' || $type eq 'intron';
	    print join(" ", ('Gene', $ft->id, $ft->load_id, 'distance', $dst, "\n"));
	    my ($load_id, $display_name, $rp);
	    $load_id = defined($ft->load_id) ? $ft->load_id : undef;
	    $display_name = defined($ft->display_name) ? $ft->display_name : undef;
	    #($dst, $rp) = bs_ft_tss_dst($bs_pt, $ft);
	    my @data = ($self->get_ft_id_key,
			$load_id,
			$display_name,
			$ft->seqid,
			$ft->start,
			$ft->end,
			$ft->strand,
			$dst,
			$rp
		);
	    $ffd_rs->populate([\@columns,
			       \@data
			      ]);
	    }
	}
    }
}

sub bs_ft_tss_dst {
    my ($bs_pt, $ft) = @_;
    if ($ft->strand == 1) {
	my $dst = $bs_pt - $ft->start;
	if ($dst <= 0) {
	    return (abs($dst), 'upstream');
	} else {
	    return ($dst, 'downstream');
	}
    } else {
	my $dst = $bs_pt - $ft->end;
	if ($dst >=0) {
	    return ($dst, 'upstream');
	} else {
	    return (abs($dst), 'downstream');
	}
    }
}

sub bs_ft_midpt_dst {
    my ($bs_pt, $bs_len, $ft) = @_;
    my $dst = abs(($ft->start + $ft->end) / 2 - $bs_pt);
    my $ft_len = abs($ft->start - $ft->end);
    if ($dst < ($bs_len + $ft_len) / 2) {
	return ($dst, 'overlap');
    } else {
	return ($dst, 'not overlap');
    }
}

1;

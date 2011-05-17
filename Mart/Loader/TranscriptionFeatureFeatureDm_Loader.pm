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
    my ($self, $db, $rec, @types) = @_;
    for my $type (@types) {
	$type = lc($type);
	my $uctype = ucfirst($type);
	my $schema = Schema->connect($self->connectinfo('mart'));
	my $p = __PACKAGE__; $p =~ s/^Loader:://; $p =~ s/_Loader$//; $p =~ s/Features/$uctype/;
	my $bsg_rs = $schema->resultset($p);    

	my @columns = qw[bs_id_key
                         feature_id
                         feature_public_name
                         distance
                         relative_position
                         ];

	my $cutoff; 
	$cutoff = $self->get_config()->{'mart'}{'distance_cutoff'} if $type eq 'gene';
	$cutoff = $self->get_config()->{'mart'}{'exon_intron_distance_cutoff'} if $type eq 'exon' || $type eq 'intron';

	my ($chr, $bs_st, $bs_end) = ($rec->get_seqid(),
				      $rec->get_start(),
				      $rec->get_end()
	    );
	my $bs_pt = bs_pt($bs_st, $bs_end);
	my $bs_len = abs($bs_st-$bs_end+1);
	my $rg_min = $bs_pt - $cutoff > 0 ? $bs_pt - $cutoff : 0;
	my $rg_max = $bs_pt + $cutoff;
	print "region: center $bs_pt, min $rg_min, max $rg_max\n";
        #more location, feature type control could go into here
	my $it = $db->segment($chr, $rg_min, $rg_max)->get_seq_stream(-type => $type);
	while (my $ft = $it->next_seq) {
	    if ( defined($ft->id) ) { # NO landmark genes
		my $dst;
		$dst = bs_ft_tss_dst($bs_pt, $ft) if $type eq 'gene';
		$dst = bs_ft_midpt_dst($bs_pt, $bs_len, $ft) if $type eq 'exon' || $type eq 'intron';
		print join(" ", ('Gene', $ft->id, $ft->load_id, 'distance', $dst, "\n"));
		my ($load_id, $display_name, $rp);
		$load_id = defined($ft->load_id) ? $ft->load_id : undef;
		$display_name = defined($ft->display_name) ? $ft->display_name : undef;
		($dst, $rp) = bs_ft_tss_dst($bs_pt, $ft);
		my @data = ($self->get_bs_id_key,
			    $load_id,
			    $display_name,
			    $dst,
			    $rp
		    );
		$bsg_rs->populate([\@columns,
				   \@data
				  ]);
	    }
	}
    }
}

sub bs_pt {
    my ($st, $end) = @_;
    return ($st+$end)/2;
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

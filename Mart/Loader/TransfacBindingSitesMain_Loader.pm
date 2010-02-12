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
                     bs_id
                     bs_chromosome_name
                     bs_chromosome_start
                     bs_chromosome_end
                     bs_chromosome_strand
                     q_value
                     bs_sequence
                    ];
    my $p = __PACKAGE__; $p =~ s/^Loader:://; $p =~ s/_Loader$//;
    my $bs_rs = $schema->resultset($p);
    open my $gffh, "<", $gff;
    my $i = 1;
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
	#if $strand == 0;
	#my $segment = $db->segment($chr, $start, $end);
	#$segment->seq->seq, "\n";
	my @data = ($self->get_tf_id_key(),
		    $i,
		    $chr,
		    $start,
		    $end,
		    $strand,
		    $rec->get_score(),
		    $db->segment($chr, $start, $end)->seq->seq
	    );
	$i++;
	print join(' ', @data), "\n";
	$bs_rs->populate([\@columns,
			  \@data
			 ]);
    }
    close $gffh;
}

1;

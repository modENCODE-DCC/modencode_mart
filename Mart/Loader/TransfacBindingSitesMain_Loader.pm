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

my %tf_id_key :ATTR(:name<tf_id_key>  :default<undef>);

sub BUILD {
    my ($self, $ident, $args) = @_;
    for my $p (qw[config tf_id_key]) {
	my $v = $args->{$p};
	defined $v || croak 'need parameter $p';
	my $f = "set_" . $p;
	$self->$f($v);
    }    
}

sub load {
    my ($self, $gff) = @_;
    my $schema = Schema->connect($self->connectinfo('mart'));
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
    open $gffh, "<", $gff;
    while (my $line = <gffh>) {
	chomp $line;
	next if $line =~ /^#/;
	next if $line =~ /^\s*$/;
	my $rec = new GFF3::GFF3Rec({line => $line});
	@data = ($self->get_tf_id_key(),
		 $rec->get_ID(),
		 $rec->get_seqid(),
		 
	    );
	$bs_rs->populate([\@columns,
			  \@data
			 ]);
    }
    close $gffh;
}

1;

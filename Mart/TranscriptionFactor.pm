package Transfac::TranscriptionFactor;
use base 'Transfac::DBI';

my $table = 'transfac__transcriptional_factor__main';
__PACKAGE__->table($table);
__PACKAGE__->columns(All => qw[tf_id_key 
                               species
                               gene_id
                               public_name
                               tf_chromosome_name
                               tf_chromosome_start
                               tf_chromosome_end
                               tf_chromosome_strand
                               concise_description
                              ]
    );

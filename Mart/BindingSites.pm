package Transfac::BindingSites;
use base 'Transfac::DBI';

my $table = 'transfac__binding_sites__main';
__PACKAGE__->table($table);
__PACKAGE__->columns(All => qw[tf_id_key
		               bs_id_key
                               bs_id
                               bs_chromosome_name
                               bs_chromosome_start
                               bs_chromosome_end
                               bs_chromosome_strand
                               q_value
                               bs_sequence
		              ]
    );

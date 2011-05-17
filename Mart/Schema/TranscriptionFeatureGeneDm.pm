package Schema::TranscriptionFeatureGeneDm;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transcription__feature_gene__dm");
__PACKAGE__->add_columns(
  "ts_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "gene_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "gene_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "gene_chromosome",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "gene_start",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "gene_end",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "gene_strand",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
);
__PACKAGE__->set_primary_key("gene_id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2011-05-17 12:41:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:wsXUpy9T8MFTQX/Z4uNLgg


# You can replace this text with custom content, and it will be preserved on regeneration
1;

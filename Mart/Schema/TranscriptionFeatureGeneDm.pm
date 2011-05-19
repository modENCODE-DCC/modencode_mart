package Schema::TranscriptionFeatureGeneDm;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transcription__feature_gene__dm");
__PACKAGE__->add_columns(
  "ts_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "ts_gene_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "feature_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "feature_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "feature_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "feature_chromosome",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "feature_start",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "feature_end",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "feature_strand",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "relative_position",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "distance",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
);
__PACKAGE__->set_primary_key("ts_gene_id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2011-05-19 11:29:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1BUJF0R58gYnIhBP5eQseg


# You can replace this text with custom content, and it will be preserved on regeneration
1;

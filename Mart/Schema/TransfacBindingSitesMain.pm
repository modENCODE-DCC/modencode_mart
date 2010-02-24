package Schema::TransfacBindingSitesMain;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transfac__binding_sites__main");
__PACKAGE__->add_columns(
  "tf_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 5 },
  "bs_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "dcc_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 5 },
  "species",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "gene_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "public_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "tf_chromosome_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "tf_chromosome_start",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 20 },
  "tf_chromosome_end",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 20 },
  "tf_chromosome_strand",
  { data_type => "CHAR", default_value => undef, is_nullable => 1, size => 1 },
  "concise_description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "bs_chromosome_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "bs_chromosome_start",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "bs_chromosome_end",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "bs_chromosome_strand",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "q_value",
  { data_type => "FLOAT", default_value => undef, is_nullable => 0, size => 32 },
  "bs_sequence",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
);
__PACKAGE__->set_primary_key("bs_id_key");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-02-24 11:20:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bTfo5LBgFPqaucZ30+sBDw


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->has_many(
    genes => 'Schema::TransfacBindingSitesGenesDm',
    'bs_id_key',
    {cascading_delete => 1}
);

1;

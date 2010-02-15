package Schema::TransfacCelllineDm;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transfac__cellline__dm");
__PACKAGE__->add_columns(
  "tf_cellline_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "tf_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 5 },
  "official_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "short_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "species",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "genotype",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "sex",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "tissue_ontology_name",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "cell_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "developmental_stage_ontology_name",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => 65535,
  },
  "contribute_lab",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "wiki_perma_url",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
);
__PACKAGE__->set_primary_key("tf_cellline_id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-02-15 16:12:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QfaImm+l1bC2C2AiwqXFJQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->belongs_to(
    'tf_id_key' => 'Schema::TransfacTranscriptionalFactorMain',
);

1;

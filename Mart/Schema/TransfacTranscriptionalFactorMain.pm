package Schema::TransfacTranscriptionalFactorMain;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transfac__transcriptional_factor__main");
__PACKAGE__->add_columns(
  "tf_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 5 },
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
);
__PACKAGE__->set_primary_key("tf_id_key");
__PACKAGE__->add_unique_constraint("dcc_id_2", ["dcc_id"]);
__PACKAGE__->add_unique_constraint("dcc_id", ["dcc_id"]);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-03-10 17:05:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pL9mpeKf+jEuZEzjtpeBtg


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->has_many(
    antibody => 'Schema::TransfacAntibodyDm',
    'tf_id_key',
    {cascading_delete => 1}
);

__PACKAGE__->has_many(
    strain => 'Schema::TransfacStrainDm',
    'tf_id_key',
    {cascading_delete => 1}
);

__PACKAGE__->has_many(
    cellline => 'Schema::TransfacCelllineDm',
    'tf_id_key',
    {cascading_delete => 1}
);

__PACKAGE__->has_many(
    tissue => 'Schema::TransfacTissueDm',
    'tf_id_key',
    {cascading_delete => 1}
);

__PACKAGE__->has_many(
    tissue => 'Schema::TransfacDevelopmentalStageDm',
    'tf_id_key',
    {cascading_delete => 1}
);
1;

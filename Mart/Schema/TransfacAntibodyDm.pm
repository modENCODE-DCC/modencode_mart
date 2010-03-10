package Schema::TransfacAntibodyDm;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transfac__antibody__dm");
__PACKAGE__->add_columns(
  "tf_antibody_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "tf_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 5 },
  "antibody_id",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 5 },
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
  "target_species",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "target_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "target_public_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "host_species",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "purified",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 1 },
  "monoclonal",
  { data_type => "TINYINT", default_value => undef, is_nullable => 1, size => 1 },
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
__PACKAGE__->set_primary_key("tf_antibody_id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-03-10 17:05:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Dfr4nq7GitW9a5pWiQNdMw


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->belongs_to(
    tf_id_key => 'Schema::TransfacTranscriptionalFactorMain'
);

1;

package Schema::TransfacStrainDm;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transfac__strain__dm");
__PACKAGE__->add_columns(
  "tf_strain_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "tf_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 5 },
  "strain_id",
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
  "trangenic_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 200,
  },
  "tag",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
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
__PACKAGE__->set_primary_key("tf_strain_id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-02-19 18:01:45
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Mj55MscynzB8SZiC1a6GsA


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->belongs_to(
    tf_id_key => 'Schema::TransfacTranscriptionalFactorMain'
);

1;

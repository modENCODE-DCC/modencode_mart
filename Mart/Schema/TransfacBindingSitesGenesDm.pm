package Schema::TransfacBindingSitesGenesDm;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transfac__binding_sites_genes__dm");
__PACKAGE__->add_columns(
  "bs_gene_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "bs_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "feature_id",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "feature_public_name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
  "relative_position",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 15,
  },
  "distance",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
);
__PACKAGE__->set_primary_key("bs_gene_id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-03-10 17:05:53
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nSNTOHaAHDp8qtdHJZXGPQ


# You can replace this text with custom content, and it will be preserved on regeneration
__PACKAGE__->belongs_to(
    bs_id_key => 'Schema::TransfacBindingSitesMain'
);

1;

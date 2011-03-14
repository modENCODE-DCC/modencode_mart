package Schema::TranscriptionExpressionLevelDm;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transcription__expression_level__dm");
__PACKAGE__->add_columns(
  "ts_id_key",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "expression_level_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "expression_level",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "devstage",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "tissue",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "sex",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "condition",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
);
__PACKAGE__->set_primary_key("expression_level_id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2011-03-14 11:21:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uuovXG20Fs8Kh43O4yqKjQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;

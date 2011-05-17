package Schema::TranscriptionFeatureMain;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("transcription__feature__main");
__PACKAGE__->add_columns(
  "ts_id_key",
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
  "ts_chromosome_name",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "ts_chromosome_start",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "ts_chromosome_end",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 20 },
  "ts_chromosome_strand",
  { data_type => "CHAR", default_value => undef, is_nullable => 0, size => 1 },
  "ts_type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 20,
  },
  "assembly_version",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 10,
  },
  "ts_length",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 10 },
  "prediction_status",
  { data_type => "TINYINT", default_value => undef, is_nullable => 0, size => 1 },
  "devstage",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "tissue",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 50,
  },
  "sex",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 20,
  },
);
__PACKAGE__->set_primary_key("ts_id_key");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2011-05-17 12:41:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nwJxh091DnAaBaWVmPtGSw


# You can replace this text with custom content, and it will be preserved on regeneration
1;

use strict;
use warnings;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;
use Getopt::Long;
use Config::IniFiles;

my $root_dir;
BEGIN {
  $root_dir = $0;
  $root_dir =~ s/[^\/]*$//;
  $root_dir = "./" unless $root_dir =~ /\//;
  push @INC, $root_dir;
}

my ($dbtype, $dbname, $host, $port, $user, $pass);
my $config = $root_dir . 'config/modencode_transcriptome.ini';
tie my %ini, 'Config::IniFiles', (-file => $config);
#default martdb connect info
$dbtype = $ini{mart}{type};
$dbname = $ini{mart}{name};
$host = $ini{mart}{host};
$port = $ini{mart}{port};
$user = $ini{mart}{user};
$pass = $ini{mart}{password};
#override martdb connect info
my $opts = GetOptions(
    "dbtype=s"  => \$dbtype,
    "dbname=s"  => \$dbname,
    "host:s"  => \$host,
    "port:i"  => \$port,
    "user:s"  => \$user,
    "password:s"  => \$pass
);

make_schema_at(
    'Schema',
    {debug => 1, dump_directory => './Mart'},
    ["dbi:$dbtype:dbname=$dbname;host=$host;port=$port", $user, $pass]
);

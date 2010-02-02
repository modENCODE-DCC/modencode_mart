package Mart::Transfac::DBI;
use base 'Class::DBI';
use strict;
use Carp;

my $dbi = 'mysql';
my $dbname = 'modencode_mart';
my $user = 'zheng';
my $password = 'weigaocn';

__PACKAGE__->connection("dbi:$dbi:$dbname", $user, $password);

1;




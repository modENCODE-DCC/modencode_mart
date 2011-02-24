dbix class maker:
modencode_mart_creat.pl
create mart dbix classes according to schema in the mart db (already created manually using mysqlAdmin).

Mart dir:
Schema.pm created automatically by dbix code.
Schema dir: the dir specified in modencode_mart_creat.pl for dumping dbix classes.
Loader.pm base class for all Loaders. create Bio::DB::SeqFeature::Store obj using db connection info of gff3 db.
Loader dir: all loaders live here.

config:
where the config.ini lives, misc info for mart, gff3 databases, connection info
for chado db, etc.


Loader:
both of loader load the gff3 binding peak file of TF/Histone modification(wiggle???) into a mart.
modencode_mart_loader_cl.pl
command line options include devstage, tissue, sex, etc.
modencode_mart_loader.pl
directly talk with database to get info on devstage, tissue, sex, etc.





GEO:
my code of extracting info from modencode chado database, using EO's ModENCODE module.

ModENCODE:
EO's module of creating perl object from talking with modencode chado database.

martview:
xml dumps for my mart web interface.

sql:
sql dump of my mart schema. my mart is a mysql db, migrate.sh use sqlt to migrate it into postgresql.

script:

Pipeline:
purpose is to make loading fully automatic, ie, only submission id is needed. it will automatically fetch gff3 file. to be finished.

GFF3:
a simple gff3 parsing module. parse gff3 to feed to loader.

package GFF3::GFF3Rec;

use strict;
use Carp;
use Data::Dumper;
use Class::Std;

my %seqid           :ATTR( :name<seqid>            :default<undef> );
my %source          :ATTR( :name<source>           :default<undef> );
my %type            :ATTR( :name<type>             :default<undef> );
my %start           :ATTR( :name<start>            :default<undef> );
my %end             :ATTR( :name<end>              :default<undef> );
my %score           :ATTR( :name<score>            :default<undef> );
my %strand          :ATTR( :name<strand>           :default<undef> );
my %phase           :ATTR( :name<phase>            :default<undef> );
my %ID              :ATTR( :name<ID>               :default<undef> );
my %Name            :ATTR( :name<Name>             :default<undef> );
my %Alias           :ATTR( :name<Alias>            :default<undef> );
my %Parent          :ATTR( :name<Parent>           :default<[]> );
my %Dbxref          :ATTR( :name<Dbxref>           :default<undef> );
my %Gap             :ATTR( :name<Gap>              :default<undef> );
my %Note            :ATTR( :name<Note>             :default<undef> );
my %Derives_from    :ATTR( :name<Derived_from>     :default<undef> );
my %Target          :ATTR( :name<Target>           :default<undef> );
my %Ontology_term   :ATTR( :name<Ontology_term>    :default<undef> );


sub BUILD {
    my ($self, $ident, $args) = @_;
    my $line = $args->{'line'};
    $self->parse($line) if defined $line;
}

sub parse {
    my ($self, $line) = @_;
    chomp $line;
    my @cols = split("\t", $line);
    @cols = map {$_ =~ s/^\s*//g; $_ =~ s/\s*$//g; $_} @cols;
    $self->set_seqid($cols[0]);
    $self->set_source($cols[1]);
    $self->set_type($cols[2]);
    $self->set_start($cols[3]);
    $self->set_end($cols[4]);
    $self->set_score($cols[5]);
    if ($cols[6] eq '-') {
        $self->set_strand(-1);
    } elsif ($cols[6] eq '+') {
        $self->set_strand(1);
    } else {
        $self->set_strand('0');
    }
    if ($cols[7] ne '.') {
        $self->set_phase($cols[7]);
    }
    $self->parse_9th_column($cols[8]);
}
sub parse_9th_column {
    my ($self, $col) = @_;
    my @attributes = split(";", $col);
    for my $attr (@attributes) {
        my ($tag, $value) = split("=", $attr);
        $tag =~ s/^\s*//g; $tag =~ s/\s*$//g;
        $value =~ s/^\s*//g; $value =~ s/\s*$//g;
        
        if ($tag eq 'ID') {
            $self->set_ID($value);
        }
        elsif ($tag eq 'Name') {
            $self->set_Name($value);
        }
        elsif ($tag eq 'Alias') {
            $self->set_Alias($value);
        }
        elsif ($tag eq 'Parent') {
            my @parents = split ',', $value;
            @parents = map {$_ =~ s/^\s*//g; $_ =~ s/\s*$//g; $_} @parents;
            $self->set_Parent(\@parents);
        }
        elsif ($tag eq 'Dbxref') {
        }       
        elsif ($tag eq 'Gap') {
        }       
        elsif ($tag eq 'Note') {
            $self->set_Note($value);
        }
        elsif ($tag eq 'Derives_from') {
        }       
        elsif ($tag eq 'Target') {
        }
        else {
        }
    }
}

1;

package GuitarPro::Bend::Bend4;

use strict;
use warnings;

sub load($$;$)
{
    my ($class, $binary_reader, $context) = @_;
    die "Strange reader class" unless $binary_reader->isa('GuitarPro::BinaryReader');
    my $bend = bless {} => $class;

    $bend->{type} = $binary_reader->readByte();
    $bend->{value} = $binary_reader->readInt();
    $bend->{points_count} = $binary_reader->readInt();
    $bend->{points} = [];
    for my $i (0..($bend->{points_count}-1)) {
        my $point = {};
        $point->{time_position} = $binary_reader->readInt();
        $point->{vertical_position} = $binary_reader->readInt();
        $point->{vibrato} = $binary_reader->readByte();
        push @{$bend->{points}}, $point;
    }
    return $bend;
}

1;


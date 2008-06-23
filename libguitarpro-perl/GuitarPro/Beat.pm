package GuitarPro::Beat;

use strict;
use warnings;

use GuitarPro::ChordDiagram;
use GuitarPro::BeatEffects;
use GuitarPro::MixTableChange;
use GuitarPro::Note;

use constant {
    BEAT_DOTTED => 0,
    BEAT_CHORD_DIAGRAM => 1,
    BEAT_TEXT => 2,
    BEAT_EFFECTS => 3,
    BEAT_MIX_TABLE => 4,
    BEAT_TUPLET => 5,
    BEAT_STATUS => 6,
};

sub load($$)
{
    my ($class, $binary_reader) = @_;
    die "Strange reader class" unless $binary_reader->isa('GuitarPro::BinaryReader');
    my $beat = {};
    my $header = $binary_reader->readByte();
    my @bits = split "", unpack "b8", chr($header);
    $beat->{header} = [@bits]; # TODO - define constants naming each flag

    if ($bits[BEAT_STATUS]) {
        $beat->{status} = $binary_reader->readByte();
    }
    $beat->{duration} = $binary_reader->readByte();
    if ($bits[BEAT_TUPLET]) {
        $beat->{tuplet} = $binary_reader->readInt();
    }

    if ($bits[BEAT_CHORD_DIAGRAM]) {
        $beat->{chord_diagram} = GuitarPro::ChordDiagram->load($binary_reader);
    }

    if ($bits[BEAT_TEXT]) {
        my $text_length = $binary_reader->readInt();
        $beat->{text} = $binary_reader->readStringByte();
    }

    if ($bits[BEAT_EFFECTS]) {
        $beat->{effects} = GuitarPro::BeatEffects->load($binary_reader);
    }

    if ($bits[BEAT_MIX_TABLE]) {
        $beat->{mix_table_change} = GuitarPro::MixTableChange->load($binary_reader);
    }

    # from source of dguitar, again (specification is wrong here, it talks about one note)
    my $strings_played = $binary_reader->readByte();
    my @string_bits = split "", unpack "b8", chr($strings_played);
    $beat->{strings} = [@string_bits];
    $beat->{notes} = [];
    my $number_of_strings = scalar grep { $_ } @string_bits;
    for my $i (0..($number_of_strings-1)) {
        push @{$beat->{notes}}, GuitarPro::Note->load($binary_reader);
    }

    return bless $beat => $class;
}

1;


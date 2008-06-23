package GuitarPro::BinaryReader;

use strict;
use warnings;

sub new($$)
{
    my ($class, $bytes) = @_;
    my $self = {
        position => 0,
        bytes => $bytes,
    };
    return bless $self => $class;
}

sub readUnsignedByte($)
{
    my ($self) = @_;
    my $byte = unpack "x$self->{position}C1", $self->{bytes};
    $self->{position}++;
    return $byte;
}

sub readShort($)
{
    my ($self) = @_;
    my $short = unpack "x$self->{position}S", $self->{bytes};
    $self->{position} += 2;
    return $short;
}

sub readInt($)
{
    my ($self) = @_;
    my $int = unpack "x$self->{position}I", $self->{bytes};
    $self->{position} += 4;
    return $int;
}

sub readByte($)
{
    my ($self) = @_;
    my $byte = unpack "x$self->{position}c1", $self->{bytes};
    $self->{position}++;
    return $byte;
}

sub readBytes($$)
{
    my ($self, $count) = @_;
    my $bytes = unpack "x$self->{position}a$count", $self->{bytes};
    $self->{position} += $count;
    return $bytes;
}

sub readStringByte($;$)
{
    my ($self, $expected_length) = @_;
    my $real_length = $self->readUnsignedByte();
    $expected_length ||= $real_length;
    my $string = $self->readBytes($expected_length);
    $string = substr($string, 0, $real_length);
    return $string;
}

1;

package Java::IO::InputStream;

use strict;
require IO::Handle;
use Carp qw(croak confess);
our $VERSION = '0.01';

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {};
    my $handle = shift;
    unless($handle->isa("IO::Handle"))
    {
        confess("Usage Java::IO::InputStream->new(<IO handle reference>)");
    }
    binmode($handle);
    $self->{FD} = $handle;
    $handle->autoflush(1);
    bless ($self, $class);
    return $self;
}

sub close($)
{
    my $self = shift;
    $self->{FD}->close();
}

sub skipBytes($$)
{
    my $self = shift;
    my $amtToSkip = shift;
    my $skipped = 0;
    foreach(1 .. $amtToSkip)
    {
        my $byte = $self->read;
        if($byte == -1)
        {
            last;
        }
        else
        {
            $skipped++;
        }
    }
    return $skipped;
}

sub readUTF16($)
{
    my $self = shift;
    return $self->readUTF(1);
}

sub readUTF8($)
{
    my $self = shift;
    return $self->readUTF(0);
}

sub readUTF($$)
{
    my $self = shift;
    my $long = 0;
    if(@_)
    {
        $long = shift;
    }
    my $length;
    if($long)
    {
        $length = $self->readLong;
    }
    else
    {
        $length = $self->readShort;
    }
    my $str;
    foreach(1..$length)
    {
        my $byte = $self->read;
        if($byte < 0)
        {
            confess("End of Stream Error");
        }
        $str .= chr($byte);
    }
    return $str;
}

sub readDouble($)
{
    my $self = shift;
    my $bits = $self->readLong;
    my $s = (($bits >> 63) == 0) ? 1 : -1;
    my $e = (($bits >> 52) & 0x7ff);
    use bignum;
    my $m = ($e == 0) ?
    	    ($bits & 0xfffffffffffff) << 1 :
    	    ($bits & 0xfffffffffffff) | 0x10000000000000;
    return $s*$m*(2**($e-1075));
}

sub readFloat($)
{
    my $self = shift;
    my $floatV = $self->readInt();
    my $s = (($floatV >> 31) == 0) ? 1 : -1;
    my $e = (($floatV >> 23) & 0xff);
    my $m = ($e == 0) ? ($floatV & 0x7fffff) << 1 : ($floatV & 0x7fffff) | 0x800000;
    return $s*$m*(2**($e-150));
}

sub readUnsignedLong($)
{
    my $self = shift;
    my $long = $self->readLong;
    use bignum;
    return $long & 0x00ffffffffffffffff;
}

sub readLong($)
{
    my $self = shift;
    my $ch1 = $self->readInt;
    my $ch2 = $self->readInt;
    use bignum;
    return (($ch1 << 32) + ($ch2 & 0xFFFFFFFF));
}

sub readUnsignedInt($)
{
    my $self = shift;
    my $int = $self->readInt();
    return $int & 0x00ffffffff;
}

sub readInt($)
{
    my $self = shift;
    my $ch1 = $self->read();
    my $ch2 = $self->read();
    my $ch3 = $self->read();
    my $ch4 = $self->read();
    if (($ch1 | $ch2 | $ch3 | $ch4) < 0)
    {
        confess("End of Stream Error");
    }
    return (($ch1 << 24) + ($ch2 << 16) + ($ch3 << 8) + ($ch4 << 0));

}

sub readChar($)
{
    my $self = shift;
    my $short = $self->readShort();
    return chr($short);
}

sub readUnsignedShort($)
{
    my $self = shift;
    my $short = $self->readShort;
    return $short & 0x00ffff;
}

sub readShort($)
{
    my $self = shift;
    my $ch1 = $self->readByte();
    my $ch2 = $self->readByte();
    if (($ch1 | $ch2) < 0)
    {
        confess("End of Stream Error");
    }
    return (($ch1 << 8) + ($ch2 << 0));
}

sub readBoolean($)
{
    my $self = shift;
    return $self->readByte();
}

sub readUnsignedByte($)
{
    my $self = shift;
    return $self->read() & 0x00ff;
}

sub readByte($)
{
    my $self = shift;
    my $byte = $self->read();
}

sub read($)
{
    my $self = shift;
    my $char;
    my $read = $self->{FD}->sysread($char,1);
    $char = ord($char);
    if($read == 0)
    {
        return -1;
    }
    if($read == undef)
    {
        confess("IO Error reading from Handle $!");
    }
    return $char;
}

1;

__END__

=head1 NAME

Java::IO::InputStream - Base class for Reading Java formatted streams

=head1 AUTHOR

Sal Scotto sscotto@cpan.org

=head1 REQUIRES

Perl 5.005 or greater, IO::Handle

=head1 SYNOPSIS

  use Java::IO::InputStream;
  my $socketHandle;
  # .. socket creation code
  my $stream = Java::IO::InputStream($socketHandle);
  my $javaLong = $stream->readLong;
  my $javaString = $stream->readUTF8;
  ...

=head1 ABSTRACT

Base class for manipulating java io streams from Perl.

=head1 DESCRIPTION

This class represents a base class for reading java based streams. It's intended
use is to be extended for things like a perl based java object de-serializer, reading
java class files, etc.. The methods available are similar to the methods of java's
datainputstream.

This class can perform all the correct decoding of java formatted data and can be
used as a bridge for your perl application to speak to a java application over a
socket, or read a file written using java's dataoutputstream.

It is probably important to at least have briefly read "The JavaTM
Language Specification", http://java.sun.com/docs/books/jls/


=head1 METHODS

=head2 new

This is the constructor it wraps am IO::Handle object

  my $stream = Java::IO::InputStream($handle);

=head2 read

Note: All the read methods will return -1 if the stream at EOF

This method reads a single byte from the stream.

  my $byte = $stream->read;

=head2 close

This method will close the stream

$stream->close();

=head2 skipBytes

This method will skip X bytes in the stream and return the amount successfully skipped.

  my $skipped = $stream->skipBytes(20);

=head2 readByte

This methods reads a single signed byte from the stream.

(Note: this method added for completness and sinply wraps read)

  my $byte = $stream->readByte;

=head2 readUnsignedByte

This method reads a single unsigned byte from the stream

  my $ubyte = $stream->readUnsignedByte;

=head2 readBoolean

This method reads a boolean value from the stream

  my $boolean = $stream->readBoolean;

=head2 readShort

This method read a short value from the stream

  my $short = $stream->readShort;

=head2 readUnsginedShort

This method read an unsigned short value from the stream

  my $ushort = $stream->readUnsignedShort;

=head2 readInt

This method read an int value from the stream

  my $int = $stream->readInt;

=head2 readUnsignedInt

This method read an unsigned int value from the stream

  my $uint = $stream->readUnsignedInt;

=head2 readLong

This method read a long value from the stream

  my $long = $stream->readLong;


=head2 readUnsignedLong

This method read an unsigned long value from the stream

  my $ulong = $stream->readUnsignedLong;


=head2 readUTF8

This method read an UTF8 encoded string from the stream

  my $string = $stream->readUTF8;

=head2 readUTF16

This method read an UTF16 encoded string from the stream

  my $string = $stream->readUTF16;

=head2 readUTF

This method read an UTF encoded string from the stream

  my $string = $stream->readUTF([LONG]);

LONG should be set to true if this is an UTF16 string

=head1 COPYRIGHT

Copyright (c) 2002 Sal Scotto (sscotto@cpan.org). All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

package Java::IO::ObjectInputStream;

use strict;
use 5.008;
use Carp qw(croak confess);
require Java::IO::FilteredInputStream;
require IO::Handle;
use Java::IO::ObjectStreamConstants;
our $VERSION = '0.01';
our @ISA = qw(Java::IO::FilteredInputStream);

sub new
{
  my $class = shift;
  my $stream = shift;
  my $self = $class->SUPER::new($stream);

  #
  # Perform stream verification
  #
  my $magic = $self->_readMagic();
  my $version = $self->_readVersion();
  if($magic != STREAM_MAGIC || $version != STREAM_VERSION)
  {
      confess("Bad Object Stream!!");
  }
  return $self;
}

sub _readMagic($)
{
    my $self = shift;
    my $magic = $self->{STREAM}->readShort;
    return $magic;
}

sub _readVersion($)
{
    my $self = shift;
    my $version = $self->{STREAM}->readShort;
    return $version;
}
1;

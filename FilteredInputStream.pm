package Java::IO::FilteredInputStream;

use strict;
use 5.008;

sub new
{
  my $class = shift;
  my $self = bless {}, $class;
  my $stream = shift;
  unless($stream->isa('Java::IO::InputStream'))
  {
      confess("Usage Java::IO::ObjectInputStream->new(Java::IO::InputStream object)");
  }
  $self->{STREAM} = $stream;
  return $self;
}

sub close($)
{
    my $self = shift;
    $self->{STREAM}->close();
}

1;

__END__

=head1 NAME

FilteredInputStream Perl class to emulate a Java FilteredInputStream

=head1 AUTHOR

Sal Scotto sscotto@cpan.org

=head1 REQUIRES

Perl 5.005 or greater, IO::Handle

=head1 SYNOPSIS

This is a base class and should not be directly instanshiated. It is a place holder that provides subclasses with STREAM to massage via $self->{STREAM} variable.

=head1 DESCRIPTION

This is a base class and should not be directly instanshiated. It is a place holder that provides subclasses with STREAM to massage via $self->{STREAM} variable.

=head1 METHODS

=head2 close

This method will close the underlying stream in a cascade effect.

  $stream->close;

=head1 COPYRIGHT

Copyright (c) 2002 Sal Scotto (sscotto@cpan.org). All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

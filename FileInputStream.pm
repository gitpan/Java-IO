package Java::IO::FileInputStream;

use strict;
use 5.008;
use Carp qw(croak confess);
require Java::IO::InputStream;
require IO::Handle;
our $VERSION = '0.01';
our @ISA = qw(Java::IO::InputStream);

sub new
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {};
    my $file = shift;
    my $handle = IO::Handle->new();
    open(FH,$file) or confess("Couldn't open $file $!");
    $handle->fdopen(fileno(FH),"r") or confess ("Couldn't open the stream $!");
    binmode($handle);
    $self->{FD} = $handle;
    $handle->autoflush(1);
    bless($self,$class);
    return $self;
}

sub readFully($$)
{
    my $self = shift;
    my $amount = shift;
    my @data;
    foreach(1 .. $amount)
    {
        my $byte = $self->SUPER::read;
        if($byte == -1)
        {
            last;
        }
        else
        {
            push(@data,$byte);
        }
    }
    return @data;
}

1;

__END__

=head1 NAME

FileInputStream Perl class to emulate a Java FileInputStream

=head1 AUTHOR

Sal Scotto sscotto@cpan.org

=head1 REQUIRES

Perl 5.005 or greater, IO::Handle

=head1 SYNOPSIS

  use Java::IO::FileInputStream;
  my $fstream = Java::IO::FileInputStream->new('myFile.temp');
  my $byte = $fstream->read;

=head1 DESCRIPTION

This class simply provides a new constructor for Java::IO:InputStream.
It was made to allow modeling of a java file input stream to help
java programmers that are learning perl.

=head1 METHODS

=head2 readFully

This method will read X bytes and return an array of the data
my @data = $stream->readFully(20);

=head1 COPYRIGHT

Copyright (c) 2002 Sal Scotto (sscotto@cpan.org). All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

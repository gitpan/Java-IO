package Java::IO::ObjectStreamConstants;

# This class contains the Terminals for the
# Serialized Object Grammer by DEFAULT it exports all the TERMINALS

#terminal constants
use constant STREAM_MAGIC      => 0xaced;
use constant STREAM_VERSION    => 5;
use constant TC_NULL           => 0x70;
use constant TC_REFERENCE      => 0x71;
use constant TC_CLASSDESC      => 0x72;
use constant TC_OBJECT         => 0x73;
use constant TC_STRING         => 0x74;
use constant TC_ARRAY          => 0x75;
use constant TC_CLASS          => 0x76;
use constant TC_BLOCKDATA      => 0x77;
use constant TC_ENDBLOCKDATA   => 0x78;
use constant TC_RESET          => 0x79;
use constant TC_BLOCKDATALONG  => 0x7A;
use constant TC_EXCEPTION      => 0x7B;
use constant TC_LONGSTRING     => 0x7C;
use constant TC_PROXYCLASSDESC => 0x7D;
use constant TC_MAX            => 0x7D;
use constant baseWireHandle    => 0x7E0000;

# classDescFlags
use constant SC_WRITE_METHOD   => 0x01;
use constant SC_BLOCKDATA     => 0x08;
use constant SC_SERIALIZABLE   => 0x02;
use constant SC_EXTERNALIZABLE => 0x04;

our @ISA = qw(Exporter);
@EXPORT    = qw(STREAM_MAGIC STREAM_VERSION TC_NULL TC_REFERENCE TC_CLASSDESC TC_OBJECT TC_STRING TC_ARRAY TC_CLASS TC_BLOCKDATA TC_ENDBLOCKDATA TC_RESET TC BLOCKDATALONG TC_EXCEPTION TC_LONGSTRING TC_PROXYCLASSDESC TC_MAX baseWireHandle SC_WRITE_METHOD SC_BLOCKDATA SC_SERIALIZABLE SC_EXTERNALIZABLE);

1;

__END__

=head1 NAME

Java::IO::ObjectStreamConstants - Class containing all the Object Stream grammar terminals

=head1 AUTHOR

Sal Scotto sscotto@cpan.org

=head1 REQUIRES

Perl 5.005 or greater

=head1 SYNOPSIS

  use Java::IO::ObjectStreamConstants;

=head1 ABSTRACT

Class to expose the Java Object Serialization Grammer Terminals Constants

=head1 CONSTANTS

Please see the Java Object Serialization Specification for details on the meaning of these constants.

B<Terminal Constants>

STREAM_MAGIC      0xaced

STREAM_VERSION    5

TC_NULL           0x70

TC_REFERENCE      0x71

TC_CLASSDESC      0x72

TC_OBJECT         0x73

TC_STRING         0x74

TC_ARRAY          0x75

TC_CLASS          0x76

TC_BLOCKDATA      0x77

TC_ENDBLOCKDATA   0x78

TC_RESET          0x79

TC_BLOCKDATALONG  0x7A

TC_EXCEPTION      0x7B

TC_LONGSTRING     0x7C

TC_PROXYCLASSDESC 0x7D

baseWireHandle    0x7E0000

B<Class Desc Flags>

SC_WRITE_METHOD   0x01

SC_BLOCK_DATA     0x08

SC_SERIALIZABLE   0x02

SC_EXTERNALIZABLE 0x04

=head1 DESCRIPTION

This class contains all the TERMINAL constants for the Java ObjectSerialization Specification.

It is probably important to at least have briefly read "The JavaTM
Serialized Object Specification", http://java.sun.com/j2se/1.3/docs/guide/serialization/spec/serialTOC.doc.html



# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl 1.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;
BEGIN { 
use_ok('Java::IO::InputStream');
use_ok('Java::IO::FileInputStream');
use_ok('Java::IO::ObjectInputStream');
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $jin = Java::IO::FileInputStream->new('t\myobj.ser');
my $oin = Java::IO::ObjectInputStream->new($jin);
ok(defined($oin),"Object Class Stream base load");
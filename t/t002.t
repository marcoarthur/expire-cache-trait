use strict;
use warnings;

use Test::More;
use Test::Most;
use lib 'lib', 't/lib';

use_ok( 'Person' );

my $p = Person->new();

isa_ok( $p , 'Person');

is($p->name, "Marco 0", "Has right attribute initial value");
sleep 4;
is($p->name, "Marco 1", "Got updated after expiration time");

done_testing;

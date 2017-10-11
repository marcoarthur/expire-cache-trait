use strict;
use warnings;

use Test::More;
use Test::Most;
use lib 'lib', 't/lib';
use Person;

use_ok( 'Person' );

my $p = Person->new();

isa_ok( $p , 'Person');

is($p->name, "Marco 0", "Has right attribute initial value");
sleep 4;
is($p->name, "Marco 1", "Got updated after expiration time");

use_ok( 'City' );

my $c = City->new;
isa_ok ($c, 'City');
is( $c->temp, 0);
sleep 4;
throws_ok ( sub { $c->temp  }, 'Moose::Exception', 'builder not set');

done_testing;

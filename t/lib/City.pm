package City;
use Moose;
use 5.010;

has temp => ( is => 'rw', traits => ['Cache'], expiration_time => 3, default => 0 );

__PACKAGE__->meta->make_immutable;

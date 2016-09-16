package Person;
use Moose;
use 5.010;

has name => (
    traits => ['Cache'],
    is => 'rw', 
    isa => 'Str',
    expiration_time => 3,
    builder => '_name_it',
);

sub _name_it {
    state $n = 0;
    return 'Marco ' . $n++;
}

__PACKAGE__->meta->make_immutable;

1;

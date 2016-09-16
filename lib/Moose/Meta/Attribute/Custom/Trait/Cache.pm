package Moose::Meta::Attribute::Custom::Trait::Cache;

use Modern::Perl;
use Moose::Role;
use Moose::Util 'throw_exception';
our $VERSION = '0.01';

# time interval in seconds to expire attribute value
has expiration_time => (
    is => 'ro',
    isa => 'Int',
    predicate => 'has_expiration_time',
    required => 1,
    default => 10
);

# time given by epoch since the last access (as well as a create/update)
has last_access => (
    is => 'rw',
    isa => 'Int',
    required => 1,
    default => sub { time },
);

# does verify expiration time
sub is_expired {
    my $self = shift;

    my $interval = time - $self->last_access;
    return $interval > $self->expiration_time;
}

# does install around modifier into the container class
# WARN: should not be called more than once.
sub _install_hooks {
    my $self = shift;

    my $realclass = $self->associated_class();

    # install an 'arround method modifier' to verify first if
    # the attribute expired. Resetting it, if necessary.
    $realclass->add_around_method_modifier( 
        $self->name,
        sub {
            my ($next, $c) = @_;

            # not expired: return the value of attribute
            return $c->$next() unless $self->is_expired;

            # warn for the expired value
            warn $self->name . " attribute value expired, should be updated";

            # builder does not exist: throw an exception
            my $builder = $self->builder;
            throw_exception( BuilderDoesNotExist => instance => $c, attribute => $self ) unless $builder;

            # build a new value for attribute
            my $new_value = $c->$builder();

            # set the new attribute access time
            $self->last_access(time);

            # set and return the new attribute value
            return $c->$next($new_value);
        }
    );
}

# after every accessor have been built in the container class, them create
# the method modifiers around the attribute receiving 'Cache' trait.
after 'install_accessors' => sub {
    my $self      = shift;

    # install the ``hooks'' to the accessors of the container class
    $self->_install_hooks();
};

no Moose::Role;

1;
__END__

=encoding utf-8

=head1 NAME

Moose::Meta::Attribute::Custom::Trait::Cache - Enables expiration time for attributes

=head1 SYNOPSIS

  package City;
  use Moose;

  has temperature => (
    traits => ['Cache'],
    is => 'rw',
    isa => 'Int',
    builder => _get_temperature,
    required => 1,
    expiration_time => 10,
  );

  sub _get_temperature {
    state $t = 10;
    return $t++;
  }

  no Moose;
  1;

  package main;
  my $city = City->new();

  say $city->temperature() # 10
  # after +10 seconds
  say $city->temperature() # 11
  # after +10 seconds
  say $city->temperature() # 12


=head1 DESCRIPTION

Moose::Meta::Attribute::Custom::Trait::Cache applies a rule for expire the attribute
forcing it to renew when expired.

=head1 AUTHOR

Marco Arthur E<lt>arthurpbs@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2016- Marco Arthur

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut

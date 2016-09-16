# NAME

Moose::Meta::Attribute::Custom::Trait::Cache - Enables expiration time for attributes

# SYNOPSIS

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

# DESCRIPTION

Moose::Meta::Attribute::Custom::Trait::Cache applies a rule for expire the attribute
forcing it to renew when expired.

# AUTHOR

Marco Arthur <arthurpbs@gmail.com>

# COPYRIGHT

Copyright 2016- Marco Arthur

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

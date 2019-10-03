requires 'Modern::Perl';
requires 'Moose::Role';
requires 'Moose::Util';

on configure => sub {
    requires 'Module::Build::Tiny', '0.034';
    requires 'perl', '5.010';
};

on test => sub {
    requires 'Moose';
    requires 'Test::More';
    requires 'Test::Most';
    requires 'perl', '5.010';
};



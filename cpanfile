requires 'perl', '5.010';

# requires 'Some::Module', 'VERSION';
requires 'Moose', '2.1805';

on test => sub {
    requires 'Test::More', '0.96';
};

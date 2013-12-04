#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(lib ../lib);
use POE qw/Component::Data::SimplePassword/;
my $poco = POE::Component::Data::SimplePassword->spawn;

POE::Session->create( package_states => [ main => [qw(_start results)] ], );

$poe_kernel->run;

sub _start {
    $poco->make_password( { event => 'results', } );
}

sub results {
    print "Password: $_[ARG0]->{out}\n";
    $poco->shutdown;
}
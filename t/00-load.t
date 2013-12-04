#!/usr/bin/env perl

use Test::More tests => 5;

BEGIN {
    use_ok('POE');
    use_ok('POE::Component::NonBlockingWrapper::Base');
    use_ok('Data::SimplePassword');
    use_ok('Math::Pari');

	use_ok( 'POE::Component::Data::SimplePassword' );
}

diag( "Testing POE::Component::Data::SimplePassword $POE::Component::Data::SimplePassword::VERSION, Perl $], $^X" );

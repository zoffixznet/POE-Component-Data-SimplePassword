use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'POE::Component::Data::SimplePassword',
    license             => 'perl',
    dist_author         => q|Zoffix <'zoffix@cpan.org'>|,
    dist_version_from   => 'lib/POE/Component/Data/SimplePassword.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'POE'                                      => 0.9999,
        'POE::Component::NonBlockingWrapper::Base' => 0.002,
        'Data::SimplePassword'                     => 0.04,
        'Math::Pari'                               => 2.010800,
    },
    add_to_cleanup      => [ 'POE-Component-Data-SimplePassword-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

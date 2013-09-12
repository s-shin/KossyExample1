use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'KossyExample1',
    VERSION_FROM  => 'lib/KossyExample1.pm',
    PREREQ_PM     => {
        'Kossy' =>  '0.19',
    },
    MIN_PERL_VERSION => '5.008001'
);


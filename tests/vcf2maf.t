#!/usr/bin/env perl

use strict;
use warnings;

# Find and chdir into the parent folder containing the scripts to test
use File::Basename 'dirname';
use Cwd 'abs_path';
my $test_dir = dirname( abs_path( __FILE__ ));
my $script_dir = dirname( $test_dir );
chdir $script_dir;

# Set the number of tests we'll run, and run them
use Test::Simple tests => 6;
ok( system( "perl vcf2maf.pl --help > /dev/null" ) == 0 );
ok( system( "perl vcf2maf.pl --man > /dev/null" ) == 0 );

# Test standard operation, diff, and cleanup
ok( system( "perl vcf2maf.pl --input-vcf tests/test.vcf --output-maf tests/test_output.vep_isoforms.new.maf" ) == 0 );
ok( system( "diff tests/test_output.vep_isoforms.maf tests/test_output.vep_isoforms.new.maf" ) == 0 );
system( "rm -f tests/test.vep.vcf tests/test_output.vep_isoforms.new.maf" );

# Test using Uniprot's canonical isoforms as overrides, diff, and cleanup
ok( system( "perl vcf2maf.pl --input-vcf tests/test.vcf --output-maf tests/test_output.custom_isoforms.new.maf --custom-enst data/isoform_overrides_uniprot" ) == 0 );
ok( system( "diff tests/test_output.custom_isoforms.maf tests/test_output.custom_isoforms.new.maf" ) == 0 );
system( "rm -f tests/test.vep.vcf tests/test_output.custom_isoforms.new.maf" );

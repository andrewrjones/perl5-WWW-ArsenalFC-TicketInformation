#!perl

use strict;
use warnings;

use Test::More tests => 4;

BEGIN { use_ok('WWW::ArsenalFC::TicketInformation::Category'); }

my $category = new_ok(
    'WWW::ArsenalFC::TicketInformation::Category',
    [
        category    => 'C',
        date_string => 'Saturday, August 18',
    ]
);

is( $category->category,    'C' );
is( $category->date_string, 'Saturday, August 18' );

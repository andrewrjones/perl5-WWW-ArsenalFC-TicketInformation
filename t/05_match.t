#!perl

use strict;
use warnings;

use Test::More tests => 4;

BEGIN { use_ok('WWW::ArsenalFC::TicketInformation::Match'); }

my $match = new_ok(
    'WWW::ArsenalFC::TicketInformation::Match',
    [
        fixture     => 'Arsenal vs Newcastle United',
        competition => 'Barclays Premier League',
    ]
);

is( $match->fixture,     'Arsenal vs Newcastle United' );
is( $match->competition, 'Barclays Premier League' );

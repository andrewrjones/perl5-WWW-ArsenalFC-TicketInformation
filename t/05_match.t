#!perl

use strict;
use warnings;

use Test::More tests => 9;

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
ok( $match->is_home,           'Is home' );
ok( $match->is_premier_league, 'Is Premier League' );

$match = new_ok(
    'WWW::ArsenalFC::TicketInformation::Match',
    [
        fixture     => 'Liverpool vs Arsenal',
        competition => 'FA Cup',
    ]
);

ok( !$match->is_home,           'Is home' );
ok( !$match->is_premier_league, 'Is Premier League' );

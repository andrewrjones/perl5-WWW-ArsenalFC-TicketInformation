#!perl

use strict;
use warnings;

use Test::More tests => 10;

BEGIN { use_ok('WWW::ArsenalFC::TicketInformation::Match'); }

my $match = new_ok(
    'WWW::ArsenalFC::TicketInformation::Match',
    [
        fixture         => 'Arsenal vs Newcastle United',
        competition     => 'Barclays Premier League',
        datetime_string => 'Monday, August 20, 2012, 19:00',
    ]
);

is( $match->fixture,     'Arsenal vs Newcastle United' );
is( $match->competition, 'Barclays Premier League' );
ok( $match->is_home,           'Is home' );
ok( $match->is_premier_league, 'Is Premier League' );

is( $match->datetime, '2012-08-20T19:00:00' );

$match = new_ok(
    'WWW::ArsenalFC::TicketInformation::Match',
    [
        fixture     => 'Liverpool vs Arsenal',
        competition => 'FA Cup',
    ]
);

ok( !$match->is_home,           'Is home' );
ok( !$match->is_premier_league, 'Is Premier League' );

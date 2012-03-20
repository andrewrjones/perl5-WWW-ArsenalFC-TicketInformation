#!perl

use strict;
use warnings;

use Test::More tests => 42;

use FindBin qw($Bin);

BEGIN { use_ok('WWW::ArsenalFC::TicketInformation'); }
use WWW::ArsenalFC::TicketInformation::Match;

my $html           = open_html("$Bin/resources/buy-tickets-09-03-2012.htm");
my $actual_matches = WWW::ArsenalFC::TicketInformation::_parse_html($html);

is( @$actual_matches, 10, '10 matches' );

my @expected_matches = (
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Monday, March 12, 2012, 20:00',
        fixture     => 'Arsenal vs Newcastle United',
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Wednesday, March 21, 2012, 20:00',
        fixture     => 'Everton vs Arsenal',
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Saturday, March 24, 2012, 15:00',
        fixture     => 'Arsenal vs Aston Villa',
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Saturday, March 31, 2012, 15:00',
        fixture     => 'QPR vs Arsenal',
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Sunday, April 8, 2012, 16:00',
        fixture     => 'Arsenal vs Manchester City',
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Wednesday, April 11, 2012, 19:45',
        fixture     => 'Wolverhampton W. vs Arsenal',
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Monday, April 16, 2012, 20:00',
        fixture     => 'Arsenal vs Wigan Athletic',
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Saturday, April 21, 2012, 12:45',
        fixture     => 'Arsenal vs Chelsea',
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Women\'s Super League',
        datetime    => 'Thursday, April 26, 2012, 19:45',
        fixture     => 'Arsenal vs Chelsea',
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Saturday, May 5, 2012, 12:45',
        fixture     => 'Arsenal vs Norwich',
    ),
);

for ( my $i = 0 ; $i < @$actual_matches ; $i++ ) {
    my $expected_match = $expected_matches[$i];
    my $actual_match   = $actual_matches->[$i];

    isa_ok( $actual_match, 'WWW::ArsenalFC::TicketInformation::Match',
        "match $i" );

    is( $actual_match->fixture, $expected_match->fixture, "match $i fixture" );
    is(
        $actual_match->competition,
        $expected_match->competition,
        "match $i competition"
    );
    is( $actual_match->datetime, $expected_match->datetime, "match $i date" );
}

sub open_html {
    my ($file) = @_;

    open( my $fh, '<:encoding(UTF-8)', $file )
      or die $!;
    my $hold = $/;
    undef $/;
    my $html = <$fh>;
    $/ = $hold;

    return $html;
}

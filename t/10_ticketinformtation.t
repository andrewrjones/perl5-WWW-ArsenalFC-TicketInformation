#!perl

use strict;
use warnings;

use Test::More tests => 42;

use FindBin qw($Bin);

BEGIN { use_ok('WWW::ArsenalFC::TicketInformation'); }
use WWW::ArsenalFC::TicketInformation::Match;

#my $html           = open_html("$Bin/resources/buy-tickets-09-03-2012.htm");
my $html           = open_html("$Bin/resources/buy-tickets-16-08-2012.htm");
my $actual_matches = WWW::ArsenalFC::TicketInformation::_parse_html($html);

is( @$actual_matches, 8, '8 matches' );

my @expected_matches = (
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Saturday, August 18, 2012, 15:00',
        fixture     => 'Arsenal vs Sunderland',
        hospitality => 1,
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Under-21 Premier League',
        datetime    => 'Monday, August 20, 2012, 19:00',
        fixture     => 'Arsenal vs Bolton',
        hospitality => 1,
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Under-21 Premier League',
        datetime    => 'Saturday, August 25, 2012, 14:00',
        fixture     => 'Arsenal vs Blackburn',
        hospitality => 1,
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Sunday, August 26, 2012, 13:30',
        fixture     => 'Stoke City vs Arsenal',
        hospitality => 0,
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Sunday, September 2, 2012, 13:30',
        fixture     => 'Liverpool vs Arsenal',
        hospitality => 0,
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Saturday, September 15, 2012, 15:00',
        fixture     => 'Arsenal vs Southampton',
        hospitality => 1,
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Saturday, September 29, 2012, 12:45',
        fixture     => 'Arsenal vs Chelsea',
        hospitality => 1,
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        competition => 'Barclays Premier League',
        datetime    => 'Saturday, October 27, 2012, 15:00',
        fixture     => 'Arsenal vs QPR',
        hospitality => 1,
    ),
);

for ( my $i = 1 ; $i <= @$actual_matches ; $i++ ) {
    my $expected_match = $expected_matches[$i-1];
    my $actual_match   = $actual_matches->[$i-1];

    isa_ok( $actual_match, 'WWW::ArsenalFC::TicketInformation::Match',
        "match $i" );

    is( $actual_match->fixture, $expected_match->fixture, "match $i fixture" );
    is(
        $actual_match->competition,
        $expected_match->competition,
        "match $i competition"
    );
    is( $actual_match->datetime, $expected_match->datetime, "match $i date" );
    is(
        $actual_match->hospitality,
        $expected_match->hospitality,
        "match $i hospitality"
    );
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

#!perl

use strict;
use warnings;

use Test::More tests => 32;

use FindBin qw($Bin);

BEGIN { use_ok('WWW::ArsenalFC::TicketInformation'); }
use WWW::ArsenalFC::TicketInformation::Match;

my $html           = open_html("$Bin/resources/buy-tickets-09-03-2012.htm");
my $actual_matches = WWW::ArsenalFC::TicketInformation::_parse_html($html);

is( @$actual_matches, 10, '10 matches' );

my @expected_matches = (
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'Arsenal vs Newcastle United',
        competition => 'Barclays Premier League'
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'Everton vs Arsenal',
        competition => 'Barclays Premier League'
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'Arsenal vs Aston Villa',
        competition => 'Barclays Premier League'
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'QPR vs Arsenal',
        competition => 'Barclays Premier League'
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'Arsenal vs Manchester City',
        competition => 'Barclays Premier League'
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'Wolverhampton W. vs Arsenal',
        competition => 'Barclays Premier League'
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'Arsenal vs Wigan Athletic',
        competition => 'Barclays Premier League'
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'Arsenal vs Chelsea',
        competition => 'Barclays Premier League'
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'Arsenal vs Chelsea',
        competition => 'Women\'s Super League'
    ),
    WWW::ArsenalFC::TicketInformation::Match->new(
        fixture     => 'Arsenal vs Norwich',
        competition => 'Barclays Premier League'
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

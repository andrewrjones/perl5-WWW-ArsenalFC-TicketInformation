#!perl

use strict;
use warnings;

use Test::More tests => 3;
use Test::Deep;

use FindBin qw($Bin);

BEGIN { use_ok('WWW::ArsenalFC::TicketInformation'); }

use aliased 'WWW::ArsenalFC::TicketInformation::Match';
use aliased 'WWW::ArsenalFC::TicketInformation::Match::Availability';

my $ticket_info = new_ok('WWW::ArsenalFC::TicketInformation');

my $html = open_html("$Bin/resources/buy-tickets-16-08-2012.htm");
$ticket_info->{tree} = HTML::TreeBuilder::XPath->new_from_content($html);

subtest 'Matches' => sub {
    plan tests => 2;
    my $actual_matches = $ticket_info->fetch_matches();

    is( @$actual_matches, 8, '8 matches' );

    my @expected_matches = (
        Match->new(
            competition  => 'Barclays Premier League',
            datetime     => 'Saturday, August 18, 2012, 15:00',
            fixture      => 'Arsenal vs Sunderland',
            hospitality  => 1,
            is_soldout   => 0,
            can_exchange => 1,
        ),
        Match->new(
            competition  => 'Barclays Under-21 Premier League',
            datetime     => 'Monday, August 20, 2012, 19:00',
            fixture      => 'Arsenal vs Bolton',
            hospitality  => 1,
            is_soldout   => 0,
            can_exchange => 0,
            availability => [
                Availability->new(
                    type       => Availability->FOR_SALE,
                    membership => Availability->GENERAL_SALE
                )
            ],
        ),
        Match->new(
            competition  => 'Barclays Under-21 Premier League',
            datetime     => 'Saturday, August 25, 2012, 14:00',
            fixture      => 'Arsenal vs Blackburn',
            hospitality  => 1,
            is_soldout   => 0,
            can_exchange => 0,
            availability => [
                Availability->new(
                    type       => Availability->FOR_SALE,
                    membership => Availability->GENERAL_SALE
                )
            ],
        ),
        Match->new(
            competition  => 'Barclays Premier League',
            datetime     => 'Sunday, August 26, 2012, 13:30',
            fixture      => 'Stoke City vs Arsenal',
            hospitality  => 0,
            is_soldout   => 1,
            can_exchange => 0,
        ),
        Match->new(
            competition  => 'Barclays Premier League',
            datetime     => 'Sunday, September 2, 2012, 13:30',
            fixture      => 'Liverpool vs Arsenal',
            hospitality  => 0,
            is_soldout   => 1,
            can_exchange => 0,
        ),
        Match->new(
            competition  => 'Barclays Premier League',
            datetime     => 'Saturday, September 15, 2012, 15:00',
            fixture      => 'Arsenal vs Southampton',
            hospitality  => 1,
            is_soldout   => 0,
            can_exchange => 0,
            availability => [
                Availability->new(
                    type       => Availability->FOR_SALE,
                    membership => Availability->SILVER
                ),
                Availability->new(
                    type       => Availability->SCHEDULED,
                    membership => Availability->RED,
                    date       => '20-08-2012'
                )
            ],
        ),
        Match->new(
            competition  => 'Barclays Premier League',
            datetime     => 'Saturday, September 29, 2012, 12:45',
            fixture      => 'Arsenal vs Chelsea',
            hospitality  => 1,
            is_soldout   => 0,
            can_exchange => 0,
            availability => [
                Availability->new(
                    type       => Availability->SCHEDULED,
                    membership => Availability->SILVER,
                    date       => '23-08-2012'
                ),
                Availability->new(
                    type       => Availability->SCHEDULED,
                    membership => Availability->RED,
                    date       => '30-08-2012'
                )
            ],
        ),
        Match->new(
            competition  => 'Barclays Premier League',
            datetime     => 'Saturday, October 27, 2012, 15:00',
            fixture      => 'Arsenal vs QPR',
            hospitality  => 1,
            is_soldout   => 0,
            can_exchange => 0,
            availability => [
                Availability->new(
                    type       => Availability->SCHEDULED,
                    membership => Availability->SILVER,
                    date       => '28-08-2012'
                ),
                Availability->new(
                    type       => Availability->SCHEDULED,
                    membership => Availability->RED,
                    date       => '27-09-2012'
                )
            ],
        ),
    );

    cmp_deeply( $actual_matches, \@expected_matches );
};

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

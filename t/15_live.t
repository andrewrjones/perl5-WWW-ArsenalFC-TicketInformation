#!perl

use strict;
use warnings;

use Net::Ping 2.33;
use Test::More;

my $p = Net::Ping->new( "syn", 2 );
$p->port_number( getservbyname( "http", "tcp" ) );
unless ( $p->ping('arsenal.com') ) {
    plan skip_all => 'Can\'t find arsenal.com for live tests';
}
else {
    plan tests => 2;
}

use aliased 'WWW::ArsenalFC::TicketInformation';
use aliased 'WWW::ArsenalFC::TicketInformation::Category';
use aliased 'WWW::ArsenalFC::TicketInformation::Match';
use aliased 'WWW::ArsenalFC::TicketInformation::Match::Availability';

my $ticket_info = TicketInformation->new();

$ticket_info->fetch();

subtest 'Categories' => sub {
    my $categories = $ticket_info->categories;

    plan tests => ( @$categories * 4 ) + 1;

    ok($categories);

    for my $category (@$categories) {
        isa_ok( $category, Category );

        like( $category->category, qr/^[ABC]$/, 'category is A,B or C' );
        like( $category->date, qr/^\d{4}-\d{2}-\d{2}$/,
            'category date looks correct' );
        ok( $category->opposition, 'has an opposition' );
    }
};

subtest 'Matches' => sub {
    my $matches = $ticket_info->matches;

    plan tests => ( @$matches * 4 ) + 3;

    ok($matches);

    my @availabilities;
    for my $match (@$matches) {
        isa_ok( $match, Match );

        push @availabilities, $match->availability if $match->availability;

        like(
            $match->datetime,
            qr/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$/,
            'match datetime looks correct'
        );
        ok( $match->opposition,  'has an opposition' );
        ok( $match->competition, 'has a competition' );
    }

    ok( @availabilities, 'have some availabilities' );
    my $availability = $availabilities[0]->[0];
    isa_ok( $availability, Availability );
};

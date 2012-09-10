#!perl

use strict;
use warnings;

use Test::More tests => 1;

use aliased 'WWW::ArsenalFC::TicketInformation';
use aliased 'WWW::ArsenalFC::TicketInformation::Category';

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
        ok( $category->opposition, 'have an opposition' );
    }
};

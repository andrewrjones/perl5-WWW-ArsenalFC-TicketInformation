use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation::Category;

use WWW::ArsenalFC::TicketInformation::Util ':all';

# ABSTRACT: Represents categories for upcoming Premier League fixtures.

use Object::Tiny qw{
  category
  date_string
  opposition
};

sub date {
    my ($self) = @_;

    if ( $self->date_string =~ /\w+\W+(\w+)\D(\d+)/ ) {
        my $year  = '2012';                # FIXME
        my $month = month_to_number($1);
        my $day   = $2;
        $day = "0$day" if $day =~ /^\d$/;
        return "$year-$month-$day";
    }
}

1;

__END__

=attr category

The category of the match (A, B or C).

=attr date_string

The date as it appears on the website.

=attr opposition

The opposition.

=method date

The date as YYYY-MM-DD.

=cut

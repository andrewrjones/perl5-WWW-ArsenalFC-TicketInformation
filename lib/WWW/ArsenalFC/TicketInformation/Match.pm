use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation::Match;

use WWW::ArsenalFC::TicketInformation::Match::Availability;

use WWW::ArsenalFC::TicketInformation::Util ':all';

# ABSTRACT: Represents an Arsenal match with ticket information.

use Object::Tiny qw{
  availability
  can_exchange
  competition
  datetime_string
  fixture
  hospitality
  is_soldout
};

sub is_home {
    my ($self) = @_;
    return $self->fixture =~ /^Arsenal/;
}

sub is_premier_league {
    my ($self) = @_;
    return $self->competition =~ /Premier League/;
}

sub datetime {
    my ($self) = @_;

    if ( $self->datetime_string =~ /\w+\W+(\w+)\D+(\d+)\D+(\d+)\D+(\d\d:\d\d)/ )
    {
        my $month = month_to_number($1);
        my $day   = $2;
        my $year  = $3;
        my $time  = $4;

        $day = "0$day" if $day =~ /^\d$/;
        return sprintf( "%s-%s-%sT%s:00", $year, $month, $day, $time );
    }
}

1;

__END__

=attr availability

An array of L<WWW::ArsenalFC::TicketInformation::Match::Availability> objects.

The first item in the array is the current availability. Second item is the next availability, and so on.

Note if the match is sold out or if the ticket exchange is open, this will not be set.

=attr can_exchange

True if the ticket exchange is open, otherwise false.

=attr competition

The competition the game is being played in (i.e. 'Barclays Premier League').

=attr datetime_string

The date and time of the game as it is displayed on the website (i.e. 'Saturday, May 5, 2012, 12:45').

=attr fixture

The fixture (i.e. 'Arsenal vs Norwich').

=attr hospitality

True if hospitality is available, otherwise false.

=cut

=attr is_soldout

True if sold out, otherwise false.

=cut

=method is_home

True if Arsenal are at home, otherwise false.

=cut

=method is_premier_league

True if this is a Premier League game.

=cut

=method datetime

Returns the date and time of the match as C<YYYY-MM-DDThh:mm:ss>.

=cut
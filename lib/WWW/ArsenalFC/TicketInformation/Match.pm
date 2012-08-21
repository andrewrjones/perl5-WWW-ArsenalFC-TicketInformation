use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation::Match;

use WWW::ArsenalFC::TicketInformation::Match::Availability;

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

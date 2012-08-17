use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation::Match;

# ABSTRACT: Represents an Arsenal match with ticket information.

use Object::Tiny qw{
  can_exchange
  competition
  datetime
  fixture
  hospitality
  is_soldout
};

sub is_home {
    my ($self) = @_;
    return $self->fixture =~ /^Arsenal/ ? 1 : 0;
}

1;

__END__

=attr can_exchange

True if the ticket exchange is open, otherwise false.

=attr competition

The competition the game is being played in (i.e. 'Barclays Premier League').

=attr datetime

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

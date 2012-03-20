use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation::Match;

# ABSTRACT: Represents an Arsenal match with ticket information.

use Object::Tiny qw{
  competition
  datetime
  fixture
  hospitality
};

1;

__END__

=attr competition

The competition the game is being played in (i.e. 'Barclays Premier League').

=attr datetime

The date and time of the game as it is displayed on the website (i.e. 'Saturday, May 5, 2012, 12:45').

=attr fixture

The fixture (i.e. 'Arsenal vs Norwich').

=attr hospitality

True if hospitality is available, otherwise false.

=cut

use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation::Category;

# ABSTRACT: Represents categories for upcoming Premier League fixtures.

use Object::Tiny qw{
  category
  date_string
  opposition
};

sub date {
    my ($self) = @_;
    # TODO
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

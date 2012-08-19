use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation::Match::Availability;

# ABSTRACT: Represents the availability of a match ticket.

use constant {

    # memberships
    GENERAL_SALE  => 1,
    RED           => 2,
    SILVER        => 3,
    GOLD          => 4,
    PLATINUM_GOLD => 5,

    # types
    FOR_SALE  => 1,
    SCHEDULED => 2,
};

use Object::Tiny qw{
  date
  membership
  type
};

1;

__END__

=attr date

The date the ticket becomes available, if scheduled for release.

=attr membership

The membership level this availability applies too.

=attr type

The type of availibility. I.e. is it scheduled for release or for sale.

Use as follows:

  given ($availability) {
    when (WWW::ArsenalFC::TicketInformation::Match::Availability->SCHEDULED) {...}
    when (WWW::ArsenalFC::TicketInformation::Match::Availability->FOR_SALE) {...}
  }

Tip: If you don't like the long names, use L<aliased>.
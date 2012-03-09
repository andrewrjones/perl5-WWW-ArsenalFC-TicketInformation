use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation;

# ABSTRACT: Get Arsenal FC ticket information for forthcoming matches

use LWP::Simple              ();
use HTML::TreeBuilder::XPath ();

# the URL on Arsenal.com
use constant URL => 'http://www.arsenal.com/membership/buy-tickets';

=method fetch()

Fetches the Arsenal ticket information. Returns an array of L<WWW::ArsenalFC::TicketInformation::Match> objects.

=cut

sub fetch {
    my $html = LWP::Simple::get(URL);

    return _parse_html($html);
}

# parse the HTML page and return an array of WWW::Arsenal::Tickets::Match
sub _parse_html {
    my ($html) = @_;

}

1;

=head1 SYNOPSIS

  my $matches = WWW::ArsenalFC::TicketInformation::fetch();

  for my $match (@$matches){
    ...
  }

=head1 DESCRIPTION

This is a module to get and parse the Arsenal ticket information for forthcoming matches (from http://www.arsenal.com/membership/buy-tickets).

=head1 SEE ALSO

=for :list
  * L<WWW::ArsenalFC::TicketInformation::Match>

=cut

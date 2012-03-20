use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation;

# ABSTRACT: Get Arsenal FC ticket information for forthcoming matches

use WWW::ArsenalFC::TicketInformation::Match;

use LWP::Simple              ();
use HTML::TreeBuilder::XPath ();

use Data::Dumper;

# the URL on Arsenal.com
use constant URL => 'http://www.arsenal.com/membership/buy-tickets';

=method fetch()

Fetches the Arsenal ticket information. Returns an array reference of L<WWW::ArsenalFC::TicketInformation::Match> objects.

=cut

sub fetch {
    my $html = LWP::Simple::get(URL);

    return _parse_html($html);
}

# parse the HTML page and return an array ref of WWW::Arsenal::Tickets::Match
sub _parse_html {
    my ($html) = @_;
    my @matches;

    # generate HTML tree
    my $tree = HTML::TreeBuilder::XPath->new_from_content($html);

    # get the table and loop over every 3 rows, as these
    # contain the matches
    # the second and third rows contain ...
    my $rows = $tree->findnodes('//table[@id="member-tickets"]/tr');
    for ( my $i = 0 ; $i < $rows->size() ; $i += 3 ) {
        my $row = $rows->[$i];

        my $fixture     = _trimWhitespace( $row->findvalue('td[2]/p[1]') );
        my $competition = _trimWhitespace( $row->findvalue('td[2]/p[2]') );
        my $datetime    = _trimWhitespace( $row->findvalue('td[2]/p[3]') );

        push @matches,
          WWW::ArsenalFC::TicketInformation::Match->new(
            competition => $competition,
            datetime    => $datetime,
            fixture     => $fixture,
          );
    }

    # return an array ref of matches
    return \@matches;
}

# trims whitespace from a string
sub _trimWhitespace {
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
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

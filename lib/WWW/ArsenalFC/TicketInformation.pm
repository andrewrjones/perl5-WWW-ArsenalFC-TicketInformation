use v5.10.1;
use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation;

# ABSTRACT: Get Arsenal FC ticket information for forthcoming matches

use WWW::ArsenalFC::TicketInformation::Match;
use WWW::ArsenalFC::TicketInformation::Match::Availability;

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
    # the second and third rows contain data on who can purchase tickets, if
    # its not yet available to Red members or general sale
    my $rows = $tree->findnodes('//table[@id="member-tickets"]/tr');
    for ( my $i = 0 ; $i < $rows->size() ; $i += 3 ) {
        my %match = ();
        my $row   = $rows->[$i];

        $match{fixture}     = _trimWhitespace( $row->findvalue('td[2]/p[1]') );
        $match{competition} = _trimWhitespace( $row->findvalue('td[2]/p[2]') );
        $match{datetime}    = _trimWhitespace( $row->findvalue('td[2]/p[3]') );
        $match{hospitality} = $row->exists(
            'td[3]//a[@href="http://www.arsenal.com/hospitality/events"]');

        $match{is_soldout}   = $row->exists('td[6]//span[@class="soldout"]');
        $match{can_exchange} = 0;

        if ( !$match{is_soldout} ) {

          AVAILABILITY:
            for ( my $j = $i ; $j < $i + 3 ; $j++ ) {
                my $availability_row = $rows->[$j];

                my @membership_nodes;
                if ( $j == $i ) {
                    @membership_nodes =
                      $availability_row->findnodes('td[5]/img[@title]');
                }
                else {
                    @membership_nodes =
                      $availability_row->findnodes('td[1]/img[@title]');
                }

                last AVAILABILITY unless @membership_nodes;

                my ( $availability_forsale, $availability_date );
                if ( $j == $i ) {
                    ( $availability_forsale, $availability_date ) =
                      _parse_availability(
                        $availability_row->findvalue('td[6]/p') );
                }
                else {
                    ( $availability_forsale, $availability_date ) =
                      _parse_availability(
                        $availability_row->findvalue('td[2]/p') );
                }

                for my $membership_node (@membership_nodes) {
                    my $membership = $membership_node->attr('title');
                    given ($membership) {
                        when (/Exchange/) {
                            $match{can_exchange} = 1;
                            last AVAILABILITY;
                        }
                        when (/General Sale/) {
                            $match{availability} //= [];

                            if ($availability_forsale) {

                                push @{ $match{availability} },
                                  WWW::ArsenalFC::TicketInformation::Match::Availability
                                  ->new(
                                    membership =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->GENERAL_SALE,
                                    type =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->FOR_SALE,
                                  );
                            }
                            elsif ($availability_date) {
                                push @{ $match{availability} },
                                  WWW::ArsenalFC::TicketInformation::Match::Availability
                                  ->new(
                                    membership =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->GENERAL_SALE,
                                    type =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->SCHEDULED,
                                    date => $availability_date
                                  );
                            }
                            last AVAILABILITY;
                        }
                        when (/Red Members/) {
                            $match{availability} //= [];

                            if ($availability_forsale) {

                                push @{ $match{availability} },
                                  WWW::ArsenalFC::TicketInformation::Match::Availability
                                  ->new(
                                    membership =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->RED,
                                    type =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->FOR_SALE,
                                  );
                            }
                            elsif ($availability_date) {

                                push @{ $match{availability} },
                                  WWW::ArsenalFC::TicketInformation::Match::Availability
                                  ->new(
                                    membership =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->RED,
                                    type =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->SCHEDULED,
                                    date => $availability_date
                                  );
                            }
                        }
                        when (/Silver Members/) {
                            $match{availability} //= [];

                            if ($availability_forsale) {

                                push @{ $match{availability} },
                                  WWW::ArsenalFC::TicketInformation::Match::Availability
                                  ->new(
                                    membership =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->SILVER,
                                    type =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->FOR_SALE,
                                  );
                            }
                            elsif ($availability_date) {
                                push @{ $match{availability} },
                                  WWW::ArsenalFC::TicketInformation::Match::Availability
                                  ->new(
                                    membership =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->SILVER,
                                    type =>
                                      WWW::ArsenalFC::TicketInformation::Match::Availability
                                      ->SCHEDULED,
                                    date => $availability_date
                                  );
                            }
                        }
                    }
                }
            }
        }

        push @matches, WWW::ArsenalFC::TicketInformation::Match->new(%match);
    }

    # return an array ref of matches
    return \@matches;
}

sub _parse_availability {
    my ($availability) = @_;

    given ($availability) {
        when (/Buy Now/) {
            return 1;
        }
        when (/(\d\d-\d\d-\d\d\d\d)/) {
            return ( undef, $1 );
        }
    }
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
  * L<WWW::ArsenalFC::TicketInformation::Match::Availability>

=cut

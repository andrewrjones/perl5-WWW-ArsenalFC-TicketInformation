use strict;
use warnings;

package WWW::ArsenalFC::TicketInformation::Util;

# ABSTRACT: Utility functions

require Exporter;
our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(month_to_number);
our %EXPORT_TAGS = ( all => \@EXPORT_OK );

my %mon2num = qw(
  jan 01  feb 02  mar 03  apr 04  may 05  jun 06
  jul 07  aug 08  sep 09  oct 10 nov 11 dec 12
);

sub month_to_number {
    my ($month) = @_;

    return $mon2num{ lc( substr( $month, 0, 3 ) ) };
}

1;

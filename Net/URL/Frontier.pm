package Net::URL::Formatter;

use warnings;
use strict 'vars';
use Carp qw/croak/;

use Exporter;
use vars qw/$VERSION @ISA @EXPORT @EXPORT_OK/;

$VERSION   = "1.0";
@ISA       = qw/Exporter/;
@EXPORT    = qw/beauty get_protocol get_host get_location/;
@EXPORT_OK = @EXPORT;

#-------------------------------------
sub beauty {
}

#------------------------------------

1;

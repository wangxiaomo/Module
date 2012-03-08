package Net::URL::Frontier;

use warnings;
use strict 'vars';
use Carp qw/croak/;

use Exporter;
use vars qw/$VERSION @ISA @EXPORT @EXPORT_OK/;

$VERSION   = "1.0";
@ISA       = qw/Exporter/;
@EXPORT    = qw/beauty digest/;
@EXPORT_OK = @EXPORT;

BEGIN { 
    require URI;
    require Digest::HMAC_SHA1;
    require MIME::Base64;
}

#-------------------------------------
sub type {
    my $url = shift;
    if ($url =~ /^http:\/\//) {
        return "http://";
    } elsif ($url =~ /^https:\/\//) {
        return "https://";
    } else {
        croak "Unknown!";
    }
}

sub beauty {
    my $url = shift;
    my $uri = URI->new($url);
    return type($url)
         . $uri->host_port
         . $uri->path;
}

sub digest {
    use Digest::HMAC_SHA1;
    use MIME::Base64;
    return encode_base64(Digest::HMAC_SHA1->new(shift)->digest);
}

#------------------------------------

1;

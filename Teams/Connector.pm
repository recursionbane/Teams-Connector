=head1 NAME

Teams::Connector - An interface to Microsoft's Teams API via Incoming Webhook Connectors

=head1 SYNOPSIS

    use Teams::Connector;
    my $teams = Teams::Connector->new( { url => INCOMING_WEBHOOK_URL } );
    $teams->send_text_string("Hello there");
    $teams->send_title_and_text_string("My title", "My content");
    $teams->send_hash(\%hash_ref); # For advanced connector cards

=head1 DESCRIPTION

This module exists as an interface to curl to simplify sending Cards to Microsoft Teams via the Incoming Webhook API.

=head1 LICENSE

Released under MIT license.

=cut

package Teams::Connector;

use strict;
use warnings;

use Exporter;

use Scalar::Util 'reftype';
use File::Slurp;
use JSON;

use vars qw(@ISA @EXPORT_OK %EXPORT_TAGS $VERSION);
@ISA = qw(Exporter);
@EXPORT_OK = qw(
	send_text_string
	send_title_and_text_string
	send_hash
);
%EXPORT_TAGS = ('all' => \@EXPORT_OK);
$VERSION = '20170321';

# Constructor
sub new {
    my ($class, $options) = @_;
    my $self = $options;

    my $this_sub = "Teams::Connector::new";

    die "\nERR\t$this_sub: Options should be a hash-reference, but is a " . ref( $options ) unless ( !defined $options || ref $options eq 'HASH' );
    die ( "\nERR\t$this_sub: url is a required field!" ) unless ( defined ( $options->{url} ) );

    $self->{url} = $options->{url};

    # Good to go!
    return bless($self, $class);
}

# To send a simple text message
# Returns: HTTP response
sub send_text_string {
    my ( $self, $raw_text ) = @_;
    my $this_sub = "Teams::Connector::send_text_string";

    die( "\nERR\t$this_sub: Argument must be a scalar string; supplied argument was '$raw_text'" ) unless( !defined reftype( $raw_text ) || reftype( $raw_text ) eq '' );
    return send_hash( $self, { text => $raw_text } );
}

# To send a title and text message
# Returns: HTTP response
sub send_title_and_text_string {
    my ( $self, $title, $raw_text ) = @_;
    my $this_sub = "Teams::Connector::send_title_and_text_string";

    die( "\nERR\t$this_sub: Title argument must be a scalar string; supplied argument was '$title'" ) unless( !defined reftype( $title ) || reftype( $title ) eq '' );
    die( "\nERR\t$this_sub: Text argument must be a scalar string; supplied argument was '$raw_text'" ) unless( !defined reftype( $raw_text ) || reftype( $raw_text ) eq '' );
    return send_hash( $self, { title => $title, text => $raw_text } );
}

# The base function to send all data, just send a hash
# A non-blocking call; the delay between calling this routine and the message actually showing up can be up to 30 seconds!
# API reference: https://dev.outlook.com/Connectors/Reference
sub send_hash {
    my ( $self, $hash_ref ) = @_;
    my $this_sub = "Teams::Connector::send_hash";
    
    die( "\nERR\t$this_sub: Argument must be a hash reference; supplied argument was " . ref($hash_ref) ) unless( ref( $hash_ref ) eq 'HASH' );    
    
    # TODO: Use a native module to perform these requests
    # Until that's figured out, fall back on commandline curl

    # Dump the hash to a JSON file, then use curl to send the file
    write_file( "upload_to_teams.json", {atomic => 1}, JSON->new->pretty->utf8->encode( $hash_ref ) );
    my $curl_request = 'curl -k --header "Content-Type:application/json" -X POST --data-binary "@upload_to_teams.json" ' . $self->{url} . ' >& /dev/null &';
    return system $curl_request;
}

1;


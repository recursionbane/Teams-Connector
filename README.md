# Teams::Connector
A Perl module for interfacing with [Microsoft Teams](https://teams.microsoft.com)' [Incoming Webhook](https://msdn.microsoft.com/en-us/microsoft-teams/connectors)

# Requirements
* [File::Slurp](https://metacpan.org/pod/File::Slurp)
* [JSON](https://metacpan.org/pod/JSON)
* [curl](https://curl.haxx.se/docs/manpage.html)

# Usage
    use Teams::Connector;
    my $teams = Teams::Connector->new( { url => INCOMING_WEBHOOK_URL } );
    $teams->send_text_string("Hello there");
    $teams->send_title_and_text_string("My title", "My content");
    $teams->send_hash(\%hash_ref); # For advanced connector cards

# Notes
* You must first create an Incoming Webhook in your Team's channel and specify it when you call Teams::Connector::new()
* There are invisible payload limits; if your payload is past this limit, the card will not show
* Encoded images are not supported

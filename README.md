# Teams-Connector
A Perl module for interfacing with Microsoft Teams' Incoming Webhook

# Requirements
* File::Slurp
* JSON
* curl

# Usage
    use Teams::Connector;
    my $teams = Teams::Connector->new( { url => INCOMING_WEBHOOK_URL } );
    $teams->send_text_string("Hello there");
    $teams->send_title_and_text_string("My title", "My content");
    $teams->send_hash(\%hash_ref); # For advanced connector cards

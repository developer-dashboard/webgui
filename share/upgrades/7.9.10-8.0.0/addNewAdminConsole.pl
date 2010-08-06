
use WebGUI::Upgrade::Script;
use List::MoreUtils qw( any );

report "\tAdding new Admin Console...";

if ( ! any { $_ eq 'WebGUI::Content::Admin' } @{session->config->get('contentHandlers')} ) {
    session->config->addToArrayAfter( 
        'contentHandlers', 'WebGUI::Content::Referral', 'WebGUI::Content::Admin'
    );
}

# Remove irrelevant Admin Console items
session->config->deleteFromHash( 'adminConsole', 'adminConsoleOff' );
session->config->deleteFromHash( 'adminConsole', 'assets' );

done;

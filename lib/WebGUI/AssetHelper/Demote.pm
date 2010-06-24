package WebGUI::AssetHelper::Demote;

use strict;
use Class::C3;
use base qw/WebGUI::AssetHelper/;

=head1 LEGAL

 -------------------------------------------------------------------
  WebGUI is Copyright 2001-2009 Plain Black Corporation.
 -------------------------------------------------------------------
  Please read the legal notices (docs/legal.txt) and the license
  (docs/license.txt) that came with this distribution before using
  this software.
 -------------------------------------------------------------------
  http://www.plainblack.com                     info@plainblack.com
 -------------------------------------------------------------------

=head1 NAME

Package WebGUI::AssetHelper::Demote

=head1 DESCRIPTION

Demotes the asset with respect to its siblings.

=head1 METHODS

These methods are available from this class:

=cut

#-------------------------------------------------------------------

=head2 process ( $class, $asset )

Demotes the asset.  If the user cannot edit the asset it returns an error message.

=cut

sub process {
    my ($class, $asset) = @_;
    my $session = $asset->session;

    my $i18n = WebGUI::International->new($session, 'WebGUI');
    if (! $asset->canEdit) {
        return { error => $i18n->get('38'), };
    }

    my $success = $asset->demote();
    if (! $success) {
        return {
            error => sprintf($i18n->get('unable to demote assset', 'Asset'), $asset->getTitle),
        };
    }

    return {
        message => sprintf($i18n->get('demoted asset', 'Asset'), $asset->getTitle),
    };
}

1;
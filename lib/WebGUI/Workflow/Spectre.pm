package WebGUI::Workflow::Spectre;


=head1 LEGAL

 -------------------------------------------------------------------
  WebGUI is Copyright 2001-2012 Plain Black Corporation.
 -------------------------------------------------------------------
  Please read the legal notices (docs/legal.txt) and the license
  (docs/license.txt) that came with this distribution before using
  this software.
 -------------------------------------------------------------------
  http://www.plainblack.com                     info@plainblack.com
 -------------------------------------------------------------------

=cut

use strict;
use POE::Component::IKC::ClientLite;


=head1 NAME

Package WebGUI::Workflow::Spectre

=head1 DESCRIPTION

This package is used to send messages between the workflow system and Spectre.

=head1 SYNOPSIS

 use WebGUI::Workflow::Spectre;

=head1 METHODS

These methods are available from this class:

=cut

#-------------------------------------------------------------------

=head2 notify ( module, params )

Sends a message to Spectre. Returns true iff the message was successfully
sent.

=head3 module

The module/method pair you wish to communicate with in Spectre. 

=head3 params

A scalar, array reference, or hash reference of data to pass to Spectre.

=cut

sub notify {
	my $self = shift;
	my $module = shift;
	my $params = shift;
	my ($config, $log) = $self->session->quick("config", "log");
	my $remote = create_ikc_client(
                port=>$config->get("spectrePort"),
                ip=>$config->get("spectreIp"),
                name=> (time() . int(rand(10000000))),
                timeout=>10
                );
	if (defined $remote) {
		my $result = $remote->post($module, $params);
		return 1 if defined $result;
		$log->warn("Couldn't send command to Spectre because ".$POE::Component::IKC::ClientLite::error);
	} else {
		$log->warn("Couldn't connect to Spectre because ".$POE::Component::IKC::ClientLite::error);
	}
	return 0;
}

#-------------------------------------------------------------------

=head2 new ( session )

Constructor.

=head3 session

A reference to the current session.

=cut

sub new {
	my $class = shift;
	my $session = shift;
	bless {_session=>$session}, $class;
}

#-------------------------------------------------------------------

=head2 session ( ) 

Returns a reference to the current session.

=cut

sub session {
        my $self = shift;
        return $self->{_session};
}  

1;


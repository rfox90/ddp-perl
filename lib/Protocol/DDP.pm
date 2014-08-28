package Protocol::DDP;

use strict;
use warnings;

use Moo;
use AnyEvent::WebSocket::Client;
use JSON;


our $VERSION  = "1.0";

has client => (
	is => 'ro',
	default => sub {
		return AnyEvent::WebSocket::Client->new
	}
);

has uri => (
	is => 'rw',
	default => 'ws::/localhost/websocket'
);

has connection => (
	is => 'rw'
);

#For now just encodes as json and returns
sub prepareMessage {
	my($self,$message) = @_;
	my $ret = encode_json($message);
	return $ret;
}

sub onSocketConnected {
	my ($self) = @_;
	# send a message through the websocket...
   	my $jsonMessage = $self->prepareMessage(
   		{
   			msg=>'connect',
   			version=>'pre2',
   			support=>['pre2']
   		}
   	);
   	print "$jsonMessage\n";
   	$self->connection->send($jsonMessage);
   	sleep 5;
   	#$self->subscribe('biscuits');
}

sub subscribe {
	my ($self, $name, $args) = @_;
	my $message = $self->prepareMessage({
			msg=>'sub',
			name=>$name,
			id=>'1'
		});
	print $message;
	$self->connection->send($message);
}

sub connect {
	my($self) = @_;
	print "trying to connect\n";
	$self->client->connect("ws://localhost:3000/websocket")->cb(
		sub {
   			$self->connection(eval { shift->recv });
   			if($@) {
				# handle error...
				warn $@;
				return;
   			}
   			print "Connected to Meteor!\n";
   			$self->onSocketConnected();
		  
		   	
		   # recieve message from the websocket...
		   $self->connection->on(each_message => sub {
			 # $self->connection is the same connection object
			 # $message isa AnyEvent::WebSocket::Message
			 my($connection, $message) = @_;
			 print $message->body."\n";
		   });
		   
		   # handle a closed connection...
		   $self->connection->on(finish => sub {
			 # $self->connection is the same connection object
			 $self->connection(@_);
		   });

		   # close the connection (either inside or
		   # outside another callback)
		   $self->connection->close;
		}
 	);
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Protocol::DDP - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Protocol::DDP;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Protocol::DDP, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

root, E<lt>root@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by root

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut

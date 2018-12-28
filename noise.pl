#!/usr/bin/perl
# Write some dummy message to STDOUT or STDERR
# and keep track if their number is case it stopped
#
# To stop gently this script from an other console send the
# TERM siglal to its process e.g.  kill -s TERM 57030
#
# George Bouras
# Athens/Greece 26 Mar 2018

use strict;
use warnings;
use feature qw/say/;

my $print_stdout	= 1;
my $print_stderr	= 1;
my $loop_wait_sec	= 1;
my $signal			= 'running';
my @severity		= qw/INFO WARN DEBUG AUDIT/;
my @service			= qw/ServiceController ocp-edge dock01 dock02 ocp-transmit ocp-lool ocp-dev null selfcheck mutual ocp-gem/;
my @trace           = map {sprintf "%x", $_ } 100000..101000;
my @exportable		= qw/true false/;
my @pid				= 1..65535;
my @thread			= map { "nio-$_-exec-1" } 8000..8899;
my @class			= map { "i.s.c.sleuth.docs.service$_.Application" } 1..1000;
my @message			= GenerateMessage(normal=>100, exeption=>100);

# On usual stop signals we change the value of $status
# to know later that we must exit gently the main loop !
BEGIN {map { $SIG{$_} = sub{$signal=$_[0]} } qw/STOP TERM KILL QUIT ABRT INT/} 

Emmit("Starting with pid $$");

while (1) {

	unless ($signal eq 'running') {
	Emmit("Exit because we receive the signal $signal");
	exit 0
	}

Emmit(Event());
sleep $loop_wait_sec
}



	###############
	#  Functions  #
	###############


sub Event {
my @Time		= localtime time;
my $timestamp	= sprintf '%04d-%02d-%02d %02d:%02d:%02d.000', 1900+$Time[5], 1+$Time[4], @Time[3,2,1,0];
my $severity	= $severity[	int rand @severity	];
my $service		= $service[		int rand @service	];
my $trace		= $trace[		int rand @trace		];
my $span		= $trace[		int rand @trace		];
my $exportable	= $exportable[	int rand @exportable];
my $pid			= $pid[			int rand @pid		];
my $thread		= $thread[		int rand @thread	];
my $class		= $class[		int rand @class		];
my $message		= $message[		int rand @message	];
"$timestamp $severity [$service,$trace,$span,$exportable] $pid --- [$thread] $class : $message"
}


sub GenerateMessage {
my %opt		= @_;
my @message = ();
my @service = map { "service$_" } 1..1000;
my @severity = qw/ERROR CRTITICAL/;
my $exception=<<OSEEDO;
Problem starting service jboss:service=invoker,type=pooled
java.net.SocketException: Unrecognized Windows Sockets error: 0: JVM_Bind
        at java.net.PlainSocketImpl.socketBind(Native Method)
        at java.net.PlainSocketImpl.bind(PlainSocketImpl.java:359)
        at java.net.ServerSocket.bind(ServerSocket.java:319)
        at org.jboss.mx.interceptor.ReflectedDispatcher.invoke(ReflectedDispatcher.java:141)
        at org.jboss.mx.server.MBeanServerImpl.invoke(MBeanServerImpl.java:644)
        mpl.invoke(DelegatingMethodAccessorImpl.java:25)
        at java.lang.reflect.Method.invoke(Method.java:592)
        at org.jboss.Main\$1.run(Main.java:438)
        at java.lang.Thread.run(Thread.java:595)
OSEEDO

	for (1..$opt{normal}) {
	my $service1 = $service[	int rand @service];
	my $service2 = $service[	int rand @service];
	my $service3 = $service[	int rand @service];
	push @message, "Hello from $service1. Calling $service2 and then $service3"
	}

	for (1..$opt{exeption}) {
	my $severity	= $severity[int rand @severity];
	my @Time		= localtime time;
	my $milli		= int rand 1000;
	my $timestamp	= sprintf '%02d:%02d:%02d', @Time[2,1,0];
	my $service		= $service[	int rand @service ];
	push @message, "$severity  $timestamp,$milli [$service] $exception"
	}

@message
}


sub Emmit {
say STDERR $_[0] if $print_stderr;
say STDOUT $_[0] if $print_stdout
}

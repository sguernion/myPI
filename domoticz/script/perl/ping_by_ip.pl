#!/usr/bin/env perl
   use v5.14;
   use LWP::Simple;                # From CPAN
   use JSON qw( decode_json );     # From CPAN
   use Data::Dumper;               # Perl core module
   use strict;                     # Good practice
   use warnings;                   # Good practice
   use utf8;
   use Config::Simple;
   use feature     qw< unicode_strings >;
   # Configuration section, please update to your values
   my $conf = "/home/pi/domoticz/scripts/lua/config.properties";
   my $cfg;
   my $Config=&read_conf($conf);
   
   # ip and port of your Domoticz server 
   my $domoticz = $Config->{"domoticz.domoticz.ip"}.":".$Config->{"domoticz.domoticz.port"}; 
   my $domo_cmd = "http://$domoticz/json.htm?type=devices&filter=all&used=true&order=Name";

  
   my @servers;
   @servers = $Config->{"global.servers.ping.device"};
  
   my $debug=0;
   # Get the JSON url
   my $json = get( $domo_cmd );
   die "Could not get $domo_cmd!" unless defined $json;
   # Decode the entire JSON
   my $decoded = JSON->new->utf8(0)->decode( $json );
   my @results = @{ $decoded->{'result'} };
   #Put JSON switch and status in a Table
   my @tab;
   foreach my $f ( @results ) {
     if ($f->{"SwitchType"}) {
           $tab[$f->{"idx"}]=$f->{"Status"};
     }
   }
   # Now we go all over the IP to check if they are alive
   foreach  (values $servers[0] ) {
		   my $k = $Config->{"global.server.".$_.".idx"};
           my $ip = $Config->{"global.server.".$_.".ip"};
		    #print $_." ".$k." ".$ip;
		   
           my $res=system("sudo ping $ip -w 3 2>&1 > /dev/null");
		   #print $k." ".$res."\n";
           if (($res==0)&&($tab[$k] eq 'Off')) {
                   #If device answered to ping and device status is Off, turn it On in Domoticz
                   if ($debug) {print "$k is On\n"};
                  `curl -s "http://$domoticz/json.htm?type=command&param=switchlight&idx=$k&switchcmd=On"`;
           } elsif (($res!=0)&&($tab[$k] eq 'On')) {
                   #If device did NOT answer to ping and device status is On, turn it Off in Domoticz
                   if ($debug) {print "$k is Off\n"};
                  `curl -s "http://$domoticz/json.htm?type=command&param=switchlight&idx=$k&switchcmd=Off"`;
           } else {
                   if ($debug) {print "do nothing: $k is ".$tab[$k]."\n";}
           }
   }
   
   
 sub read_conf {
	my $conf=$_[0];
	$cfg = new Config::Simple($conf) or die Config::Simple->error();
	$cfg->autosave(1);
	# getting the values as a hash:
	#print $cfg->vars();
	my %Config = $cfg->vars();
	return \%Config;
}
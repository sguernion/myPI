#!/usr/bin/perl
   use v5.14;
   use LWP::Simple;                # From CPAN
   use JSON qw( decode_json );     # From CPAN
   use Data::Dumper;               # Perl core module
   use strict;                     # Good practice
   use warnings;                   # Good practice
   use utf8;
   use feature     qw< unicode_strings >;
   # Configuration section, please update to your values
   my $domoticz = "192.168.0.17:8080";  # ip and port of your Domoticz server 
   my $domo_cmd = "http://$domoticz/json.htm?type=devices&filter=all&used=true&order=Name";

           # Array of (device idx, IP)
                     my %IP=(15=>'192.168.0.10',	# Ip 1
                             18=>'192.168.0.11',
							19=>'192.168.0.12',
							16=>'192.168.0.13',
							17=>'192.168.0.14',
							25=>'192.168.0.15');      # Ip 3
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
   foreach my $k (keys %IP) {
           my $ip=$IP{$k};
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
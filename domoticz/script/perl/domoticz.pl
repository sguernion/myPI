#!/usr/bin/env perl
   use v5.14;
   use LWP::Simple;                # From CPAN
   use Data::Dumper;               # Perl core module
   use strict;                     # Good practice
   use warnings;                   # Good practice
   use utf8;
   use Switch;
   use Config::Simple;
   use feature     qw< unicode_strings >;
   
################################################

   
	# Configuration section, please update to your values
   my $conf = "/home/pi/domoticz/scripts/config.properties";
   my $cfg;
   my $host;
   my $idx;
   my $cmd;
   my $Config=&read_conf($conf);
   my $ConfigIdx=&read_conf("/home/pi/domoticz/scripts/domoticz.properties");
   
   # ip and port of your Domoticz server 
   my $url = $Config->{"default.domoticz.url"}; 
   my $command=$ARGV[0];
   
switch ( $command ) {
	case "volume_up" {
		my $idx_vol_up = $ConfigIdx->{"switchs.idx.D_AMPLI_VUP"}; 
		#print $url.'type=command&param=switchlight&idx='.$idx_vol_up.'&switchcmd=On';
		setSwitch($url,$idx_vol_up,"On");
	}
	case "volume_down" {
		my $idx_vol_down = $ConfigIdx->{"switchs.idx.D_AMPLI_VDOWN"};
		setSwitch($url,$idx_vol_down,"On");
	}
	case "mute_on" {
		my $idx_vol_mute = $ConfigIdx->{"switchs.idx.D_AMPLI_MUTE"}; 
		setSwitch($url,$idx_vol_mute,"On");
	}
	# update variable
	case "source" {
		my $idx_v_source = $ConfigIdx->{"switchs.idx.V_SOURCE"}; 
		setSwitch($url,$idx_v_source,"On");
	}
	case "v_volume_up" {
		my $idx_v_volume_up = $ConfigIdx->{"switchs.idx.V_VOLUMEUP"};  
		 setSwitch($url,$idx_v_volume_up,"On");
	}
	case "v_volume_down" {
		my $idx_v_volume_down = $ConfigIdx->{"switchs.idx.V_VOLUMEDOWN"};
		setSwitch($url,$idx_v_volume_down,"On");
	}
	case "v_mute_on" {
		my $idx_v_mute = $ConfigIdx->{"switchs.idx.V_MUTE"}; 
		setSwitch($url,$idx_v_mute,"On");
	}
}


 sub setSwitch {
	my $host=$_[0];
	my $idx=$_[1];
	my $cmd=$_[2];
	get($host."type=command&param=switchlight&idx=".$idx."&switchcmd=".$cmd);
 
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
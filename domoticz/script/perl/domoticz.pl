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
   my $conf = "/home/pi/domoticz/scripts/lua/config.properties";
   my $cfg;
   my $Config=&read_conf($conf);
   
   # ip and port of your Domoticz server 
   my $url = $Config->{"default.domoticz.url"}; 
   my $command=$ARGV[0];
   
switch ( $command ) {
	case "volume_up" {
		my $idx_vol_up = $Config->{"default.idx.vol.up"}; 
		#print $url.'type=command&param=switchlight&idx='.$idx_vol_up.'&switchcmd=On';
		get($url.'type=command&param=switchlight&idx='.$idx_vol_up.'&switchcmd=On');
	}
	case "volume_down" {
		my $idx_vol_down = $Config->{"default.idx.vol.down"};
		get($url."type=command&param=switchlight&idx=".$idx_vol_down."&switchcmd=On");
	}
	case "mute_on" {
		my $idx_vol_mute = $Config->{"default.idx.mute"}; 
		get($url."type=command&param=switchlight&idx=".$idx_vol_mute."&switchcmd=On");
	}
	# update variable
	case "source" {
		my $idx_v_source = $Config->{"default.idx.v_source"}; 
		get($url."type=command&param=switchlight&idx=".$idx_v_source."&switchcmd=On");
	}
	case "v_volume_up" {
		my $idx_v_volume_up = $Config->{"default.idx.v_volume.up"};  
		 get($url."type=command&param=switchlight&idx=".$idx_v_volume_up."&switchcmd=On");
	}
	case "v_volume_down" {
		my $idx_v_volume_down = $Config->{"default.idx.v_volume.down"};
		get($url."type=command&param=switchlight&idx=".$idx_v_volume_down."&switchcmd=On");
	}
	case "v_mute_on" {
		my $idx_v_mute = $Config->{"default.idx.v_mute"}; 
		get($url."type=command&param=switchlight&idx=".$idx_v_mute."&switchcmd=On");
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
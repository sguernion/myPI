#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *
import ConfigParser

config = ConfigParser.RawConfigParser()
config.read('/home/pi/domoticz/scripts/domoticz.properties')


idx_vol_mute = config.get('variables', 'idx.amp_mute');
idx_vol_up = config.get('switchs', 'idx.D_AMPLI_VUP');
idx_vol_down = config.get('switchs', 'idx.D_AMPLI_VDOWN');
idx_v_mute = config.get('switchs', 'idx.V_MUTE');
idx_v_source = config.get('switchs', 'idx.V_SOURCE');
idx_v_volume_up = config.get('switchs', 'idx.V_VOLUMEUP');
idx_v_volume_down = config.get('switchs', 'idx.V_VOLUMEDOWN');

command = sys.argv[1]

api = DomoticzApi()

if command=='volume_up':
     api.set_state_idx(idx_vol_up,'On')
elif command=='volume_down':
     api.set_state_idx(idx_vol_down,'On')
elif command=='mute_on':
     api.set_state_idx(idx_vol_mute,'On')
elif command=='source':
     api.set_state_idx(idx_v_source,'On')
elif command=='v_volume_up':
     api.set_state_idx(idx_v_volume_up,'On')
elif command=='v_volume_down':
     api.set_state_idx(idx_v_volume_down,'On')
elif command=='v_mute_on':
     api.set_state_idx(idx_v_mute,'On')

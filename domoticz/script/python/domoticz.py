#!/usr/bin/env python

import time
import sys 
import os
sys.path.append(os.path.abspath("/home/pi/domoticz/scripts"))
from domoticz_api import *


idx_vol_mute = config.get('domoticz', 'idx.mute');
idx_vol_up = config.get('domoticz', 'idx.vol.up');
idx_vol_down = config.get('domoticz', 'idx.vol.down');
idx_v_mute = config.get('domoticz', 'idx.v_mute');
idx_v_source = config.get('domoticz', 'idx.v_source');
idx_v_volume_up = config.get('domoticz', 'idx.v_volume.up');
idx_v_volume_down = config.get('domoticz', 'idx.v_volume.down');

command = sys.argv[1]

if command=='volume_up':
     set_state_idx(idx_vol_up,'On')
elif command=='volume_down':
     set_state_idx(idx_vol_down,'On')
elif command=='mute_on':
     set_state_idx(idx_vol_mute,'On')
elif command=='source':
     set_state_idx(idx_v_source,'On')
elif command=='v_volume_up':
     set_state_idx(idx_v_volume_up,'On')
elif command=='v_volume_down':
     set_state_idx(idx_v_volume_down,'On')
elif command=='v_mute_on':
     set_state_idx(idx_v_mute,'On')

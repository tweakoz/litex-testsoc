#!/usr/bin/env python3
import json

import ork.config
import ork.path
import ork.deco

deco = ork.deco.Deco()
stage_dir = ork.path.prefix()
soc_config_path = stage_dir/"soc-config.json"
my_config = ork.config.load( soc_config_path )
print(deco.white("###############################"))
print(deco.white("## soc configuration file<%s>"%deco.path(soc_config_path)))
print(deco.white("###############################"))
print(deco.yellow(json.dumps(my_config, sort_keys=True, indent=4)))

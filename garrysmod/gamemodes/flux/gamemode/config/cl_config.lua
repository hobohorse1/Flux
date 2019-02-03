local category = config.create_category('general', 'General Settings', 'General settings related to the framework itself.')
category.add_table_editor('command_prefixes', 'Command Prefixes', 'What chat prefixes to consider as command prefixes (*prefix*someCommand, e.g. /someCommand)')
category.add_slider('walk_speed', 'Walk Speed', 'How fast does the player walk?', { min = 0, max = 1024, default = 100 })
category.add_slider('run_speed', 'Run Speed', 'How fast does the player run (while holding SHIFT by default)?', { min = 0, max = 1024, default = 200 })
category.add_slider('crouched_speed', 'Crouchwalk Speed', 'How fast does the player walk while crouched (while holding CTRL by default)?', { min = 0, max = 1024, default = 55 })
category.add_slider('respawn_delay', 'Respawn Time', 'How long does it take for a player to respawn after their death (in seconds)?', { min = 0, max = 600, default = 30 })

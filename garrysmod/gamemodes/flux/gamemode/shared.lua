--[[
	Flux © 2016-2017 TeslaCloud Studios
	Do not share or re-distribute before
	the framework is publicly released.
--]]

-- Define basic GM info fields.
GM.Name 		= "Flux"
GM.Author 		= "TeslaCloud Studios"
GM.Website 		= "http://teslacloud.net/"
GM.Email 		= "support@teslacloud.net"

-- Define Flux-Specific fields.
GM.Version 		= "0.2.1-indev"
GM.Build 		= "1384"
GM.Description 	= "A free roleplay gamemode framework."

-- It would be very nice of you to leave below values as they are if you're using official schemas.
-- While we can do nothing to stop you from changing them, we'll very much appreciate it if you don't.
GM.Prefix		= "FL: " -- Prefix to display in server browser (*Prefix*: *Schema Name*)
GM.NameOverride	= false -- Set to any string to override schema's browser name. This overrides the prefix too.

fl.Devmode		= true -- If set to true will print some developer info. Moderate console spam.

-- Fix for the name conflicts.
_player, _team, _file, _table, _data, _sound = player, team, file, table, data, sound

-- do - end blocks let us manage the lifespan of the
-- local variables, because when they go out of scope
-- they get automatically garbage-collected, freeing up
-- the memory they have taken.
-- In this particular case it's not necessary, because we
-- already have if - then - end structure, but I thought leaving
-- an example somewhere in the init code would be nice.
do
	if (engine.ActiveGamemode() != "flux") then
		fl.schema = engine.ActiveGamemode()
	else
		local SchemaConVar = GetConVar("schema")

		if (SchemaConVar) then
			fl.schema = fl.schema or SchemaConVar:GetString()
		else
			fl.schema = fl.schema or "reborn"
		end
	end

	-- Shared table contains the info that will be networked
	-- to clients automatically when they load.
	fl.sharedTable = fl.sharedTable or {
		schemaFolder = fl.schema,
		pluginInfo = {},
		unloadedPlugins = {}
	}
end

-- A function to get schema's name.
function fl.GetSchemaName()
	if (Schema) then
		return Schema:GetName()
	else
		return "Unknown"
	end
end

-- Called when gamemode's server browser name needs to be retrieved.
function GM:GetGameDescription()
	local nameOverride = self.NameOverride

	return (isstring(nameOverride) and nameOverride) or self.Prefix..fl.GetSchemaName()
end

do
	local schemaFolder = fl.schema

	fl.sharedTable.dependencies = fl.sharedTable.dependencies or {}
	fl.sharedTable.disable = fl.sharedTable.disable or {}

	if (SERVER) then
		if (file.Exists("gamemodes/"..schemaFolder.."/dependencies.lua", "GAME")) then
			fl.sharedTable.dependencies = include(schemaFolder.."/dependencies.lua")
		end

		if (file.Exists("gamemodes/"..schemaFolder.."/disable.lua", "GAME")) then
			fl.sharedTable.disable = include(schemaFolder.."/disable.lua")
		end
	end

	function fl.SchemaDepends(id)
		return fl.sharedTable.dependencies[id]
	end

	function fl.SchemaDisabled(id)
		return fl.sharedTable.disable[id]
	end
end

AddCSLuaFile("core/sh_enums.lua")
AddCSLuaFile("core/sh_util.lua")
AddCSLuaFile("core/sh_core.lua")
include("core/sh_enums.lua")
include("core/sh_util.lua")
include("core/sh_core.lua")

util.Include("core/cl_core.lua")
util.Include("core/sv_core.lua")

-- This way we put things we want loaded BEFORE anything else in here, like plugin, config, etc.
util.IncludeDirectory("core/libraries/required", true)

-- So that we don't get duplicates on refresh.
plugin.ClearCache()

util.IncludeDirectory("core/config", true)
util.IncludeDirectory("core/libraries", true)
util.IncludeDirectory("core/libraries/classes", true)
util.IncludeDirectory("core/libraries/meta", true)
util.IncludeDirectory("languages", true)
fl.admin:IncludeGroups("flux/gamemode/core/groups")
util.IncludeDirectory("core/commands", true)
util.IncludeDirectory("core/derma/base", true)
util.IncludeDirectory("core/derma/admin", true)
util.IncludeDirectory("core/derma", true)
item.IncludeItems("flux/gamemode/core/items")

if (theme or SERVER) then
	pipeline.Register("theme", function(uniqueID, fileName, pipe)
		if (CLIENT) then
			THEME = Theme(uniqueID)

			util.Include(fileName)

			THEME:Register() THEME = nil
		else
			util.Include(fileName)
		end
	end)

	-- Theme factory is needed for any other themes that may be in the themes folder.
	pipeline.Include("theme", "core/themes/cl_theme_factory.lua")

	pipeline.IncludeDirectory("theme", "flux/gamemode/core/themes")
end

pipeline.IncludeDirectory("tool", "flux/gamemode/core/tools")

util.IncludeDirectory("hooks", true)
fl.core:IncludePlugins("flux/plugins")

hook.Run("FluxPluginsLoaded")

fl.core:IncludeSchema()

hook.Run("FluxSchemaLoaded")
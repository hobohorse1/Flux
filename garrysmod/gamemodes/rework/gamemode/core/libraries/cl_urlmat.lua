--[[ 
	Rework © 2016 TeslaCloud Studios
	Do not share, re-distribute or sell.
--]]

library.New("urlmat", rw);
local cache = rw.urlmat.cache or {};
rw.urlmat.cache = cache;

function rw.urlmat:CacheMaterial(url)
	local urlCRC = util.CRC(url);
	local exploded = string.Explode("/", url);
	local extension = "."..string.GetExtensionFromFilename(exploded[#exploded])
	local path = "rework/materials/"..urlCRC..extension;

	if (_file.Exists(path, "DATA")) then
		cache[urlCRC] = Material("../data/"..path, "noclamp smooth"); 
		return;
	end;

	local directories = string.Explode("/", path);
	local currentPath = "";

	for k, v in pairs(directories) do
		if (k < #directories) then
			currentPath = currentPath..v.."/";
			file.CreateDir(currentPath);
		end;
	end;

	http.Fetch(data.url, function(body, length, headers, code)
		path = path:gsub(".jpeg", ".jpg");
		file.Write(path, body);
		cache[urlCRC] = Material("../data/"..path, "noclamp smooth");
	end);
end;

function URLMaterial(url)
	local urlCRC = util.CRC(url);

	if (cache[urlCRC]) then
		return cache[urlCRC];
	end;

	if (!cache["CACHING_"..urlCRC]) then
		rw.urlmat:CacheMaterial(url);
		cache["CACHING_"..urlCRC] = true; -- we're in progress!
	end;

	-- return some default material here as placeholder!
end;
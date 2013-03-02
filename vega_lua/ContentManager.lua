--- Manages the external content resources (loads and stores).
ContentManager = {}
local contentmanager = {}

--- Returns the texture table with the given name. If not available yet, loads the file with the given name.
-- The texture table contains the fields id (internal use), width and height.
function contentmanager:gettexture(name)
	if self.textures[name] == nil then self.textures[name] = vegaloadtexture(name) end
	return self.textures[name]
end

--- Releases all current resources.
function contentmanager:releaseresources(name)
	vegareleasetextures()
	self.textures = {}
end

--- Creates a new instance of the table.
function ContentManager.new()
	return {
		textures = {},
		gettexture = contentmanager.gettexture,
		releaseresources = contentmanager.releaseresources,
	}
end

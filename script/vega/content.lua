require "vegatable"
require "capi"

local function createtexturestable()
	local textures = {}
	local texturesmetatable = {
		__index = function(t, index)
			local texture = vega.capi.loadtexture("content/textures/"..index..".png")
			rawset(t, index, texture)
			return texture
		end
	}
	return setmetatable(textures, texturesmetatable)
end

local function releaseresources(self)
	vega.capi.releasetextures()
	self.textures = createtexturestable()
end

--- Creates a content table. It is automatically called by the SDK when the context table is created.
-- You can access the content table using context.content.
-- @field textures table of textures. If a texture is not found, it will be searched in the content/textures
-- folder, using the index as filename (without extension, the SDK presumes the extension is .png). So, to
-- load the texture content/textures/myimage.png, you can call "context.content.textures.myimage". If the
-- texture file is inside a subfolder, like content/textures/myfolder/myimage.png, you can use
-- "context.content.textures['myfolder/myimage']".
-- @field releaseresources function to release the previous loaded data. The textures list is cleaned. It is
-- automatically called by the main loop when the module is changed.
function vega.content()
	return {
		textures = createtexturestable(),
		releaseresources = releaseresources
	}

end

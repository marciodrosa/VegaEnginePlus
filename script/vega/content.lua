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

local function createfontstable()
	local fonts = {}
	local fontsmetatable = {
		__index = function(t, index)
			local font = {
				texture = vega.capi.loadtexture("content/fonts/"..index..".png"),
				metrics = vega.capi.loadfontmetrics("content/fonts/"..index..".dat")
			}
			rawset(t, index, font)
			return font
		end
	}
	return setmetatable(fonts, fontsmetatable)
end

local function init(content)
	content.textures = createtexturestable()
	content.fonts = createfontstable()
end

local function releaseresources(self)
	vega.capi.releasetextures()
	init(self)
end

--- Creates a content table. It is automatically called by the SDK when the context table is created.
-- You can access the content table using context.content.
-- @field textures table of textures. If a texture is not found, it will be searched in the content/textures
-- folder, using the index as filename (without extension, the SDK presumes the extension is .png). So, to
-- load the texture content/textures/myimage.png, you can call "context.content.textures.myimage". If the
-- texture file is inside a subfolder, like content/textures/myfolder/myimage.png, you can use
-- "context.content.textures['myfolder/myimage']".
-- @field fonts table of fonts. See vega.drawables.text for more details about the font table. If a font is
-- not found, then the files will be searched in the content/fonts folder, using the index as base filename and
-- the extensions .png for the texture data and .dat for the metrics data. The metrics must be a binary file with
-- a list of bytes, where each byte is the metric for each character.
-- @field releaseresources function to release the previous loaded data. The textures list is cleaned. It is
-- automatically called by the main loop when the module is changed.
function vega.content()
	local content = {
		releaseresources = releaseresources
	}
	init(content)
	return content
end

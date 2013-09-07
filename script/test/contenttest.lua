local contenttest = {}

local content = {}

function contenttest.setup()
	content = vega.content()
end

function contenttest.test_should_load_texture_from_c_api()
	-- given:
	local texturereturnedbycapi = {}
	local texturenameloadedfromcapi = ""
	
	vega.capi = {
		loadtexture = function(texturename)
			texturenameloadedfromcapi = texturename
			return texturereturnedbycapi
		end
	}

	-- when:
	local texture = content.textures["some texture name"]
	
	-- then:
	assert_equal("content/textures/some texture name.png", texturenameloadedfromcapi, "Should pass the texture name to the c api.")
	assert_equal(texturereturnedbycapi, texture, "Should return the texture loaded by the c api.")
end

function contenttest.test_should_return_previous_loaded_texture()
	-- given:
	vega.capi = {
		loadtexture = function(texturename)
			return {}
		end
	}

	-- when:
	local texture = content.textures["some texture name"]
	local anothertexture = content.textures["another texture name"]
	local sametexture = content.textures["some texture name"]
	
	-- then:
	assert_equal(texture, sametexture, "When get a texture with the same name, should return the same texture previous loaded by the c api.")
	assert_not_equal(texture, anothertexture, "The second texture should not be the same object, it has another name so it should be loaded by the c api.")
end

function contenttest.test_should_call_c_api_to_release_textures()
	-- given:
	local textureswasreleasedbycapi = false
	
	vega.capi = {
		releasetextures = function()
			textureswasreleasedbycapi = true
		end
	}

	-- when:
	content:releaseresources()
	
	-- then:
	assert_true(textureswasreleasedbycapi, "Should call the c api to release the textures.")
end

function contenttest.test_should_clear_tables_after_release_resources()
	-- given:
	vega.capi = {
		loadtexture = function()
			return {}
		end,
		loadfontmetrics = function()
			return {}
		end,
		releasetextures = function()
		end
	}
	mytext = content.textures["some texture"]
	myfont = content.fonts["some font"]

	-- when:
	content:releaseresources()
	
	-- then:
	assert_nil(rawget(content.textures, "some texture"), "Should remove the previous loaded texture from the textures table.")
	assert_nil(rawget(content.fonts, "some font"), "Should remove the previous loaded texture from the textures table.")
end

function contenttest.test_should_load_texture_again_after_release_resources()
	-- given:
	vega.capi = {
		loadtexture = function(texturename)
			return {}
		end,
		releasetextures = function()
		end
	}
	
	local texture = content.textures["some texture name"]
	
	content:releaseresources()

	-- when:
	local reloadedtexture = content.textures["some texture name"]
	
	-- then:
	assert_not_equal(texture, reloadedtexture, "The second texture should not be the same texture previous loaded, because it should be reloaded after release the resources.")
end

function contenttest.test_should_iterate_by_loaded_textures()
	-- given:
	local texture1 = {}
	local texture2 = {}
	local texture3 = {}
	local texturestoload = {
		apple = texture1,
		cucumber = texture2,
		orange = texture3
	}

	vega.capi = {
		loadtexture = function(texturename)
			return texturestoload[texturename]
		end
	}
	
	local loadedapple = content.textures["apple"]
	local loadedcucumber = content.textures["cucumber"]
	local loadedorange = content.textures["orange"]

	-- when:
	local temp = {}
	for k, v in pairs(content.textures) do
		temp[k] = v
	end

	-- then:
	assert_equal(loadedapple, temp.apple, "Should return the apple texture when iterate by the textures.")
	assert_equal(loadedcucumber, temp.cucumber, "Should return the cucumber texture when iterate by the textures.")
	assert_equal(loadedorange, temp.orange, "Should return the orange texture when iterate by the textures.")
end

return contenttest

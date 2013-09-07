require "vegatable"
require "drawable"
require "util"

--- Returns true if the text has a valid font to be rendered.
local function hasvalidfont(textdrawable)
	return type(textdrawable.font) == "table" and type(textdrawable.font.texture) == "table" and type(textdrawable.font.texture.width) == "number" and type(textdrawable.font.texture.height) == "number"
end

--- Returns true if the text has valid data (including font) to be rendered.
local function hasvaliddata(textdrawable)
	return textdrawable:hasvalidfont(textdrawable) and type(textdrawable.content) == "string" and type(textdrawable.fontsize) == "number"
end

--- Returns the width for the drawable of the given character.
-- @param charcode the ascii number of the character
local function widthforascii(textdrawable, charcode)
	local areaheight = textdrawable.font.texture.height / 16
	local scale = textdrawable.fontsize / areaheight
	local metric
	if type(textdrawable.font.metrics) == "table" then
		metric = textdrawable.font.metrics[charcode]
	end
	if type(metric) ~= "number" then
		metric = textdrawable.font.texture.width / 16
	end
	return metric * scale
end

--- Internal function. Returns three values: the begining index of the next line, the text of the current
-- line and the needed width for the current line.
-- @param initialcharindex the initial index to process.
local function processline(textdrawable, initialcharindex)
	local nextlineindex = initialcharindex
	local lastcharindex = initialcharindex
	local x = 0
	local lastblankspaceindex = 0
	local maxlinewidth = nil
	if type(textdrawable.maxlinewidth) == "number" then
		maxlinewidth = textdrawable.maxlinewidth
	end
	for i = initialcharindex, textdrawable.content:len() do
		lastcharindex = i
		nextlineindex = i + 1
		local char = textdrawable.content:sub(i, i)
		local byte = char:byte(1)
		if byte <= 255 then
			if char == " " or char == "	" then
				lastblankspaceindex = i
			elseif char == "\n" then
				lastcharindex = lastcharindex - 1
				break
			end
			x = x + textdrawable:widthforascii(byte)
			if maxlinewidth ~= nil and x > maxlinewidth then  -- extrapolates the max width, go back to the last blank space, where a virtual new line will be inserted
				if lastblankspaceindex > 0 then
					for j = i, lastblankspaceindex, -1 do -- go back the parsed characters, decrementing the x variable:
						x = x - textdrawable:widthforascii(string.byte(textdrawable.content, j))
					end
					lastcharindex = lastblankspaceindex - 1
					nextlineindex = lastblankspaceindex + 1
				else -- if there is no blank space in the current line, then there is just one word that extrapolates the entire line; So, we need to cut the word in half.
					x = x - textdrawable:widthforascii(byte)
				end
				break
			end
		end
	end
	return nextlineindex, textdrawable.content:sub(initialcharindex, lastcharindex), x
end

local function getmaxlinewidth(lineswidth)
	local width = 0
	for i, v in ipairs(lineswidth) do
		if v > width then
			width = v
		end
	end
	return width
end

--- Returns the line position (a table with x and y fields). It uses the "align" field and the text drawable width
-- to calculate the x coordinate, and the font size and line number to calculate the y coordinate.
-- @param linenumber the line number (1 if first line, 2 if second line...)
-- @param linewidth the width of the line.
local function lineposition(textdrawable, linenumber, linewidth)
	local pos = {
		x = 0,
		y = textdrawable.fontsize * linenumber
	}
	if textdrawable.align == "left" then
		pos.x = 0
	elseif textdrawable.align == "center" then
		pos.x = (textdrawable.size.x - linewidth) / 2
	elseif textdrawable.align == "right" then
		pos.x = textdrawable.size.x - linewidth
	end
	return pos
end

local function createdrawableforcharacter(font, color, srcx, srcy, srcwidth, srcheight, x, y, width, height)
	return vega.drawable {
		texture = font.texture,
		color = color,
		position = { x = x, y = y },
		size = { x = width, y = width },
		lefttopuv = { x = srcx / font.texture.width, y = srcy / font.texture.height },
		rightbottomuv = { x = srcwidth / font.texture.width, y = srcheight / font.texture.height },
	}
end

local function refreshcharactersdrawables(textdrawable, lines, lineswidth)
	textdrawable.charactersdrawable.children = {}
	local srcareawidth = textdrawable.font.texture.width / 16
	local srcareaheight = textdrawable.font.texture.height / 16
	for i, line in ipairs(lines) do
		local posline = textdrawable:lineposition(i, lineswidth[i])
		local x = posline.x
		local y = posline.y
		for j = 1, line:len() do
			local byte = line:byte(j)
			if byte <= 255 then
				local charwidth = textdrawable:widthforascii(byte)
				local srcx = (byte % 16) * srcareawidth
				local srcy = (byte / 16) * srcareaheight
				local srcwidth = charwidth
				local srcheight = srcareaheight
				textdrawable.charactersdrawable.children.insert(createdrawableforcharacter(textdrawable.font, textdrawable.fontcolor, srcx, srcy, srcwidth, srcheight, x, y, charwidth, textdrawable.fontsize))
				x = x + charwidth
			end
		end
	end
end

local function refresh(textdrawable)
	if textdrawable:hasvaliddata() then
		local formattedcontent = ""
		local height = 0
		local lineswidth = {}
		local lines = {}
		local i = 1
		while true do
			height = height + textdrawable.fontsize
			local line
			local linewidth
			i, line, linewidth = textdrawable:processline(i)
			table.insert(lines, line)
			table.insert(lineswidth, linewidth)
			formattedcontent = formattedcontent..line
			if i > textdrawable.content:len() then
				break
			end
		end
		textdrawable.size = { x = getmaxlinewidth(lineswidth), y = height }
		refreshcharactersdrawables(textdrawable, lines, lineswidth)
	end
end

--- Creates a text drawable. This drawable has one child. This child has a collection of children, each child
-- is a character of the text. When the text is refreshed (some field is changed by the user), these children
-- are removed and recreated. This drawable size is automatically calculated to fit the space needed for the text.
-- @field content string to be rendered.
-- @field font the font to be used. Create a font using vega.font() function.
-- @field fontsize the height of each character. Default is 1.
-- @field align string to set the alignment of the lines of the text. Can be "left", "right" or "center".
-- @field fontcolor the tint color of the font.
-- @field maxlinewidth if not nil, the text is wrapped to fit the max line width.
-- @field charactersdrawable the drawable that contains each character as a child. It is also a child of the text drawable.
function vega.drawables.text(initialvalues)
	local charactersdrawable = vega.drawable()
	local text = vega.drawable {
		fontsize = 1,
		charactersdrawable = charactersdrawable,
		children = {
			charactersdrawable
		},
		refresh = refresh,
		hasvalidfont = hasvalidfont,
		hasvaliddata = hasvaliddata,
		widthforascii = widthforascii,
		processline = processline,
		lineposition = lineposition,
	}
	local textmetatable = {}
	local private = {}

	textmetatable.__index = private

	function textmetatable.__newindex(t, index, value)
		if index == "fontsize" or index == "maxlinewidth" or index == "align" or index == "content" or index == "font" or index == "fontcolor" then
			private[index] = value
			t:refresh()
		else
			rawset(t, index, value)
		end
	end

	function textmetatable.__pairs(t)
		return vega.util.pairswithprivatetable(t, private)
	end

	setmetatable(text, textmetatable)

	return vega.util.copyvaluesintotable(initialvalues, text)
end

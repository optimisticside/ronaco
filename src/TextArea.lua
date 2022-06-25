--[[
	The actual textbox that stores the content being edited.
]]

local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)
local types = require(Package.types)

local Computed = Fusion.Computed
local Children = Fusion.Children
local Event = Fusion.Event
local New = Fusion.New

type TextAreaProperties = {
	Content: Fusion.Value<string>,
	GutterSize: number,
	Theme: Fusion.Value<types.Theme>,
}

return function(props: TextAreaProperties): Frame
	local canvasSize = Computed(function()
		local content = props.Content:get()
		local sizeX = 0

		-- TODO: Is this inneficient, since the highlighter is alraedy going
		-- through all the lines?
		local lines = string.split(content, "\n")
		for _, line in ipairs(lines) do
			sizeX = math.max(sizeX, #line)
		end

		return UDim2.new(0, sizeX, 0, #lines)
	end)

	return New "ScrollingFrame" {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, props.GutterSize, 0, 0),
		ScrollBarThickness = 0,
		Size = UDim2.new(1, -props.GutterSize, 1, 0),
		CanvasSize = canvasSize,
	},
end
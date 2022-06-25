--[[
	Displays line numbers that correspond to lines of the text being
	edited.
]]

local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)
local types = require(Package.types)

local Computed = Fusion.Computed
local Children = Fusion.Children
local Event = Fusion.Event
local New = Fusion.New

type GutterProperties = {
	CanvasSize: Fusion.Value<Vector2>,
	CharSize: Vector2,
	Content: Fusion.Value<string>,
	Font: Enum.Font,
	GutterSize: number,
	TextSize: number,
	Theme: Fusion.Value<types.Theme>,
}

return function(props: GutterProperties): Frame
	local size = Computed(function()
		local canvasSize = props.CanvasSize:get()
		return UDim2.new(0, props.GutterSize, canvasSize.Y, 0)
	end)

	local children = Computed(function()
		local content = props.Content:get()

		local _, lineCount = content:gsub("\n", "\n")
		local labels = {}

		for lineNumber = 1, lineCount do
			table.insert(labels, New "Frame" {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Font = props.Font,
				Position = UDim2.new(0, 0, 0, (lineNumber - 1) * props.CharSize.Y),
				Size = UDim2.new(0, props.CharSize.X * 5, 0, props.CharSize.Y),
				Text = lineNumber,
				TextColor3 = Theme.Number(props.Theme),
				TextSize = props.TextSize,
				TextXAlignment = Enum.TextXAlignment.Right,
			})
		end

		return labels
	end)

	return New "Frame" {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = size,

		[Children] = children,
	}
end
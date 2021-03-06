--[[
	Used to highlight the locations of all occurances of the word being that 
	is selected, on the scroll bar.
]]

local COLOR_SHIFT = 76/255

local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)

local ComputedPairs = Fusion.ComputedPairs
local Computed = Fusion.Computed
local New = Fusion.New

type MarkersProperties = {
	CanvasSize: Fusion.Value<UDim2>,
	CharSize: Vector2,
	MarkerLocations: Fusion.Value<types.Array<types.Selection>>,
	Text: Fusion.Value<string>,
	Theme: Fusion.Value<types.Theme>,
}

return function(props: MarkersProperties): Fusion.Computed<types.Array<Frame>>
	local backgroundColor = Theme.Background(props.Theme)
	local textColor = Theme.Text(props.Theme)

	local color = Computed(function()
		return backgroundColor:get():Lerp(textColor:get(), COLOR_SHIFT)
	end)

	return ComputedPairs(props.MarkerLocations, function(line)
		return New "Frame" {
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 4, 0, 6),
			Position = UDim2.new(0, 0, (line.Y * props.CharSize.Y) / props.CanvasSize.Y.Offset, 0)
		}
	end)
end
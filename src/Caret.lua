--[[
	Displays the position of the cursor in the text being edited.
]]

local TWEEN_INFO = TweenInfo.new(0.25)

local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)
local types = require(Package.types)

local Computed = Fusion.Computed
local Value = Fusion.Value
local Tween = Fusion.Tween
local New = Fusion.New

type CaretProperties = {
	Theme: Fusion.Value<types.Theme>,
	CaretPosition: Fusion.Value<number>,
	CharSize: Vector2;
}

return function(props: CaretProperties): Frame
	local position = Computed(function()
		local caretPos = props.CaretPosition:get()
		return UDim2.new(0, caretPos.X * props.CharSize.X, 0, caretPos.Y * props.CharSize.Y)
	end)

	return New "Frame" {
		BackgroundColor3 = Theme.Text(props.Theme),
		BorderSizePixel = 0,
		Position = Tween(position, TWEEN_INFO),
		Size = UDim2.new(0, 2, 0, props.CharSize.X),
		ZIndex = 100,
	}
end
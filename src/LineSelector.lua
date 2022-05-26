--[[
	Highlights the line that a cursor is on.
]]

--[[
	Highlights the line that the caret is currently on.
]]

local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)

local Computed = Fusion.Computed
local New = Fusion.New

type LineSelectorProps = {
	CaretPlace: Fusion.Value<Vector2>,
	CharHeight: number,
	Focused: Fusion.Value<boolean>,
	Theme: Fusion.Value<Theme.EditorTheme>,
}

return function(props: LineSelectorProps): Frame
	local position = Computed(function()
		local caretPlace = props.CaretPlace:get()
		return UDim2.new(0, 2, 0, props.CharHeight * caretPlace.Y + 2)
	end)

	return New "Frame" {
		BackgroundColor3 = Theme.Background(props.Theme),
		BorderColor3 = Theme.LineSelection(props.Theme),
		BorderSizePixel = 2,
		Position = position,
		Size = UDim2.new(1, -4, 0, props.CharHeight - 4),
		Visible = props.Focused,
	}
end
--[[
	Custom scroll-bar implementation that allows for scrolling while the
	TextBox is focused.
]]

local DEFAULT_TRANSPARENCY = 1 - 62/255
local ACTIVE_TRANSPARENCY = 1 - 153/255

local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)
local types = require(Package.types)

local Computed = Fusion.Computed
local Children = Fusion.Children
local Event = Fusion.Event
local New = Fusion.New

type ScrollerProperties = {
	AbsoluteSize: Fusion.Value<number>,
	CanvasSize: Fusion.Value<number>,
	CanvasPosition: Fusion.Value<number>,
	IsVertical: boolean,
	IsScrolling: Fusion.Value<boolean>,
	Theme: Fusion.Value<types.Theme>,
	Thickness: number,
}

return function(props: ScrollerProperties): Frame
	local barPosition = Computed(function()
		local absoluteSize = props.AbsoluteSize:get()
		local canvasPos = props.CanvasPosition:get()
		local canvasSize = props.CanvasSize:get()

		local max = math.max(canvasSize - absoluteSize, 0)
		local position = max and canvasPos / max or 0

		return props.IsVertical and UDim2.new(0, 0, 0, position) or UDim2.new(0, position, 0, 0)
	end)

	local visible = Computed(function()
		local max = math.max(props.CanvasSize:get() - props.AbsoluteSize:get(), 0)
		return max ~= 0
	end)

	local barSize = Computed(function()
		local size = props.AbsoluteSize:get() / props.CanvasSize:get()
		return props.IsVertical and UDim2.new(0, 0, 0, size) or UDim2.new(0, size, 0, 0)
	end)

	local transparency = Computed(function()
		local isScrolling = props.IsScrolling:get()
		return isScrolling and ACTIVE_TRANSPARENCY or DEFAULT_TRANSPARENCY
	end)

	-- TODO: Finish working on these.
	local function scrollerActivated()
		props.IsScrolling:set(true)
	end

	local function scrollBarActivated()
		props.IsScrolling:set(true)
	end

	return New "TextButton" {
		Position = props.IsVertical and UDim2.new(1, -props.Thickness, 0, 0) or UDim2.new(0, 0, 1, -props.Thickness),
		Size = props.IsVertical and UDim2.new(0, 0, 1, 0) or UDim2.new(0, 1, 0, 0),

		[Event "MouseButton1Down"] = scrollerActivated,
		[Children] = New "TextButton" {
			AutoButtonColor = false,
			BackgroundColor3 = Theme.Text(props.Theme),
			BackgroundTransparency = transparency,
			Position = barPosition,
			Size = barSize,
			Text = "",
			Visible = visible,
			ZIndex = 3,

			[Event "MouseButton1Down"] = scrollBarActivated,
		}
	}
end
--[[
	Implementation of Microsoft's Monaco Editor on Roblox.
]]

local TEST_CHARACTER = "m"

local TextService = game:GetService("TextService")
local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)
local types = require(Package.types)

local TextArea = require(Package.TextArea)
local Gutter = require(Package.Gutter)

local Children = Fusion.Children
local Value = Fusion.Value
local New = Fusion.New

type EditorProperties = {
	CaretBlinkRate: number?,
	CaretFocusedOpacity: number?,
	CaretUnfocusedOpacity: number?,
	Font: Enum.Font,
	TextSize: number?,
	Theme: Fusion.Value<types.Theme>?,
}

return function(props: EditorProperties)
	local content = Value()

	local charSize = TextService:GetTextSize(TEST_CHARACTER, props.TextSize, props.Font, Vector2.new(1000, 1000))
	local gutterSize = charSize * 5 + 12
	
	return New "Frame" {
		BackgroundTransparency = Theme.Background(props.Theme),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Size = UDim2.new(1, 0, 1, 0),

		[Children] = {
			TextArea = TextArea {
				Content = content,
				
			},

			Gutter = Gutter {
				CharSize = charSize,
				GutterSize = charSize.X * 5 + 12,
			}
		}
	}	
end
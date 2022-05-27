--[[
	Lexes the content of the text and places TextLabls over the TextBox in
	to make it look like the text is being highlighted.
]]

local Package = script.Parent

local Fusion = require(Package.Fusion)
local Theme = require(Package.Theme)
local Lexer = require(Package.Lexer)
local types = require(Package.types)

local ComputedPairs = Fusion.ComputedPairs
local Computed = Fusion.Computed
local New = Fusion.New

type HighlighterProperties = {
	Content: Fusion.Value<string>,
	CaretPosition: Fusion.Value<number>,
	CharSize: Vector2,
	Font: Enum.Font,
	SelectedWord: Fusion.Computed<string>,
	TextSize: number,
	Theme: Fusion.Value<types.Theme>,
}

return function(props: HighlighterProperties): Frame
	local tokens = Computed(function()
		-- TODO: Check the last lex and only update the tokens that were
		-- changed, so we don't waste our time.
		local content = props.Content:get()
		local currentPosX = 0
		local currentPosY = 0
		local tokens = {}

		for token, source in Lexer.scan(content) do
			local lines = string.split(source, "\n")

			for count, line in ipairs(lines) do
				-- Only update position when going past new line because the
				-- token may not start at the start of the line.
				if count > 1 then
					currentPosY = currentPosY + 1
					currentPosX = 0
				end

				-- Tokens do not need to include the final position since it
				-- can be calculated from the start position and the number
				-- of characters.
				table.insert(tokens, {
					Position = Vector2.new(currentPosX, currentPosX),
					Text = line,
					Token = token,
				})
				currentPosX = currentPosX + #line
			end
		end

		return tokens
	end)

	return ComputedPairs(tokens, function(token: types.Token)
		local backgroundTransparency = Computed(function()
			return props.SelectedWord:get() == token.Text
		end)

		return New "TextLabel" {
			BackgroundColor3 = Theme.SelectionGentle(props.Theme),
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0,
			Font = props.Font,
			Size = UDim2.new(0, token.Position.X * props.CharSize.X, 0, token.Position.Y * props.CharSize.Y),
			Text = token.Text,
			TextColor3 = Theme.Text(props.Theme),
			TextSize = props.TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
		}
	end)
end
--[[
	Lexes the content of the text and places TextLabls over the TextBox in
	to make it look like the text is being highlighted.
]]

local WORD_MATCH = "[A-Za-z0-9_]"

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
	Selection: Fusion.Value<string>,
	TextSize: number,
	Theme: Fusion.Value<types.Theme>,
}

return function(props: HighlighterProperties): Frame
	local selectedWord = Computed(function()
		local content = props.Content:get()
		local caretPos = props.CaretPosition:get()

		local leftBound = math.max(caretPos - 1, 0)
		local rightBound = math.min(caretPos + 1, #content)

		-- Keep extending bounds left and right, character-by-character, as
		-- long as the new character matches `WORD_MATCH`.
		while leftBound > 0 and content:sub(leftBound + 1, leftBound + 1):match(WORD_MATCH) do
			leftBound = leftBound - 1
		end
		while leftBound < #content and content:sub(rightBound, rightBound):match(WORD_MATCH) do
			rightBound = rightBound + 1
		end

		-- Push back our boundaries by 1 character if they do not match
		-- `WORD_MATCH`
		if not content:sub(leftBound + 1, leftBound + 1) then
			leftBound = leftBound + 1
		end
		if not content:sub(rightBound, rightBound) then
			rightBound = rightBound - 1
		end

		return content:sub(leftBound + 1, rightBound)
	end)

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
				if not line:match("^%s+$") then
					continue
				end

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
			return if selectedWord:get() == token.Text then 0 else 0
		end)

		return New "TextLabel" {
			BackgroundColor3 = Theme.SelectionGentle(props.Theme),
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0,
			Font = props.Font,
			Size = UDim2.new(0, token.Position.X * props.CharSize.X, 0, token.Position.Y * props.CharSize.Y),
			Text = token.Text,
			TextColor3 = Theme[token.Token](props.Theme),
			TextSize = props.TextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
		}
	end)
end
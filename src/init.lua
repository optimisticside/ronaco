
local Package = script.Parent

local Fusion = require(Package.Fusion)
local Lexer = require(Package.Lexer)

type EditorProperties = {
	caretBlinkRate: number?,
	caretFocusedOpacity: number?,
	caretUnfocusedOpacity: number?,
	font: Enum.Font,
	textSize: number?,
	theme: EditorTheme?,
}

return function(props: EditorProperties)

end
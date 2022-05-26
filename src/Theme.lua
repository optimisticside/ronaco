local Package = script.Parent
local Fusion = require(Package.Fusion)

local Computed = Fusion.Computed

export type EditorTheme = {
	Background: Color3,

	Builtin: Color3,
	Comment: Color3,
	Keyword: Color3,
	Number: Color3,
	Operator: Color3,
	String: Color3,
	Text: Color3,

	LineSelection: Color3,
	SelectionBackground: Color3,
	SelectionColor: Color3,
	SelectionGentle: Color3,
}

local function ComputedElement(name: string)
	return function(theme: Fusion.Value<EditorTheme>)
		return Computed(function()
			return theme:get()[name]
		end)
	end
end

return {
	Background = ComputedElement("Background"),

	Builtin = ComputedElement("Builtin"),
	Comment = ComputedElement("Comment"),
	Keyword = ComputedElement("Keyword"),
	Number = ComputedElement("Number"),
	Operator = ComputedElement("Operator"),
	String = ComputedElement("String"),
	Text = ComputedElement("Text"),

	LineSelection = ComputedElement("LineSelection"),
	SelectionBackground = ComputedElement("SelectionBackground"),
	SelectionColor = ComputedElement("SelectionColor"),
	SelectionGentle = ComputedElement("SelectionGentle"),
}
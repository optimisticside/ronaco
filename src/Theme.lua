local Package = script.Parent

local Fusion = require(Package.Fusion)
local types = require(Package.types)

local Computed = Fusion.Computed

local function ComputedElement(name: string)
	return function(theme: Fusion.Value<types.Theme>)
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
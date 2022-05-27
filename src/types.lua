--[[
	Miscellaneous collection of types.
]]

export type Array<T> = { [number]: T }
export type Dictionary<T> = { [string]: T }
export type Map<K, V> = { [K]: V }

export type Theme = {
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

export type LexerToken = "iden" | "keyword" | "builtin" | "string" | "number" | "operator"
export type Token = {
	Position: Vector2,
	Text: string,
	Token: LexerToken,
}
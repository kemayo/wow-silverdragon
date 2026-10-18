local _, ns = ...

-- Translations. Keys are the English strings. Only the client's own locale is
-- kept. Until a translation is added, ns.translate stays unset, so English
-- clients skip the lookup in render_string altogether.

local strings = {}
ns.missing_translations = {}

local function translate(key)
	local translation = strings[key]
	if not translation and ns.DEBUG then
		ns.missing_translations[key] = true
	end
	return translation
end

-- Locale files should also return early when GetLocale() doesn't match, so the
-- tables they hold are never built.
function ns.AddTranslations(locale, translations)
	if locale ~= GetLocale() then return end
	for key, translation in pairs(translations) do
		-- unfinished entries are blank, or true to mean "same as the key"
		if type(translation) == "string" and translation ~= "" then
			strings[key] = translation
			ns.translate = translate
		end
	end
end

-- For text written in code. Format after translating: L["Hide %s"]:format(name)
ns.L = setmetatable({}, {__index = function(_, key) return translate(key) or key end})

local myname, ns = ...

local Base = {
	__classname = "Object",
	Initialize = function() end,
	__get = {},
	super = function(self, method, ...)
		-- print("super for", self, method)
		if not self.__parent then return nil end
		local cls = self.__class
		local superself = self
		local parent = self.__parent
		while superself[method] == parent[method] do
			superself = parent
			parent = parent.__parent
		end
		local supersuper = parent.__parent
		if supersuper then
			-- print("overriding parent", supersuper)
			cls.__parent = supersuper
		end
		-- print("calling", parent, method)
		local a,b,c,d,e,f,g,h,i = parent[method](self, ...)
		if supersuper then
			-- print("restored parent", parent)
			cls.__parent = parent
		end
		return a,b,c,d,e,f,g,h,i
	end,
	isA = function(self, kind)
		if not kind then
			return self.__class
		end
		local class = self.__class
		repeat
			if kind == class then return true end
			class = class.__parent
		until not class
		return false
	end,
}
ns.Class = function(def)
	local class = def or {}
	class.__classname = class.__classname or tostring(def):gsub("table: ", "")
	local class_meta = {
		__index = function(self, index)
			local class_walked = class
			repeat
				local val = rawget(class_walked, index)
				if val ~= nil then return val end
				if class_walked.__get[index] then return class_walked.__get[index](self) end
				class_walked = class_walked.__parent
			until class_walked == nil
		end,
		__tostring = function(self) return tostring(self.__class) .. "<" .. self.__instanceid .. ">" end,
	}
	setmetatable(class, {
		__call = function(_, ...)
			local self = {}
			self.__instanceid = tostring(self):gsub("table: ", "")
			setmetatable(self, class_meta)
			self:Initialize(...)
			return self
		end,
		-- inheritance, this is it:
		__index = def.__parent,
		__tostring = function(cls)
			return cls.__parent and (tostring(cls.__parent) .. "." .. cls.__classname) or cls.__classname
		end,
	})
	-- avoid needing to care about rawget later:
	class.__class = class
	class.Initialize = class.Initialize or Base.Initialize
	class.super = Base.super
	class.isA = Base.isA
	class.__get = class.__get or Base.__get

	return class
end

ns.IsObject = function(tbl)
	return type(tbl) == "table" and tbl.__class and true
end

local myname, ns = ...

-- THIS IS A MODIFIED (NOT THE ORIGINAL) VERSION OF THIS SOFTWARE.
-- It's the version from https://lol.fandom.com/wiki/Module:LuaClassSystem,
-- which has then been adjusted a bit further.

-- Copyright (c) 2012-2014 Roland Yonaba
--[[
This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

	1. The origin of this software must not be misrepresented; you must not
	claim that you wrote the original software. If you use this software
	in a product, an acknowledgment in the product documentation would be
	appreciated but is not required.

	2. Altered source versions must be plainly marked as such, and must not be
	misrepresented as being the original software.

	3. This notice may not be removed or altered from any source
	distribution.
--]]

local pairs, ipairs = pairs, ipairs
local assert = assert
local setmetatable, getmetatable = setmetatable, getmetatable
local type = type
local insert = table.insert

-- Internal register
local _registry = {
	class  = setmetatable({}, {__mode = 'k'}),
	object = setmetatable({}, {__mode = 'k'})
}

-- Checks if thing is a kind or whether an 'object' or 'class'
local function isObject(thing)
	return _registry.object[thing] ~= nil
end

local function isClass(thing)
	return _registry.class[thing] ~= nil
end

-- Given an object and a class, checks whether the object is an instance of the
-- class or one of its superclasses.
local function instanceOf(thing, class)
	assert(isObject(thing), 'instanceof: `thing` must be a LCS object')
	assert(isClass(class), 'instanceof: `class` must be a LCS class')

	local thingClass = _registry.object[thing].__superClass
	if class == thingClass then
		return true
	end

	local thingSuperClass = _registry.class[thingClass].__superClass
	while thingSuperClass do
		if class == thingSuperClass then
			return true
		else
			thingSuperClass = _registry.class[thingSuperClass].__superClass
		end
	end

	-- loop terminated = reached a base class and still haven't found one `thing` is an instance of
	return false
end

-- tostring
local function __tostring(self, ...)
	if self.describe then
		return self:describe(...)
	end

	if isClass(self) then
		local clsname = self.classname or _registry.class[self].__addr
		return _registry.class[self].__superClass and
			(tostring(_registry.class[self].__superClass) .. "." .. clsname) or
			clsname
	elseif isObject(self) then
		return ("%s<%s>"):format(tostring(_registry.object[self].__superClass), _registry.object[self].__addr)
	end

	return tostring(self)
end

-- Base metatable
local baseClassMt = {
	__call = function (self, ...) return self:new(...) end,
	__tostring = __tostring
}

local Class

-- Simple helper for building a raw copy of a table
-- Only pointers to classes or objects stored as instances are preserved
local function deepCopy(t)
	local r = {}
	for k, v in pairs(t) do
		if type(v) == 'table' then
			if (_registry.class[v] or _registry.object[v]) then
				r[k] = v
			else
				r[k] = deepCopy(v)
			end
		else
			r[k] = v
		end
	end

	return r
end

-- Checks for a method in a list of attributes
local function checkForMethod(list)
	for k, attr in pairs(list) do
		assert(type(attr) ~= 'function', 'Cannot assign functions as members')
	end
end

-- Instantiation
local function instantiateFromClass(self, ...)
	assert(isClass(self), 'Class constructor must be called from a class')
	assert(not _registry.class[self].__abstract, 'Cannot instantiate from abstract class')
	local instance = deepCopy(self)
	_registry.object[instance] = {
		__superClass = self,
		__addr = tostring(instance):gsub("table: ", ""),
	}

	instance = setmetatable(instance, self)
	if self.init then
		self.init(instance, ...)
	end

	return instance
end

-- Classes may not override these metavalues.
local restrictedMetavalues = { __index = true, __call = true }

-- Class derivation
local function extendsFromClass(self, extra_params)
	assert(isClass(self), 'Inheritance must be called from a class')
	assert(not _registry.class[self].__final, 'Cannot derive from a final class')
	local class = Class(extra_params)
	class.__index = class
	class.__tostring = __tostring
	_registry.class[class].__superClass = self
	_registry.class[self].__subClass[class] = true

	for k, v in pairs(self) do
		if type(k) == 'string' and k:find("^__") and not restrictedMetavalues[k] then
			class[k] = v
		end
	end

	return setmetatable(class, self)
end

-- Abstract class derivation
local function abstractExtendsFromClass(self, extra_params)
	local c = self:extends(extra_params)
	_registry.class[c].__abstract = true
	return c
end

-- Final class derivation
local function finalExtendsFromClass(self, extra_params)
	local c = self:extends(extra_params)
	_registry.class[c].__final = true
	return c
end

-- Super methods call
local function callFromSuperClass(self, f, ...)
	assert(isClass(self) or isObject(self), 'attempted to call :super from an unknown object/class')
	local superClass = getmetatable(self)
	if not superClass then return nil end

	local super
	if isClass(self) then
		super = superClass
	else -- must be an object due to the assert above
		assert(isClass(superClass), 'attempted to call :super with an object that has an unknown class')
		super = _registry.class[superClass].__superClass
	end

	local s = self
	while s[f] == super[f] do
		s = super
		super = _registry.class[super].__superClass
	end

	-- If the superclass also has a superclass, temporarily set :super to call THAT superclass' methods
	local supersSuper = _registry.class[super].__superClass
	if supersSuper then
		_registry.class[superClass].__superClass = supersSuper
	end

	local method = super[f]
	local result = method(self, ...)

	-- And set the superclass back, if necessary
	if supersSuper then
		_registry.class[superClass].__superClass = super
	end
	return result
end

-- Gets the superclass
local function getSuperClass(self)
	local super = getmetatable(self)
	return (super ~= baseClassMt and super or nil)
end

-- Gets the subclasses
local function getSubClasses(self)
	assert(isClass(self), 'getSubClasses() must be called from class')
	return _registry.class[self].__subClass or {}
end

-- Class creation
Class = function(members)
	if members then checkForMethod(members) end
	local newClass = members and deepCopy(members) or {}                              -- includes class variables
	newClass.__index = newClass                                                        -- prepares class for inheritance
	_registry.class[newClass] = {                                                      -- builds information for internal handling
		__abstract = false,
		__final = false,
		__superClass = false,
		-- Superclasses have no logical dependency on their subclasses.
		__subClass = setmetatable({}, {__mode = 'k'}),
		__addr = tostring(newClass):gsub("table: ", ""),
	}

	newClass.new = instantiateFromClass                                                -- class instanciation
	newClass.extends = extendsFromClass                                                -- class derivation
	newClass.abstractExtends = abstractExtendsFromClass                                -- abstract class deriviation
	newClass.finalExtends = finalExtendsFromClass                                      -- final class deriviation
	newClass.__call = baseClassMt.__call                                               -- shortcut for instantiation with class() call
	newClass.super = callFromSuperClass                                                -- super method calls handling
	newClass.getClass = getSuperClass                                                  -- gets the superclass
	newClass.getSubClasses = getSubClasses                                             -- gets the subclasses
	newClass.__tostring = __tostring                                                   -- tostring

	return setmetatable(newClass, baseClassMt)
end

-- Static classes
local function abstractClass(members)
	local class = Class(members)
	_registry.class[class].__abstract = true
	return class
end

-- Final classes
local function finalClass(members)
	local class = Class(members)
	_registry.class[class].__final = true
	return class
end


-- Stands for "e*x*tended type". Like the built-in `type`, returns a string for
-- the type of the given object. If the value `which` is a known object or a
-- class, returns 'object' or 'class' respectively, otherwise defers to `type`.
local function xtype(which)
	if isObject(which) then
		return 'object'
	elseif isClass(which) then
		return 'class'
	else
		return type(which)
	end
end

ns.Class = setmetatable(
	{
		abstract = abstractClass,
		final = finalClass
	},
	{
		__call = function(self, ...) return Class(...) end
	}
)
ns.IsClass = isClass
ns.IsObject = isObject
ns.IsA = instanceOf
ns.xtype = xtype

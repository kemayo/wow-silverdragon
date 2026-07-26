local myname, ns = ...

-- Turns the loot lists in the data files into Reward objects, folding the
-- shorthand keys (class, covenant, expansion, requires) into one condition.

do
	local available = {}
	local function upgradelootitem(item)
		if ns.IsObject(item) then
			return item
		end
		if type(item) == "number" then
			return ns.rewards.Item(item)
		end
		local upgrade
		if item.toy then
			upgrade = ns.rewards.Toy(item[1])
		elseif item.mount then
			upgrade = ns.rewards.Mount(item[1], type(item.mount) == "number" and item.mount)
		elseif item.pet then
			upgrade = ns.rewards.Pet(item[1], type(item.pet) == "number" and item.pet)
		elseif item.set then
			upgrade = ns.rewards.Set(item[1], item.set)
		elseif item.decor then
			upgrade = ns.rewards.Decor(item[1])
		else
			upgrade = ns.rewards.Item(item[1])
		end
		upgrade.quest = item.quest
		upgrade.questComplete = item.questComplete
		upgrade.warband = item.warband
		upgrade.spell = item.spell
		upgrade.note = item.note
		if item.class then
			upgrade.class = item.class -- kept for SilverDragon's loot popup icons
			table.insert(available, ns.conditions.Class(item.class))
		end
		if item.covenant then
			upgrade.covenant = item.covenant -- ditto
			table.insert(available, ns.conditions.Covenant(item.covenant))
		end
		if item.expansion then
			table.insert(available, ns.conditions.Expansion(item.expansion))
		end
		if item.requires then
			if ns.IsObject(item.requires) then
				table.insert(available, item.requires)
			elseif item.requires.any and #item.requires > 1 then
				-- everything in `available` gets ANDed together, so an or-group
				-- has to go in as one nested condition to keep its meaning
				table.insert(available, ns.conditions.Any(unpack(item.requires)))
			else
				-- a plain list, an all-group, or a single member: all just ANDed
				for _, v in ipairs(item.requires) do
					table.insert(available, v)
				end
			end
		end
		if #available > 0 then
			upgrade.requires = available
			available = {}
		end
		return upgrade
	end
	function ns.upgradeloot(loot)
		if not loot then return loot end
		for i, item in ipairs(loot) do
			loot[i] = upgradelootitem(item)
		end
		return loot
	end
end

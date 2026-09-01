local myname, ns = ...

if LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_WARLORDS_OF_DRAENOR or math.huge) then
	ns.BeginDataModule(nil)
	return
end

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

ns.BeginDataModule("Warlords")

ns.follower = ns.nodeMaker{
	atlas="GreenCross", scale=1.5,
}

core:RegisterMobData("Warlords", {
	[78128] = {name="Gronnstalker Dawarn",locations={[525]={57403740},},quest=34130,hidden=true,},
	[78134] = {name="Pathfinder Jalog",locations={[525]={57403740},},quest=34130,hidden=true,},
	[78144] = {name="Giantslayer Kimla",locations={[525]={57403740},},quest=34130,hidden=true,},
	[78150] = {name="Beastcarver Saramor",locations={[525]={57403740},},quest=34130,hidden=true,},
	[87493] = {name="Rukhmar",boss=true,locations={[542]={36013901},},loot={{116771,mount=634,}},notes="Weekly; flies",quest=37464,tameable=true,hidden=true,},
	[87641] = {name="Xelganak",locations={[550]={50204120},},hidden=true,},
	[87647] = {name="Aogexon",locations={[550]={50204120},},hidden=true,},
	[87650] = {name="Direhoof",locations={[550]={50204120},},hidden=true,},
	[87653] = {name="Vileclaw",locations={[550]={50204120},},hidden=true,},
	[87655] = {name="Thek'talon",locations={[550]={50204120},},hidden=true,},
	[87659] = {name="Gagrog the Brutal",locations={[550]={50204120},},hidden=true,},
	[87660] = {name="Dekorhan",locations={[550]={50204120},},tameable=132254,hidden=true,},
	[87661] = {name="Bergruu",locations={[550]={50204120},},hidden=true,},
	[87666] = {name="Mu'gra",locations={[550]={34005100},},loot={118659},quest=37224,tameable=1044490,},
	[87667] = {name="Mu'gra",locations={[550]={50204120},},hidden=true,},
	[88072] = {name="Archmagus Tekar",locations={[535]={43602660,45003260},},quest=37337,hidden=true,},
	[88083] = {name="Soulbinder Naylana",locations={[535]={43402660,45403200},},quest=37337,hidden=true,},
}, true)

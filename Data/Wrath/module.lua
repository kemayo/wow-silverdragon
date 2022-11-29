-- this is where mainline/classic converge on zone ids, so we need less splitting
if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then return end -- classic misses expansion variables
if LE_EXPANSION_LEVEL_CURRENT < (LE_EXPANSION_WRATH_OF_THE_LICH_KING or math.huge) then return end

-- DO NOT EDIT THIS FILE; run dataminer.lua to regenerate.
local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")

core:RegisterMobData("Wrath", {
	[32357] = {name="Old Crystalbark",locations={[114]={21002840,34002420},},loot={44649},
		routes={[114]={{21002840,22003340,27003560,35402940,34002420},},},
	},
	[32358] = {name="Fumblub Gearwind",locations={[114]={62603480},},loot={44666},
		routes={[114]={{62603480,59802540,59801460,68001920,73603260,68403660,loop=true,},},},
	},
	[32361] = {name="Icehorn",locations={[114]={80404600,81203160,88203960,},},loot={44667},tameable=1044794,
		routes={[114]={{81203160,91403240},{80404600,84104570}},},
	},
	[32377] = {name="Perobas the Bloodthirster",locations={[117]={49800460,52801160,60802000,68201720},},loot={44669},},
	[32386] = {name="Vigdis the War Maiden",locations={[117]={68604840,69405820,73403980,74004500,74005240,74406060},},loot={44670},},
	[32398] = {name="King Ping",locations={[117]={26006380,30807120,31205660,33208020},},loot={44668},},
	[32400] = {name="Tukemuth",locations={[115]={68805780,53505920,59502740},},loot={44673},
		routes={[115]={
			{68805780,70005140,68004600,66803280,69602910,70903280,64103610,61304270,63105250,59806190,56505230,58304230,61304270},
			{53505920,56505230,58304230,60303330,59502740},
		},},
	},
	[32409] = {name="Crazed Indu'le Survivor",locations={[115]={15604560,16405820,20605520,23605310,26705860,28406140,30805860,33205580},},loot={44672},
		routes={[115]={{16405820,20605520,23605310,26705860,28406140,30805860,33205580}},},
	},
	[32417] = {name="Scarlet Highlord Daion",locations={[115]={69207480,72702590,85803660},},loot={44671},},
	[32422] = {name="Grocklar",locations={[116]={10603920,12005560,11207100,22405590,28004180},},loot={44675},
		routes={[116]={{10603920,12204440,12805000,12005560},{11207100,17207040,22407320}},},
	},
	[32429] = {name="Seething Hate",locations={[116]={28004540,34004920,39605060},},loot={44674},},
	[32435] = {name="Vern",locations={[126]={51203140,57003080},},hidden=true,},
	[32438] = {name="Syreian the Bonecarver",locations={[116]={61503600,67802680,66404120,74204240},},loot={44676},
		routes={[116]={{74204240,71603500,67802680,65903130,65103510,66404120},{65103510,61503600}},},
	},
	[32447] = {name="Zul'drak Sentinel",locations={[121]={21208260,26208280,28807220,40405460,40406000,42607060,45806040,45807580,49808240},},loot={44677},},
	[32471] = {name="Griegen",locations={[121]={14405620,17407020,20807880,22406180,26205560,26607100},},loot={44686},},
	[32475] = {name="Terror Spinner",locations={[120]={71607500},[121]={53203140,61203640,71402320,71402900,74406640,77204220,81403440},},loot={44685},tameable=132196,},
	[32481] = {name="Aotona",locations={[119]={40205900,41206840,42007380,42205180,52407240,54405180,56406520},},tameable=132192,loot={44691},},
	[32485] = {name="King Krush",locations={[119]={25804880,29204220,32603540,36202960,47004340,50808140,52204240,58808180,63808280},},loot={44683},tameable=236192,},
	[32487] = {name="Putridus the Ancient",locations={[118]={68406420},},loot={44696},
		routes={[118]={{68406420,67405820,66205260,65004740,60804120,54004120,49004280,45205020,44005820,r=0,g=1,b=0,},},},
	},
	[32491] = {
		name="Time-Lost Proto-Drake",
		locations={[120]={31006940,35607660,51007000,52003400},},
		routes={[120]={
			{
				52003400, 43803130, 32603690, 27703960, 28505050, 26805830,
				28706500, 34706500, 40005980, 47205520, 50304870, 46604040,
				loop=true,
				r=0.6,g=0,b=0,
			},
			{
				31006940, 27906450, 26405840, 27805020, 37304120, 39804290, 40405870,
				loop=true,
				r=0,g=0.6,b=0,
			},
			{
				35607660, 35706610, 29006580, 26607510, 31208030,
				loop=true,
				r=0,g=0,b=0.6,
			},
			{
				51007000, 46206050, 41806080, 40106910, 36907250, 38008100, 46708130,
				loop=true,
				r=1,g=1,b=0,
			},
		}},
		loot={{44168,mount=265}},
	},
	[32495] = {name="Hildana Deathstealer",locations={[118]={37702410,52605610},},loot={44697},
		routes={[118]={
			{37702410,32502860,30803280,29603800,31904150,28604540,r=1,g=1,b=1,},
			{52605610,54805220,59405860,59406220,r=1,g=1,b=1,},
		},},
	},
	[32500] = {name="Dirkee",locations={[120]={37805840,41005180,41404020,68004760},},loot={44681,44708},},
	[32501] = {name="High Thane Jorfus",locations={[118]={31206220,33607060,47407820,48408500,67603860,72803500},},loot={44695},},
	[32517] = {name="Loque'nahak",locations={[119]={20607000,30806640,35402960,50808120,58402140,66007900,70807120},},loot={44687,44688},tameable=236165,},
	[32630] = {name="Vyragosa",locations={[120]={31056945,35657665,51057005,52053405},},loot={44732},},
	[33776] = {name="Gondria",locations={[121]={61006160,63204340,67607740,69404800,77006940},},loot={46324},tameable=236165,},
	[35189] = {name="Skoll",locations={[120]={27805040,30206460,46206440},},loot={49227},tameable=236165,},
	[38453] = {name="Arcturis",locations={[116]={31005580},},loot={51958},tameable=236165,},
}, true)

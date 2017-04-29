
local chatdown=require("wetgenes.gamecake.fun.chatdown")
local bitdown=require("wetgenes.gamecake.fun.bitdown")
local chipmunk=require("wetgenes.chipmunk")


hardware,main=system.configurator({
	mode="fun64", -- select the standard 320x240 screen using the swanky32 palette.
	graphics=function() return graphics end,
	update=function() update() end, -- called repeatedly to update+draw
})

-- debug text dump
local ls=function(t) print(require("wetgenes.string").dump(t)) end


local chat_text=[[

#npc1 Conversation NPC1

	A rare bread of NPC who will fulfil all your conversational desires for 
	a very good price.

	=sir sir/madam

	>convo

		Is this the right room for a conversation?
		
	>exit
	
		...ERROR...EOF...PLEASE...RESTART...

<welcome

	Good Morning {sir},
	
	>morning

		Good morning to you too.

	>afternoon

		I think you will find it is now afternoon.

	>sir

		How dare you call me {sir}!

<sir

	My apologies, I am afraid that I am but an NPC with very little 
	brain, how might I address you?
	
	>welcome.1?sir!=madam

		You may address me as Madam.

		=sir madam

	>welcome.2?sir!=God

		You may address me as God.

		=sir God

	>welcome.3?sir!=sir

		You may address me as Sir.

		=sir sir

<afternoon
	
	Then good afternoon {sir},
	
	>convo

<morning
	
	and how may I help {sir} today?
	
	>convo


<convo

	Indeed it is, would you like the full conversation or just the quick natter?

	>convo_full
	
		How long is the full conversation?

	>convo_quick

		A quick natter sounds just perfect.

<convo_full

	The full conversation is very full and long so much so that you 
	will have to page through many pages before you get to make a 
	decision
	
	>
		Like this?
	<
	
	Yes just like this. In fact I think you can see that we are already 
	doing it.
			
	
	>exit

<convo_quick

	...
	
	>exit

#npc2 Conversation NPC2

	Not a real boy.

<welcome

	Sorry but I am not a real boy.
	
	>exit
	
		Bye bye.


#npc3 Conversation NPC3

	Not a real girl.

<welcome

	Sorry but I am not a real girl.
	
	>exit
	
		Bye bye.

]]



-- define all graphics in this global, we will convert and upload to tiles at setup
-- although you can change tiles during a game, we try and only upload graphics
-- during initial setup so we have a nice looking sprite sheet to be edited by artists

graphics={
{0x0100,"char_empty",[[
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
. . . . . . . . 
]]},
{0x0101,"char_black",[[
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
0 0 0 0 0 0 0 0 
]]},
{0x0102,"char_wall",[[
O O R R R R O O 
O O R R R R O O 
r r r r o o o o 
r r r r o o o o 
R R O O O O R R 
R R O O O O R R 
o o o o r r r r 
o o o o r r r r 
]]},
{0x0103,"char_floor",[[
R R R R R R R R 
r r r r r r r r 
r r r r r r r r 
. r r r r r r . 
. . r . r r . . 
. . . . r r . . 
. . . . . r . . 
. . . . . . . . 
]]},

{0x0200,"player_f1",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . 4 4 4 4 . . . . . . . . . . 
. . . . . . . . . 4 2 7 7 1 4 . . . . . . . . . 
. . . . . . . . . 4 7 2 1 7 4 . . . . . . . . . 
. . . . . . . . 4 7 7 1 2 7 7 4 . . . . . . . . 
. . . . . . . 4 7 7 1 7 7 2 7 7 4 . . . . . . . 
. . . . . . . 4 4 4 4 4 4 4 4 4 4 . . . . . . . 
. . . . . . . . . . 7 7 0 7 . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . 7 7 7 7 . 7 7 7 . . . . . . . . 
. . . . . . . . 7 7 7 7 7 . 7 7 . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 7 . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},
{0x0203,"player_f2",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . 4 4 4 4 . . . . . . . . . . 
. . . . . . . . . 4 2 7 7 1 4 . . . . . . . . . 
. . . . . . . . . 4 7 2 1 7 4 . . . . . . . . . 
. . . . . . . . 4 7 7 1 2 7 7 4 . . . . . . . . 
. . . . . . . 4 7 7 1 7 7 2 7 7 4 . . . . . . . 
. . . . . . . 4 4 4 4 4 4 4 4 4 4 . . . . . . . 
. . . . . . . . . . 7 7 0 7 . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . . 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},
{0x0206,"player_f3",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . 4 4 4 4 . . . . . . . . . . 
. . . . . . . . . 4 2 7 7 1 4 . . . . . . . . . 
. . . . . . . . . 4 7 2 1 7 4 . . . . . . . . . 
. . . . . . . . 4 7 7 1 2 7 7 4 . . . . . . . . 
. . . . . . . 4 7 7 1 7 7 2 7 7 4 . . . . . . . 
. . . . . . . 4 4 4 4 4 4 4 4 4 4 . . . . . . . 
. . . . . . . . . . 7 7 0 7 . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . . . 7 7 . . . . . . . . . . . 
. . . . . . . . . . 7 7 7 7 . . . . . . . . . . 
. . . . . . . . . 7 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . 7 7 7 7 7 7 7 7 . . . . . . . . 
. . . . . . . 7 7 7 7 7 7 7 7 7 7 . . . . . . . 
. . . . . . . 7 7 . 7 7 7 7 . 7 7 . . . . . . . 
. . . . . . . . . . 7 7 7 7 7 . . . . . . . . . 
. . . . . . . . . 7 7 7 . 7 7 . 7 . . . . . . . 
. . . . . . . . 7 7 . . . . 7 7 7 . . . . . . . 
. . . . . . . . 7 7 7 . . . 7 7 . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},
{0x0209,"cannon_ball",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . O O O O . . . . . . . . . . 
. . . . . . . R O O O O O O O O R . . . . . . . 
. . . . . . R R R O O O O O O R R R . . . . . . 
. . . . . R R R R O O O O O O R R R R . . . . . 
. . . . . 5 R R R R O O O O R R R R c . . . . . 
. . . . . 5 5 5 R R O O O O R R c c c . . . . . 
. . . . 5 5 5 5 5 5 R 0 0 R c c c c c c . . . . 
. . . . 5 5 5 5 5 5 0 0 0 0 c c c c c c . . . . 
. . . . 5 5 5 5 5 5 0 0 0 0 c c c c c c . . . . 
. . . . 5 5 5 5 5 5 R 0 0 R c c c c c c . . . . 
. . . . . 5 5 5 R R o o o o R R c c c . . . . . 
. . . . . 5 R R R R o o o o R R R R c . . . . . 
. . . . . R R R R o o o o o o R R R R . . . . . 
. . . . . . R R R o o o o o o R R R . . . . . . 
. . . . . . . R o o o o o o o o R . . . . . . . 
. . . . . . . . . . o o o o . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
]]},
{0x0500,"coin",[[
. . . . . . . . 
. . Y Y Y Y . . 
. Y Y 0 0 Y Y . 
Y Y 0 Y Y 0 Y Y 
Y Y Y 0 0 Y Y Y 
Y Y 0 Y Y 0 Y Y 
. Y Y 0 0 Y Y . 
. . Y Y Y Y . . 
]]},


{0x0800,"npc1",[[
. . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . R R R R R . . . . . . . . . 
. . . . . . . . . . R R R R R R R . . . . . . . . 
. . . . . . . . . . R R R R R R R . . . . . . . . 
. . . . . . . . . . . Y 0 Y Y R R . . . . . . . . 
. . . . . . . . . . M Y m m Y R R . . . . . . . . 
. . . . . . . . . . . Y Y Y Y . R . R . . . . . . 
. . . . . . . . . . . . Y Y . . . R . . . . . . . 
. . . . . . . . . . . Y b b Y . . . . . . . . . . 
. . . . . . . . . . Y b b b b Y . . . . . . . . . 
. . . . . . . . . . Y b b b b Y . . . . . . . . . 
. . . . . . . . . Y Y b . b b Y Y . . . . . . . . 
. . . . . . . . . Y Y . b b b Y Y . . . . . . . . 
. . . . . . . . . . . b b b b . . . . . . . . . . 
. . . . . . . . . . Y I . Y Y I . . . . . . . . . 
. . . . . . . . . . Y I I . Y I . . . . . . . . . 
. . . . . . . . . I I I . I I I . . . . . . . . . 
]]},

{0x0803,"npc2",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . I I I . . . . . . . . . . 
. . . . . . . . . . I I I I I . . . . . . . . . 
. . . . . . . . . I I I I I I I . . . . . . . . 
. . . . . . . b b b b b b b b b . . . . . . . . 
. . . . . . . . . j j j j j j j . . . . . . . . 
. . . . . . . . . . s 0 s j j j . . . . . . . . 
. . . . . . . . . M s F F s j . . . . . . . . . 
. . . . . . . . . . s s s s . . . . . . . . . . 
. . . . . . . . . . . s s . . . . . . . . . . . 
. . . . . . . . . . 4 G G 4 . . . . . . . . . . 
. . . . . . . . . 4 G G G G 4 . . . . . . . . . 
. . . . . . . . . 4 G G G G 4 . . . . . . . . . 
. . . . . . . . s s G . G 2 s s . . . . . . . . 
. . . . . . . . s s . 2 2 2 s s . . . . . . . . 
. . . . . . . . . . 2 2 2 2 . . . . . . . . . . 
. . . . . . . . . 7 7 . 7 7 B . . . . . . . . . 
. . . . . . . . . 5 5 B . 5 B . . . . . . . . . 
. . . . . . . . B B B . B B B . . . . . . . . . 
]]},

{0x0806,"npc3",[[
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . . . . . . . . . . . . . 
. . . . . . . . . . . . o o . . . . . . . . . . 
. . . . . . . . . . o o o o o . . . . . . . . . 
. . . . . . . . o o o o o o o o . . . . . . . . 
. . . . . . . . . o o 4 4 o o o . . . . . . . . 
. . . . . . . . . . 4 0 4 4 o o . . . . . . . . 
. . . . . . . . . 5 4 m m 4 4 o . . . . . . . . 
. . . . . . . . . . 4 4 4 4 o o . . . . . . . . 
. . . . . . . . . . . 4 4 . o o . . . . . . . . 
. . . . . . . . . . j 5 5 j . . . . . . . . . . 
. . . . . . . . . 5 f j j f 5 . . . . . . . . . 
. . . . . . . . . 5 j j j j 5 . . . . . . . . . 
. . . . . . . . 4 4 j . j j 4 4 . . . . . . . . 
. . . . . . . . 4 4 . j j j 4 4 . . . . . . . . 
. . . . . . . . . . g g g g . . . . . . . . . . 
. . . . . . . . . g g . g g d . . . . . . . . . 
. . . . . . . . . g g d . g d . . . . . . . . . 
. . . . . . . . d d d . d d d . . . . . . . . . 
]]},

}



local combine_legends=function(...)
	local legend={}
	for _,t in ipairs{...} do -- merge all
		for n,v in pairs(t) do -- shallow copy, right side values overwrite left
			legend[n]=v
		end
	end
	return legend
end

local default_legend={
	[0]={ name="char_empty",	},

	[". "]={ name="char_empty",				},
	["00"]={ name="char_black",				solid=1, dense=1, },		-- black border
	["0 "]={ name="char_empty",				solid=1, dense=1, },		-- empty border

	["||"]={ name="char_wall",				solid=1},				-- wall
	["=="]={ name="char_floor",				solid=1},				-- floor

-- items not tiles, so display tile 0 and we will add a sprite for display
	["S "]={ name="char_empty",	start=1,	},
	["N1"]={ name="char_empty",	npc="npc1",				sprite="npc1", },
	["N2"]={ name="char_empty",	npc="npc2",				sprite="npc2", },
	["N3"]={ name="char_empty",	npc="npc3",				sprite="npc3", },

}
	
levels={}

levels[1]={
legend=combine_legends(default_legend,{
	["?0"]={ name="char_empty" },
}),
title="This is a test.",
map=[[
||0000000000000000000000000000000000000000000000000000000000000000000000000000||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . N3. . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||================================================. . . . ====================||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||======. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||==========. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . ||||||||||||. . . . N2. . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . ||||||||||||. . . . . . . . . ||
||==============. . . . ======================================================||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||==. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . S . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . N1. . ||
||==. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ==============||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||==. . . . . . ====================================================. . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ||
||============================================================================||
||0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ||
]],
}


-- handle tables of entities that need to be updated and drawn.

local entities -- a place to store everything that needs to be updated
local entities_info -- a place to store options or values
local entities_reset=function()
	entities={}
	entities_info={}
end
-- get items for the given caste
local entities_items=function(caste)
	caste=caste or "generic"
	if not entities[caste] then entities[caste]={} end -- create on use
	return entities[caste]
end
-- add an item to this caste
local entities_add=function(it,caste)
	caste=caste or it.caste -- probably from item
	caste=caste or "generic"
	local items=entities_items(caste)
	items[ #items+1 ]=it -- add to end of array
	return it
end
-- call this functions on all items in every caste
local entities_call=function(fname,...)
	local count=0
	for caste,items in pairs(entities) do
		for idx=#items,1,-1 do -- call backwards so item can remove self
			local it=items[idx]
			if it[fname] then
				it[fname](it,...)
				count=count+1
			end
		end			
	end
	return count -- number of items called
end
-- get/set info associated with this entities
local entities_get=function(name)       return entities_info[name]							end
local entities_set=function(name,value)        entities_info[name]=value	return value	end
local entities_manifest=function(name)
	if not entities_info[name] then entities_info[name]={} end -- create empty
	return entities_info[name]
end
-- reset the entities
entities_reset()


-- call coroutine with traceback on error
local coroutine_resume_and_report_errors=function(co,...)
	local a,b=coroutine.resume(co,...)
	if a then return a,b end -- no error
	error( b.."\nin coroutine\n"..debug.traceback(co) , 2 ) -- error
end


-- create space and handlers
function setup_space()

	local space=entities_set("space", chipmunk.space() )
	
	space:gravity(0,700)
	space:damping(0.5)
	space:sleep_time_threshold(1)
	space:idle_speed_threshold(10)
	
	local arbiter_pass={}  -- background tiles we can jump up through
		arbiter_pass.presolve=function(it)
			local points=it:points()
-- once we trigger headroom, we keep a table of headroom shapes and it is not reset until total separation
			if it.shape_b.in_body.headroom then
				local headroom=false
--					for n,v in pairs(it.shape_b.in_body.headroom) do headroom=true break end -- still touching an old headroom shape?
--					if ( (points.normal_y>0) or headroom) then -- can only headroom through non dense tiles
				if ( (points.normal_y>0) or it.shape_b.in_body.headroom[it.shape_a] ) then
					it.shape_b.in_body.headroom[it.shape_a]=true
					return it:ignore()
				end
			end
			
			return true
		end
		arbiter_pass.separate=function(it)
			if it.shape_a and it.shape_b and it.shape_b.in_body then
				if it.shape_b.in_body.headroom then it.shape_b.in_body.headroom[it.shape_a]=nil end
			end
		end
	space:add_handler(arbiter_pass,0x1001)
	
	local arbiter_deadly={} -- deadly things
		arbiter_deadly.presolve=function(it)
			local callbacks=entities_manifest("callbacks")
			if it.shape_b.player then -- trigger die
				local pb=it.shape_b.player
				callbacks[#callbacks+1]=function() pb:die() end
			end
			return true
		end
	space:add_handler(arbiter_deadly,0x1002)

	local arbiter_crumbling={} -- crumbling tiles
		arbiter_crumbling.presolve=function(it)
			local points=it:points()
	-- once we trigger headroom, we keep a table of headroom shapes and it is not reset until total separation
			if it.shape_b.in_body.headroom then
				local headroom=false
	--				for n,v in pairs(it.shape_b.in_body.headroom) do headroom=true break end -- still touching an old headroom shape?
	--				if ( (points.normal_y>0) or headroom) then -- can only headroom through non dense tiles
				if ( (points.normal_y>0) or it.shape_b.in_body.headroom[it.shape_a] ) then
					it.shape_b.in_body.headroom[it.shape_a]=true
					return it:ignore()
				end
				local tile=it.shape_a.tile -- a humanoid is walking on this tile
				if tile then
					tile.level.updates[tile]=true -- start updates to animate this tile crumbling away
				end
			end
			
			return true
		end
		arbiter_crumbling.separate=function(it)
			if it.shape_a and it.shape_b and it.shape_b.in_body then
				if it.shape_b.in_body.headroom then -- only players types will have headroom
					it.shape_b.in_body.headroom[it.shape_a]=nil
				end
			end
		end
	space:add_handler(arbiter_crumbling,0x1003)

	local arbiter_walking={} -- walking things (players)
		arbiter_walking.presolve=function(it)
			local callbacks=entities_manifest("callbacks")
			if it.shape_a.player and it.shape_b.monster then
				local pa=it.shape_a.player
				callbacks[#callbacks+1]=function() pa:die() end
			end
			if it.shape_a.monster and it.shape_b.player then
				local pb=it.shape_b.player
				callbacks[#callbacks+1]=function() pb:die() end
			end
			if it.shape_a.player and it.shape_b.player then -- two players touch
				local pa=it.shape_a.player
				local pb=it.shape_b.player
				if pa.active then
					if pb.bubble_active and pb.joined then -- burst
						callbacks[#callbacks+1]=function() pb:join() end
					end
				end				
				if pb.active then
					if pa.bubble_active and pa.joined then -- burst
						callbacks[#callbacks+1]=function() pa:join() end
					end
				end				
			end
			return true
		end
		arbiter_walking.postsolve=function(it)
			local points=it:points()
			if points.normal_y>0.25 then -- on floor
				local time=entities_get("time")
				it.shape_a.in_body.floor_time=time.game
				it.shape_a.in_body.floor=it.shape_b
			end
			return true
		end
	space:add_handler(arbiter_walking,0x2001) -- walking things (players)

	local arbiter_loot={} -- loot things (pickups)
		arbiter_loot.presolve=function(it)
			if it.shape_a.loot and it.shape_b.player then -- trigger collect
				it.shape_a.loot.player=it.shape_b.player
			end
			return false
		end
	space:add_handler(arbiter_loot,0x3001) 
	
	local arbiter_trigger={} -- trigger things
		arbiter_trigger.presolve=function(it)
			if it.shape_a.trigger and it.shape_b.triggered then -- trigger something
				it.shape_b.triggered.triggered = it.shape_a.trigger
			end
			return false
		end
	space:add_handler(arbiter_trigger,0x4001)

	local arbiter_menu={} -- menu things
		arbiter_menu.presolve=function(it)
			if it.shape_a.menu and it.shape_b.player then -- remember menu
				it.shape_b.player.near_menu=it.shape_a.menu
			end
			return false
		end
		arbiter_menu.separate=function(it)
			if it.shape_a and it.shape_a.menu and it.shape_b and it.shape_b.player then -- forget menu
				it.shape_b.player.near_menu=false
			end
			return true
		end
	space:add_handler(arbiter_menu,0x4002)

	local arbiter_npc={} -- npc menu things
		arbiter_npc.presolve=function(it)
			if it.shape_a.npc and it.shape_b.player then -- remember npc menu
				it.shape_b.player.near_npc=it.shape_a.npc
			end
			return false
		end
		arbiter_npc.separate=function(it)
			if it.shape_a and it.shape_a.npc and it.shape_b and it.shape_b.player then -- forget npc menu
				it.shape_b.player.near_npc=false
			end
			return true
		end
	space:add_handler(arbiter_npc,0x4003)

	return space
end


-- items, can be used for general things, EG physics shapes with no special actions
function add_item()
	local item=entities_add{caste="item"}
	item.draw=function()
		if item.active then
			local px,py,rz=item.px,item.py,item.rz
			if item.body then -- from fizix
				px,py=item.body:position()
				rz=item.body:angle()
			end
			rz=item.draw_rz or rz -- always face up?
			system.components.sprites.list_add({t=item.sprite,h=item.h,hx=item.hx,hy=item.hy,s=item.s,sx=item.sx,sy=item.sy,px=px,py=py,rz=180*rz/math.pi,color=item.color,pz=item.pz})
		end
	end
	return item
end


function setup_score()

	local score=entities_set("score",entities_add{})
	
	entities_set("time",{
		game=0,
	})
	
	score.update=function()
		local time=entities_get("time")
		time.game=time.game+(1/60)
	end

	score.draw=function()
	
		local time=entities_get("time")
	
		local remain=0
		for _,loot in ipairs( entities_items("loot") ) do
			if loot.active then remain=remain+1 end -- count remaining loots
		end
		if remain==0 and not time.finish then -- done
			time.finish=time.game
		end

		local t=time.start and ( (time.finish or time.game) - ( time.start ) ) or 0
		local ts=math.floor(t)
		local tp=math.floor((t%1)*100)

		local s=string.format("%d.%02d",ts,tp)
		system.components.text.text_print(s,math.floor((system.components.text.tilemap_hx-#s)/2),0)

		local s=""
		
		local level=entities_get("level")
		
		s=level.title or s

		for i,player in pairs(entities_items("player")) do
			if player.near_menu then
				s=player.near_menu.title
			end
		end

		system.components.text.text_print(s,math.floor((system.components.text.tilemap_hx-#s)/2),system.components.text.tilemap_hy-1)
		
	end
	
	return score
end

-- move it like a player or monster based on
-- it.move which is "left" or "right" to move 
-- it.jump which is true if we should jump
function char_controls(it,fast)
	fast=fast or 1

	local time=entities_get("time")

	local jump=fast*200 -- up velocity we want when jumping
	local speed=fast*60 -- required x velocity
	local airforce=speed*2 -- replaces surface velocity
	local groundforce=speed/2 -- helps surface velocity
	
	if ( time.game-it.body.floor_time < 0.125 ) or ( it.floor_time-time.game > 10 ) then -- floor available recently or not for a very long time (stuck)
	
		it.floor_time=time.game -- last time we had some floor

		it.shape:friction(1)

		if it.jump_clr and it.near_menu then
			local menu=entities_get("menu")
			local near_menu=it.near_menu
			local callbacks=entities_manifest("callbacks")
			callbacks[#callbacks+1]=function() menu.show(near_menu) end -- call later so we do not process menu input this frame
		end

		if it.jump_clr and it.near_npc then

			local callbacks=entities_manifest("callbacks")
			callbacks[#callbacks+1]=function()

				local chat=chats.get(it.near_npc)
				chat.set_response("welcome")
				menu.show( chat.get_menu_items() )

			end -- call later so we do not process menu input this frame

		end

		if it.jump then

			local vx,vy=it.body:velocity()

			if vy>-20 then -- only when pushing against the ground a little

				if it.near_menu or it.near_npc then -- no jump
				
				else
				
					vy=-jump
					it.body:velocity(vx,vy)
					
					it.body.floor_time=0
				
				end
				
			end

		end

		if it.move=="left" then
			
			local vx,vy=it.body:velocity()
			if vx>0 then it.body:velocity(0,vy) end
			
			it.shape:surface_velocity(speed,0)
			if vx>-speed then it.body:apply_force(-groundforce,0,0,0) end
			it.dir=-1
			it.frame=it.frame+1
			
		elseif it.move=="right" then

			local vx,vy=it.body:velocity()
			if vx<0 then it.body:velocity(0,vy) end

			it.shape:surface_velocity(-speed,0)
			if vx<speed then it.body:apply_force(groundforce,0,0,0) end
			it.dir= 1
			it.frame=it.frame+1

		else

			it.shape:surface_velocity(0,0)

		end
		
	else -- in air

		it.shape:friction(0)

		if it.move=="left" then
			
			local vx,vy=it.body:velocity()
			if vx>0 then it.body:velocity(0,vy) end

			if vx>-speed then it.body:apply_force(-airforce,0,0,0) end
			it.shape:surface_velocity(speed,0)
			it.dir=-1
			it.frame=it.frame+1
			
		elseif  it.move=="right" then

			local vx,vy=it.body:velocity()
			if vx<0 then it.body:velocity(0,vy) end

			if vx<speed then it.body:apply_force(airforce,0,0,0) end
			it.shape:surface_velocity(-speed,0)
			it.dir= 1
			it.frame=it.frame+1

		else

			it.shape:surface_velocity(0,0)

		end

	end
end


function add_player(i)
	local players_colors={30,14,18,7,3,22}

	local names=system.components.tiles.names
	local space=entities_get("space")

	local player=entities_add{caste="player"}

	player.idx=i
	player.score=0
	
	local t=bitdown.cmap[ players_colors[i] ]
	player.color={}
	player.color.r=t[1]/255
	player.color.g=t[2]/255
	player.color.b=t[3]/255
	player.color.a=t[4]/255
	player.color.idx=players_colors[i]
	
	player.up_text_x=math.ceil( (system.components.text.tilemap_hx/16)*( 1 + ((i>3 and i+2 or i)-1)*2 ) )

	player.frame=0
	player.frames={0x0200,0x0203,0x0200,0x0206}
	
	player.join=function()
		local players_start=entities_get("players_start") or {64,64}
	
		local px,py=players_start[1]+i,players_start[2]
		local vx,vy=0,0

		player.bubble_active=false
		player.active=true
		player.body=space:body(1,math.huge)
		player.body:position(px,py)
		player.body:velocity(vx,vy)
		player.body.headroom={}
		
		player.body:velocity_func(function(body)
--				body.gravity_x=-body.gravity_x
--				body.gravity_y=-body.gravity_y
			return true
		end)
					
		player.floor_time=0 -- last time we had some floor

		player.shape=player.body:shape("segment",0,-4,0,4,4)
		player.shape:friction(1)
		player.shape:elasticity(0)
		player.shape:collision_type(0x2001) -- walker
		player.shape.player=player
		
		player.body.floor_time=0
		local time=entities_get("time")
		if not time.start then
			time.start=time.game -- when the game started
		end
	end
	
	player.update=function()
		local up=ups(player.idx) -- the controls for this player
		
		player.move=false
		player.jump=up.button("fire")
		player.jump_clr=up.button("fire_clr")

		if use_only_two_keys then -- touch screen control test?

			if up.button("left") and up.button("right") then -- jump
				player.move=player.move_last
				player.jump=true
			elseif up.button("left") then -- left
				player.move_last="left"
				player.move="left"
			elseif up.button("right") then -- right
				player.move_last="right"
				player.move="right"
			end

		else

			if up.button("left") and up.button("right") then -- stop
				player.move=nil
			elseif up.button("left") then -- left
				player.move="left"
			elseif up.button("right") then -- right
				player.move="right"
			end

		end


		if not player.joined then
			player.joined=true
			player:join() -- join for real and remove bubble
		end

		if player.active then
		
			char_controls(player)
		
		end
	end
	

	player.draw=function()
		if player.bubble_active then

			local px,py=player.bubble_body:position()
			local rz=player.bubble_body:angle()
			player.frame=player.frame%16
			local t=player.frames[1+math.floor(player.frame/4)]
			
			system.components.sprites.list_add({t=t,h=24,px=px,py=py,sx=(player.dir or 1)*0.5,s=0.5,rz=180*rz/math.pi,color=player.color})
			
			system.components.sprites.list_add({t=names.bubble.idx,h=24,px=px,py=py,s=1})

		elseif player.active then
			local px,py=player.body:position()
			local rz=player.body:angle()
			player.frame=player.frame%16
			local t=player.frames[1+math.floor(player.frame/4)]
			
			system.components.sprites.list_add({t=t,h=24,px=px,py=py,sx=player.dir,sy=1,rz=180*rz/math.pi,color=player.color})			
		end

		if player.joined then
			local s=string.format("%d",player.score)
			system.components.text.text_print(s,math.floor(player.up_text_x-(#s/2)),0,player.color.idx)
		end

	end
	
	return player
end

function change_level(idx)

	setup_level(idx)
	
end

function setup_level(idx)

	local level=entities_set("level",entities_add{})

	local names=system.components.tiles.names

	level.updates={} -- tiles to update (animate)
	level.update=function()
		for v,b in pairs(level.updates) do -- update these things
			if v.update then v:update() end
		end
	end

-- init map and space

	local space=setup_space()

	for n,v in pairs( levels[idx].legend ) do -- fixup missing values (this will slightly change your legend data)
		if v.name then -- convert name to tile idx
			v.idx=names[v.name].idx
		end
		if v.idx then -- convert idx to r,g,b,a
			v[1]=(          (v.idx    )%256)
			v[2]=(math.floor(v.idx/256)%256)
			v[3]=31
			v[4]=0
		end
	end

	local map=entities_set("map", bitdown.pix_tiles(  levels[idx].map,  levels[idx].legend ) )
	
	level.title=levels[idx].title
	
	bitdown.pix_grd(    levels[idx].map,  levels[idx].legend,      system.components.map.tilemap_grd  ) -- draw into the screen (tiles)

	local unique=0
	bitdown.map_build_collision_strips(map,function(tile)
		unique=unique+1
		if tile.coll then -- can break the collision types up some more by appending a code to this setting
			if tile.collapse then -- make unique
				tile.coll=tile.coll..unique
			end
		end
	end)

	for y,line in pairs(map) do
		for x,tile in pairs(line) do
			local shape
			if tile.deadly then -- a deadly tile

				if tile.deadly==1 then
					shape=space.static:shape("poly",{x*8+4,y*8+8,(x+1)*8,(y+0)*8,(x+0)*8,(y+0)*8},0)
				else
					shape=space.static:shape("poly",{x*8+4,y*8,(x+1)*8,(y+1)*8,(x+0)*8,(y+1)*8},0)
				end
				shape:friction(1)
				shape:elasticity(1)
				shape.cx=x
				shape.cy=y
				shape:collision_type(0x1002) -- a tile that kills

			elseif tile.solid and (not tile.parent) then -- if we have no parent then we are the master tile
			
				local l=1
				local t=tile
				while t.child do t=t.child l=l+1 end -- count length of strip

				if     tile.link==1 then -- x strip
					shape=space.static:shape("box",x*8,y*8,(x+l)*8,(y+1)*8,0)
				elseif tile.link==-1 then  -- y strip
					shape=space.static:shape("box",x*8,y*8,(x+1)*8,(y+l)*8,0)
				else -- single box
					shape=space.static:shape("box",x*8,y*8,(x+1)*8,(y+1)*8,0)
				end

				shape:friction(tile.solid)
				shape:elasticity(tile.solid)
				shape.cx=x
				shape.cy=y
				shape.coll=tile.coll
				if tile.collapse then
					shape:collision_type(0x1003) -- a tile that collapses when we walk on it
					tile.update=function(tile)
						tile.anim=(tile.anim or 0) + 1
						
						if tile.anim%4==0 then
							local dust=entities_get("dust")
							dust.add({
								vx=0,
								vy=0,
								px=(tile.x+math.random())*8,
								py=(tile.y+math.random())*8,
								life=60*2,
								friction=1,
								elasticity=0.75,
							})
						end

						if tile.anim > 60 then
							space:remove( tile.shape )
							tile.shape=nil
							system.components.map.tilemap_grd:pixels(tile.x,tile.y,1,1,{0,0,0,0})
							system.components.map.dirty(true)
							level.updates[tile]=nil
						else
							local name
							if     tile.anim < 20 then name="char_floor_collapse_1"
							elseif tile.anim < 40 then name="char_floor_collapse_2"
							else                       name="char_floor_collapse_3"
							end
							local idx=names[name].idx
							local v={}
							v[1]=(          (idx    )%256)
							v[2]=(math.floor(idx/256)%256)
							v[3]=31
							v[4]=0
							system.components.map.tilemap_grd:pixels(tile.x,tile.y,1,1,v)
							system.components.map.dirty(true)
						end
					end
				elseif not tile.dense then 
					shape:collision_type(0x1001) -- a tile we can jump up through
				end
			end
			if tile.push then
				if shape then
					shape:surface_velocity(tile.push*12,0)
				end
				level.updates[tile]=true
				tile.update=function(tile)
					tile.anim=( (tile.anim or 0) + 1 )%20
					
					local name
					if     tile.anim <  5 then name="char_floor_move_1"
					elseif tile.anim < 10 then name="char_floor_move_2"
					elseif tile.anim < 15 then name="char_floor_move_3"
					else                       name="char_floor_move_4"
					end
					local idx=names[name].idx
					local v={}
					v[1]=(          (idx    )%256)
					v[2]=(math.floor(idx/256)%256)
					v[3]=31
					v[4]=0
					system.components.map.tilemap_grd:pixels(tile.x,tile.y,1,1,v)
					system.components.map.dirty(true)
				end
			end

			tile.map=map -- remember map
			tile.level=level -- remember level
			if shape then -- link shape and tile
				shape.tile=tile
				tile.shape=shape
			end
		end
	end


	for y,line in pairs(map) do
		for x,tile in pairs(line) do

			if tile.loot then
				local loot=add_loot()

				local shape=space.static:shape("box",x*8,y*8,(x+1)*8,(y+1)*8,0)
				shape:collision_type(0x3001)
				shape.loot=loot
				loot.shape=shape
				loot.px=x*8+4
				loot.py=y*8+4
				loot.active=true
			end
			if tile.item then
				local item=add_item()
				
				item.sprite=names.cannon_ball.idx
				item.h=24

				item.active=true
				item.body=space:body(2,2)
				item.body:position(x*8+4,y*8+4)

				item.shape=item.body:shape("circle",8,0,0)
				item.shape:friction(0.5)
				item.shape:elasticity(0.5)

			end
			if tile.start then
				entities_set("players_start",{x*8+4,y*8+4}) --  remember start point
			end
			if tile.monster then
				local item=add_monster{
					px=x*8+4,py=y*8+4,
					vx=0,vy=0,
				}
			end
			if tile.trigger then
				local item=add_item()

				local shape=space.static:shape("box", x*8 - (tile.trigger*6) ,y*8, (x+1)*8 - (tile.trigger*6) ,(y+1)*8,0)
				item.shape=shape
				
				shape:collision_type(0x4001)
				shape.trigger=tile
			end
			if tile.menu then
				local item=add_item()

				item.shape=space.static:shape("box", (x-1)*8,(y-1)*8, (x+2)*8,(y+2)*8,0)
				
				item.shape:collision_type(0x4002)
				item.shape.menu=tile.menu
			end
			if tile.sign then
				local items={}
				tile.items=items
				local px,py=x*8-(#tile.sign)*4 + (tile.sign_x or 0) ,y*8 + (tile.sign_y or 0)
				for i=1,#tile.sign do
					local item=add_item()
					items[i]=item

					item.sprite=tile.sign:byte(i)/2
					item.hx=4
					item.hy=8
					item.s=2

					item.active=true
					item.body=space:body(1,100)
					item.body:position(px+i*8-4 ,py+8 )

					item.shape=item.body:shape("box", -4 ,-8, 4 ,8,0)
					item.shape:friction(1)
					item.shape:elasticity(0.5)
					
					if tile.colors then item.color=tile.colors[ ((i-1)%#tile.colors)+1 ] end
										
					if items[i-1] then -- link
						item.constraint=space:constraint(item.body,items[i-1].body,"pin_joint", 0,-8 , 0,-8 )
						item.constraint:collide_bodies(false)
					end					
				end
				local item=items[1] -- first
				item.constraint_static=space:constraint(item.body,space.static,"pin_joint", 0,-8 , px-4,py )

				local item=items[#tile.sign] -- last
				item.constraint_static=space:constraint(item.body,space.static,"pin_joint", 0,-8 , px+#tile.sign*8+4,py )
			end
			if tile.spill then
				level.updates[tile]=true
				tile.update=function(tile)
					local dust=entities_get("dust")
					dust.add({
						vx=0,
						vy=0,
						px=(tile.x+math.random())*8,
						py=(tile.y+math.random())*8,
						life=60*2,
						friction=1,
						elasticity=0.75,
					})
				end
			end
			if tile.bubble then
				level.updates[tile]=true
				tile.update=function(tile)
					tile.count=((tile.count or tile.bubble.start )+ 1)%tile.bubble.rate
					if tile.count==0 then
						local dust=entities_get("dust")
						dust.add({
							vx=0,
							vy=0,
							px=(tile.x+math.random())*8,
							py=(tile.y+math.random())*8,
							sprite = names.bubble.idx,
							mass=1/64,inertia=1,
							h=24,
							s=1,
							shape_args={"circle",12,0,0},
							life=60*16,
							friction=0,
							elasticity=15/16,
							gravity={0,-64},
							draw_rz=0,
							die_speed=128,
							on_die=function(it) -- burst
								local px,py=it.body:position()
								for i=1,16 do
									local r=math.random(math.pi*2000)/1000
									local vx=math.sin(r)
									local vy=math.cos(r)
									dust.add({
										gravity={0,-64},
										mass=1/16384,
										vx=vx*100,
										vy=vy*100,
										px=px+vx*8,
										py=py+vy*8,
										friction=0,
										elasticity=0.75,
										sprite= names.char_dust_white.idx,
										life=15*(2+i),
									})
								end
							end
						})
					end
				end
			end
			if tile.sprite then
				local item=add_item()
				item.active=true
				item.px=tile.x*8+4
				item.py=tile.y*8+4
				item.sprite = names[tile.sprite].idx
				item.h=24
				item.s=1
				item.draw_rz=0
				item.pz=-1
			end
			if tile.npc then
				local item=add_item()

				item.shape=space.static:shape("box", (x-1)*8,(y-1)*8, (x+2)*8,(y+2)*8,0)

-- print("npc",x,y)

				item.shape:collision_type(0x4003)
				item.shape.npc=tile.npc
			end
		end
	end
	
end

-----------------------------------------------------------------------------
--[[#setup_menu

	menu = setup_menu()

Create a displayable and controllable menu system that can be fed chat 
data for user display.

After setup, provide it with menu items to display using 
menu.show(items) then call update and draw each frame.


]]
-----------------------------------------------------------------------------
function setup_menu(items)

	local wstr=require("wetgenes.string")

	local menu=entities_set("menu",entities_add{})
--	local menu={}

	menu.stack={}

	menu.width=80-4
	menu.cursor=0
	menu.cx=math.floor((80-menu.width)/2)
	menu.cy=0
	
	function menu.show(items)
	
		if not items then
			menu.items=nil
			menu.lines=nil
			return
		end

		if items.call then items.call(items,menu) end -- refresh
		
		menu.items=items
		menu.cursor=items.cursor or 1
		
		menu.lines={}
		for idx=1,#items do
			local item=items[idx]
			local text=item.text
			if text then
				local ls=wstr.smart_wrap(text,menu.width-8)
				if #ls==0 then ls={""} end -- blank line
				for i=1,#ls do
					local prefix=""--(i>1 and " " or "")
					if item.cursor then prefix=" " end -- indent decisions
					menu.lines[#menu.lines+1]={s=prefix..ls[i],idx=idx,item=item,cursor=item.cursor,color=item.color}
				end
			end
		end

	end


	
	menu.update=function()
	
		if not menu.items then return end

		local bfire,bup,bdown,bleft,bright
		
		for i=0,5 do -- any player, press a button, to control menu
			local up=ups(i)
			if up then
				bfire =bfire  or up.button("fire_clr")
				bup   =bup    or up.button("up_set")
				bdown =bdown  or up.button("down_set")
				bleft =bleft  or up.button("left_set")
				bright=bright or up.button("right_set")
			end
		end
		

		if bfire then

			for i,item in ipairs(menu.items) do
			
				if item.cursor==menu.cursor then
			
					if item.call then -- do this
					
						if item and item.decision and item.decision.name=="exit" then --exit menu
							menu.show()	-- hide
						else
							item.call( item , menu )
						end
					end
					
					break
				end
			end
		end
		
		if bleft or bup then
		
			menu.cursor=menu.cursor-1
			if menu.cursor<1 then menu.cursor=menu.items.cursor_max end

		end
		
		if bright or bdown then
			
			menu.cursor=menu.cursor+1
			if menu.cursor>menu.items.cursor_max then menu.cursor=1 end
		
		end
	
	end
	
	menu.draw=function()

		local tprint=system.components.text.text_print
		local tgrd=system.components.text.tilemap_grd

		if not menu.lines then return end
		
		menu.cy=math.floor((30-(#menu.lines+4))/2)
		
		tgrd:clip(menu.cx,menu.cy,0,menu.width,#menu.lines+4,1):clear(0x02000000)
		tgrd:clip(menu.cx+2,menu.cy+1,0,menu.width-4,#menu.lines+4-2,1):clear(0x01000000)
		
		if menu.items.title then
			local title=" "..(menu.items.title).." "
			local wo2=math.floor(#title/2)
			tprint(title,menu.cx+(menu.width/2)-wo2,menu.cy+0,31,2)
		end
		
		for i,v in ipairs(menu.lines) do
			tprint(v.s,menu.cx+4,menu.cy+i+1,v.color or 31,1)
		end
		
		local it=nil
		for i=1,#menu.lines do
			if it~=menu.lines[i].item then -- first line only
				it=menu.lines[i].item
				if it.cursor == menu.cursor then
					tprint(">",menu.cx+4,menu.cy+i+1,31,1)
				end
			end
		end

		system.components.text.dirty(true)

	end
	

	if items then menu.show(items) end
	
	return menu
end


-----------------------------------------------------------------------------
--[[#update

	update()

Update and draw loop, called every frame.

]]
-----------------------------------------------------------------------------
update=function()

	if not setup_done then

		entities_reset()

		chats=chatdown.setup(chat_text)
		menu=setup_menu() -- chats.get_menu_items("example") )

		setup_score()
		
		setup_level(1) -- load map
		
		add_player(1) -- add a player

		setup_done=true
	end
	
	if menu.lines then -- menu only, pause the entities
		menu.update()
		menu.draw()
	else
		entities_call("update")
		local space=entities_get("space")
		space:step(1/(60*2)) -- double step for increased stability, allows faster velocities.
		space:step(1/(60*2))
	end

	-- run all the callbacks created by collisions 
	for _,f in pairs(entities_manifest("callbacks")) do f() end
	entities_set("callbacks",{}) -- and reset the list

	entities_call("draw") -- because we are going to add them all in again here
	
end

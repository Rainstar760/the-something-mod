

local files = {
	--"items/unbalanced_enhancements",
	"items/t4somc_jokers",
	--"items/unbalanced_consumables",
	"items/consumables",
	"items/cracked_jokers",
	"items/boosters",
	--"items/unbalanced_seals",
	"lib/cardanim",
	"lib/cardanim_macros/skim",
}
for i, v in pairs(files) do
	assert(SMODS.load_file(v..".lua"))()
end


-- atlas dump

SMODS.Atlas {
    key = "placeholders",
    path = "placeholders.png",
    px = 71,
    py = 95
}

-- funny
--local tb = to_big
--function to_big(n)
--	return tb(n*1)
--end
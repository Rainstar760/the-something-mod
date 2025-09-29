

local files = {
	--"items/unbalanced_enhancements",
	"items/t4somc_jokers",
	--"items/unbalanced_consumables",
	"items/consumables",
	"items/misc_jokers",
	--"items/cracked_jokers",
	"items/boosters",
	"items/blinds",
	"items/decks",
	--"items/unbalanced_seals",
	"lib/cardanim",
	"lib/cardanim_macros/skim",
	"localization/en-us",
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

-- optional features idk
SMODS.current_mod.optional_features = {
    retrigger_joker = true,
    post_trigger = true,
    quantum_enhancements = true,
    cardareas = {
        discard = true,
        deck = true
    }
}
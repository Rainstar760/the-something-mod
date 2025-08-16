
SMODS.Back{
	key = "truly_balanced",
	config = {},
	atlas = "placeholders",
	pos = { x = 4, y = 2 },
	dependencies = {"Cryptid"},
    loc_txt = {
        name = "Totally Balanced Deck",
        text ={
			"ALL values are multiplied by 10",
			"Ante scaling is way harsher",
        },
    },
	apply = function(self)
		G.GAME.modifiers.cry_misprint_min = 10
		G.GAME.modifiers.cry_misprint_max = 10
		G.GAME.exponential_scaling = true
	end,
}


local exponential_scaling = get_blind_amount
get_blind_amount = function(ante)
    if G.GAME.exponential_scaling == true then
        return 300 ^ ante
    end
    return exponential_scaling(ante)
end
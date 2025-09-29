
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
			"Ante scaling is now 300 ^ (Ante)!",
        },
    },
	apply = function(self)
		G.GAME.modifiers.cry_misprint_min = 10
		G.GAME.modifiers.cry_misprint_max = 10
		G.GAME.truly_balanced_scaling = true
	end,
}

-- this makes the first like 3 antes free but it scales absurdly fast
local truly_balanced_scaling = get_blind_amount
get_blind_amount = function(ante)
    if G.GAME.truly_balanced_scaling == true then
        return 300 ^ factorial(ante)
    end
    return truly_balanced_scaling(ante)
end


SMODS.Back{
	key = "needle_deck",
	config = { discards = 3, hands = -3, extra_hand_bonus = 0, extra_discard_bonus = 1 },
	atlas = "placeholders",
	pos = { x = 4, y = 2 },
    loc_txt = {
        name = "Needle Deck",
        text ={
			"{C:chips}-3{} Hands, {C:chips}+3{} Discards",
			"Whenever you gain hands, convert them to discards",
			"Earn {C:money}1${} per discard instead",
        },
    },
    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.discards, self.config.hands } }
    end,
	apply = function(self)
		G.GAME.convert_hands_to_discards = true
	end,
}

local convert_hands_to_discards = ease_hands_played
ease_hands_played = function(hands)
    if G.GAME.convert_hands_to_discards == true and hands >= 0 then
		ease_discard(hands)
		ease_hands_played(-hands)
        return true
    end
    return convert_hands_to_discards(hands)
end
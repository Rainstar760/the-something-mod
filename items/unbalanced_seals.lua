-- atlas dump

SMODS.Atlas {
    key = "unbalanced_seals",
    path = "unbalanced_enhancements.png",
    px = 71,
    py = 95
}

-- all the fucking unbalanced seals

SMODS.Seal {
    name = "Unbalanced Red Seal",
    key = "unbalanced_red_seal",
    badge_colour = HEX("FFFF00"),
	config = { retriggers = 10 },
    loc_txt = {
        label = 'Unbalanced Red Seal',
        name = 'Unbalanced Red Seal',
        text = {
            'Retrigger this card {C:attention}#1#{} times',
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.retriggers } }
    end,
    atlas = "unbalanced_seals",
    pos = {x=2, y=0},
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play then
			return {
				repetition = self.config.retriggers
			}
		end
	end
}

SMODS.Seal {
    name = "Unbalanced Blue Seal",
    key = "unbalanced_blue_seal",
    badge_colour = HEX("0000FF"),
	config = {  },
    loc_txt = {
        label = 'Unbalanced Blue Seal',
        name = 'Unbalanced Blue Seal',
        text = {
            'Creates a {C:attention}Black Hole{} at the end of round',
			'if held in hand',
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = {  } }
    end,
    atlas = "unbalanced_seals",
    pos = {x=6, y=4},
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.hand then
        	G.E_MANAGER:add_event(Event({
        	    trigger = 'before',
        	    delay = 0.0,
        	    func = (function()
        	        if G.GAME.last_hand_played then
        	            local card = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'blusl')
        	            card:add_to_deck()
        	            G.consumeables:emplace(card)
        	            G.GAME.consumeable_buffer = 0
        	        end
        	        return true
        	    end)}))
        	card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
		end
	end
}


SMODS.Seal {
    name = "Unbalanced Purple Seal",
    key = "unbalanced_purple_seal",
    badge_colour = HEX("FF00FF"),
	config = {  },
    loc_txt = {
        label = 'Unbalanced Purple Seal',
        name = 'Unbalanced Purple Seal',
        text = {
            'Creates a random, unweighted {C:attention}Consumable{} when discarded',
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = {  } }
    end,
    atlas = "unbalanced_seals",
    pos = {x=4, y=4},
	calculate = function(self, card, context)
		if context.discard then
			local key = G.P_CENTER_POOLS.Consumeables[math.random(0, #G.P_CENTER_POOLS.Consumeables)].key
			G.E_MANAGER:add_event(Event({func = function()
				local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, key, 'unbalance_my_purple_seals')
				card1:add_to_deck()
				G.consumeables:emplace(card1)
				card1:juice_up(0.3, 0.5)
				return true
			end }))
		end
	end
}

SMODS.Seal {
    name = "Unbalanced Gold Seal",
    key = "unbalanced_gold_seal",
    badge_colour = HEX("FFFF00"),
	config = { money = 25 },
    loc_txt = {
        label = 'Unbalanced Gold Seal',
        name = 'Unbalanced Gold Seal',
        text = {
            'Earn {C:money}#1#${} when this card scores',
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.money } }
    end,
    atlas = "unbalanced_seals",
    pos = {x=5, y=4},
	get_p_dollars = function(self, card)
		return self.config.money
	end
}
-- rarities (and gradients)

SMODS.Rarity({
	key = "cracked",
	loc_txt = {
		name = 'Cracked'
	},
	badge_colour = cracked_gradient,
	default_weight = 0,
	pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
		return weight
	end
})

local cracked_gradient = SMODS.Gradient({
    key="cracked",
    colours = {
        HEX("000000"),
        HEX("FF0000"),
        HEX("FFFF00"),
        HEX("00FF00"),
        HEX("00FFFF"),
        HEX("0000FF"),
        HEX("FF00FF"),
        HEX("FFFFFF"),
    },
	cycle = 5
})

SMODS.Rarity({
	key = "beyond_cracked",
	loc_txt = {
		name = 'Beyond Cracked'
	},
	badge_colour = beyond_cracked_gradient,
	default_weight = 0,
	pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
		return weight
	end
})

local beyond_cracked_gradient = SMODS.Gradient({
    key="cracked",
    colours = {
        HEX("000000"),
    },
	cycle = 5
})

-- cracked jokers
SMODS.Joker {
	key = 'the_joker',
	loc_txt = {
		name = 'The Joker of All Jokers',
		text = {
			"Cards held in hand give {X:mult,C:white}x#1#{} Mult",
			"Scored Cards give {X:dark_edition,C:white}^#2#{} Mult",
			"{X:dark_edition,C:edition}^^#3#{} Mult when triggered",
		}
	},
	config = { extra = { held_xmult = 4, scored_emult = 4, eemult = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.held_xmult, card.ability.extra.scored_emult, card.ability.extra.eemult } }
	end,
	rarity = 'r_cracked',
	atlas = 'placeholders',
	pos = { x = 10, y = 0 },
	cost = 500,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				EEmult_mod = card.ability.extra.eemult,
				message = '^^' .. card.ability.extra.eemult .. ' Mult',
                color = G.C.MULT
			}
		end
        if context.cardarea == G.play and context.individual then
			return {
				Emult_mod = card.ability.extra.scored_emult,
				message = '^' .. card.ability.extra.scored_emult .. ' Mult',
                color = G.C.MULT
			}
        end
        if context.cardarea == G.hand and context.individual and not context.end_of_round then
			return {
				Xmult_mod = card.ability.extra.scored_emult,
				message = 'X' .. card.ability.extra.scored_emult .. ' Mult',
                color = G.C.MULT
			}
        end
	end
}


SMODS.Joker {
	key = 'money_printer',
	loc_txt = {
		name = 'Money Printer',
		text = {
			"Gives {X:dark_edition,C:white}^#1#${} at the end of round",
		}
	},
	config = { extra = { emoney = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.emoney } }
	end,
	rarity = 'r_cracked',
	atlas = 'placeholders',
	pos = { x = 10, y = 0 },
	cost = 500,
	calc_dollar_bonus = function(self, card)
	return 
		G.GAME.dollars ^ card.ability.extra.emoney
	end
}

SMODS.Joker {
	key = 'the_universe',
	loc_txt = {
		name = 'The Fucking Universe Itself',
		text = {
			"Gains {X:dark_edition,C:white}^#1#{} Chips and {X:dark_edition,C:white}^#2#{} Mult",
			"for every atom in the observable universe",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#3#{} Chips and {X:dark_edition,C:white}^#4#{} Mult)"
		}
	},
	config = { extra = { echips_mod = 1, emult_mod = 1, echips = 1, emult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.echips_mod, card.ability.extra.emult_mod, card.ability.extra.echips, card.ability.extra.emult } }
	end,
	rarity = 'r_cracked',
	atlas = 'placeholders',
	pos = { x = 10, y = 0 },
	cost = 500,
	update = function(self, card, dt)
		card.ability.extra.echips = card.ability.extra.echips_mod * 1e82
		card.ability.extra.emult = card.ability.extra.emult_mod * 1e82
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Echip_mod = card.ability.extra.echips,
				message = '^' .. card.ability.extra.echips .. ' Chips',
                color = G.C.DARK_EDITION,
				extra = {
					Emult_mod = card.ability.extra.emult,
					message = '^' .. card.ability.extra.emult .. ' Mult',
            	    color = G.C.DARK_EDITION
				}
			}
		end
	end
}

SMODS.Joker {
	key = 'flushmaster',
	loc_txt = {
		name = 'Flushmaster',
		text = {
			"Flushes and Straights can now be made with only {C:attention}1{} card",
			"If played hand is a {C:attention}Flush{}, {C:attention}Straight Flush{}, {C:attention}Flush House{} or {C:attention}Flush Five{},",
			"{X:attention,C:white}X#1#{} all of its stats before scoring"
		}
	},
	config = { extra = { multiplier = 10 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.multiplier } }
	end,
	rarity = 'r_cracked',
	atlas = 'placeholders',
	pos = { x = 10, y = 0 },
	cost = 500,
	calculate = function(self, card, context)
		if context.before and next(context.poker_hands["Flush"]) then
			G.GAME.hands[context.scoring_name].level = G.GAME.hands[context.scoring_name].level * card.ability.extra.multiplier
			G.GAME.hands[context.scoring_name].l_chips = G.GAME.hands[context.scoring_name].l_chips * card.ability.extra.multiplier
			G.GAME.hands[context.scoring_name].l_mult = G.GAME.hands[context.scoring_name].l_mult * card.ability.extra.multiplier
			G.GAME.hands[context.scoring_name].chips = G.GAME.hands[context.scoring_name].chips * card.ability.extra.multiplier
			G.GAME.hands[context.scoring_name].mult = G.GAME.hands[context.scoring_name].mult * card.ability.extra.multiplier
			return {
                message = localize('k_level_up_ex')
			}
		end
	end
}
-- flushmaster thing idk
local smods_four_fingers_ref = SMODS.four_fingers
function SMODS.four_fingers()
    if next(SMODS.find_card("j_r_flushmaster")) then
        return 1
    end
    return smods_four_fingers_ref()
end

--SMODS.Joker {
--	key = 'unbalancer',
--	loc_txt = {
--		name = 'Unbalancer',
--		text = {
--			"When a {C:attention}Consumable{} is added, convert it into its",
--			"{C:attention}Unbalanced{} counterpart if possible",
--			"Creates {C:attention}#1#{} random, unweighted {C:attention}Consumables{} when blind is selected",
--			"{C:inactive}(Does not require room)"
--		}
--	},
--	config = { extra = { consumables = 3 } },
--	loc_vars = function(self, info_queue, card)
--		return { vars = { card.ability.extra.consumables } }
--	end,
--	rarity = 'r_cracked',
--	atlas = 'placeholders',
--	pos = { x = 10, y = 0 },
--	cost = 500,
--	calculate = function(self, card, context)
--		if context.setting_blind then
--			for i=1, card.ability.extra.consumables do
--				local key = G.P_CENTER_POOLS.Consumeables[math.random(0, #G.P_CENTER_POOLS.Consumeables)].key
--				G.E_MANAGER:add_event(Event({func = function()
--					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, key, 'john_unbalancer')
--					card1:add_to_deck()
--					G.consumeables:emplace(card1)
--					card1:juice_up(0.3, 0.5)
--					return true
--				end }))
--			end
--		end
--		if context.card_added or context.buying_card then
--			if context.card.config.center.key == "c_hermit" then
--				card:start_dissolve()
--				card:remove_from_deck()
--				G.E_MANAGER:add_event(Event({func = function()
--					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, "c_r_unbalanced_hermit", 'john_unbalancer')
--					card1:add_to_deck()
--					G.consumeables:emplace(card1)
--					card1:juice_up(0.3, 0.5)
--					return true
--				end }))
--			elseif card.config.center.key == "c_temperance" then
--				card:start_dissolve()
--				card:remove_from_deck()
--				G.E_MANAGER:add_event(Event({func = function()
--					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, "c_r_unbalanced_temperance", 'john_unbalancer')
--					card1:add_to_deck()
--					G.consumeables:emplace(card1)
--					card1:juice_up(0.3, 0.5)
--					return true
--				end }))
--			elseif card.config.center.key == "c_magician" then
--				card:start_dissolve()
--				card:remove_from_deck()
--				G.E_MANAGER:add_event(Event({func = function()
--					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, "c_r_unbalanced_magician", 'john_unbalancer')
--					card1:add_to_deck()
--					G.consumeables:emplace(card1)
--					card1:juice_up(0.3, 0.5)
--					return true
--				end }))
--			elseif card.config.center.key == "c_death" then
--				card:start_dissolve()
--				card:remove_from_deck()
--				G.E_MANAGER:add_event(Event({func = function()
--					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, "c_r_unbalanced_death", 'john_unbalancer')
--					card1:add_to_deck()
--					G.consumeables:emplace(card1)
--					card1:juice_up(0.3, 0.5)
--					return true
--				end }))
--			elseif card.config.center.key == "c_justice" then
--				card:start_dissolve()
--				card:remove_from_deck()
--				G.E_MANAGER:add_event(Event({func = function()
--					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, "c_r_unbalanced_justice", 'john_unbalancer')
--					card1:add_to_deck()
--					G.consumeables:emplace(card1)
--					card1:juice_up(0.3, 0.5)
--					return true
--				end }))
--			elseif card.config.center.key == "c_incantation" then
--				card:start_dissolve()
--				card:remove_from_deck()
--				G.E_MANAGER:add_event(Event({func = function()
--					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, "c_r_unbalanced_incantation", 'john_unbalancer')
--					card1:add_to_deck()
--					G.consumeables:emplace(card1)
--					card1:juice_up(0.3, 0.5)
--					return true
--				end }))
--			elseif card.config.center.key == "c_blackhole" then
--				card:start_dissolve()
--				card:remove_from_deck()
--				G.E_MANAGER:add_event(Event({func = function()
--					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, "c_r_unbalanced_blackhole", 'john_unbalancer')
--					card1:add_to_deck()
--					G.consumeables:emplace(card1)
--					card1:juice_up(0.3, 0.5)
--					return true
--				end }))
--			elseif card.config.center.key == "c_soul" then
--				card:start_dissolve()
--				card:remove_from_deck()
--				G.E_MANAGER:add_event(Event({func = function()
--					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, "c_r_unbalanced_soul", 'john_unbalancer')
--					card1:add_to_deck()
--					G.consumeables:emplace(card1)
--					card1:juice_up(0.3, 0.5)
--					return true
--				end }))
--			end
--		end
--	end
--}

SMODS.Joker {
	key = 'heptation_henry',
	loc_txt = {
		name = 'heptation henry',
		text = {
			"{X:dark_edition,C:edition}^^^^^#1#{} Mult",
			"{C:inactive}...hey wait a god damn minute this seems familiar{}"
		}
	},
	config = { extra = { EEEEEmult = 1.1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.EEEEEmult } }
	end,
	rarity = 'r_cracked',
	atlas = 'placeholders',
	pos = { x = 10, y = 0 },
	cost = 500,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				hypermult_mod = {5, 27},
				message = '^^^^^' .. card.ability.extra.EEEEEmult .. ' Mult',
                color = G.C.DARK_EDITION
			}
		end
	end
}

SMODS.Joker {
	key = 'unweighted',
	loc_txt = {
		name = 'The Unweighted',
		text = {
			"Creates {C:attention}#1#{} random {C:attention}Joker{} when exiting shop",
			"Creates {C:attention}#2#{} random {C:attention}Consumables{} when blind is selected",
			"Applies a random {C:attention}Edition{} to a random {C:attention}Joker{} when blind is selected",
			"Applies a random {C:attention}Enhancement{} to a random card held in hand when hand is played",
			"All possibilities in this joker are {C:attention}completely unweighted{}"
		}
	},
	config = { extra = { jokers = 1, consumables = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.jokers, card.ability.extra.consumables } }
	end,
	rarity = 'r_cracked',
	atlas = 'placeholders',
	pos = { x = 10, y = 0 },
	cost = 500,
	calculate = function(self, card, context)
		if context.setting_blind then
			for i=1, card.ability.extra.consumables do
				local key = G.P_CENTER_POOLS.Consumeables[math.random(0, #G.P_CENTER_POOLS.Consumeables)].key
				G.E_MANAGER:add_event(Event({func = function()
					local card1 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, key, 'john_unweighter')
					card1:add_to_deck()
					G.consumeables:emplace(card1)
					card1:juice_up(0.3, 0.5)
					return true
				end }))
			end
			if context.cardarea == G.jokers then
				local i = math.random(0, #G.jokers.cards)
            	G.jokers.cards[i]:set_edition(G.P_CENTER_POOLS["Edition"][math.random(1, #G.P_CENTER_POOLS["Edition"])].key, true, true)
			end
		end
		if context.ending_shop then
			for i=1, card.ability.extra.jokers do
				local key = G.P_CENTER_POOLS.Joker[math.random(0, #G.P_CENTER_POOLS.Joker)].key
				G.E_MANAGER:add_event(Event({func = function()
					local card1 = create_card('Joker', G.jokers, nil, nil, nil, nil, key, 'john_unweighter')
					card1:add_to_deck()
					G.jokers:emplace(card1)
					card1:juice_up(0.3, 0.5)
					return true
				end }))
			end
		end
		if context.before then
			local i = math.random(0, #G.hand.cards)
            G.hand.cards[i]:set_ability(G.P_CENTER_POOLS.Enhanced[math.random(1, #G.P_CENTER_POOLS.Enhanced)].key, true)
		end
	end
}

-- beyond cracked jokers
SMODS.Joker {
	key = 'funny',
	loc_txt = {
		name = 'The Funny',
		text = {
			"{C:chips}+[blind size]{} Chips",
            "{C:inactive}(Currently {C:chips}+#1#{} Chips)"
		}
	},
	config = { extra = { chips = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	rarity = 'r_beyond_cracked',
	atlas = 'placeholders',
	pos = { x = 11, y = 0 },
	cost = 1000000,
	calculate = function(self, card, context)
		if context.setting_blind then
            card.ability.extra.chips = G.GAME.blind.chips
		end
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = '+' .. card.ability.extra.chips .. ' Chips',
                color = G.C.CHIPS
			}
		end
	end
}

SMODS.Joker {
	key = 'jimbo',
	loc_txt = {
		name = 'Jimbo Himself',
		text = {
			"{X:dark_edition,C:edition}#3#X#4#Y{} Chips & Mult",
			"where X is the amount of jokers you have",
			"and Y is the amount of cards in your deck",
            "{C:inactive}(Currently {X:dark_edition,C:edition}#3##1##4##2#{} Chips & Mult)"
		}
	},
	config = { extra = { jokers = 0, cards = 0, active = false } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.jokers, card.ability.extra.cards, '{', '}' } }
	end,
	rarity = 'r_beyond_cracked',
	atlas = 'placeholders',
	pos = { x = 11, y = 0 },
	cost = 1000000,
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.active = true
	end,
	update = function(self, card, dt)
		if card.ability.extra.active == true then
			card.ability.extra.jokers = #G.jokers.cards + 1
			card.ability.extra.cards = #G.deck.cards
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				hyperchip_mod = {card.ability.extra.jokers, card.ability.extra.cards},
				hypermult_mod = {card.ability.extra.jokers, card.ability.extra.cards},
				message = '{' .. card.ability.extra.jokers .. '}' .. card.ability.extra.cards ..' Chips & Mult',
                color = G.C.DARK_EDITION
			}
		end
	end
}

SMODS.Joker {
	key = 'hyperoperation',
	loc_txt = {
		name = 'Hyperoperation',
		text = {
			"{C:chips}+#2#{} Chips",
			"{X:dark_edition,C:edition}#3#250#4##1#{} all values of this joker at the end of round",
			"including this value"
		}
	},
	config = { extra = { mod = 2, chips = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mod, card.ability.extra.chips, '{', '}' } }
	end,
	rarity = 'r_beyond_cracked',
	atlas = 'placeholders',
	pos = { x = 11, y = 0 },
	cost = 1000000,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = '+' .. card.ability.extra.chips .. ' Chips',
                color = G.C.DARK_EDITION
			}
		end
		if context.end_of_round and context.cardarea == G.jokers then
			card.ability.extra.chips = to_big(card.ability.extra.chips):arrow(250, card.ability.extra.mod)
			card.ability.extra.mod = to_big(card.ability.extra.mod):arrow(250, card.ability.extra.mod)
			return {
				message = 'Upgraded!',
                color = G.C.DARK_EDITION,
			}
		end
	end
}

SMODS.Joker {
	key = 'incrementer',
	loc_txt = {
		name = 'Incrementer',
		text = {
			'Gains {C:chips}+#2#{} Chips and {C:mult}+#6#{} Mult {C:attention}every frame{}',
			'Increases operator for Chips by {X:dark_edition,C:white}+#4#{} and for Mult by {X:dark_edition,C:white}+#8#{}',
			'when {C:attention}anything{} happens',
			'{C:inactive}(Currently {X:dark_edition,C:white}#9##3##10##1#{C:inactive} Chips and {X:dark_edition,C:white}#9##7##10##5#{C:inactive} Mult)'
		}
	},
	config = { extra = { chips = 0, chips_mod = 1, chips_operator = 1, chips_operator_mod = 1, mult = 0, mult_mod = 1, mult_operator = 1, mult_operator_mod = 1, '{', '}' } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chips_mod, card.ability.extra.chips_operator, card.ability.extra.chips_operator_mod, card.ability.extra.mult, card.ability.extra.mult_mod, card.ability.extra.mult_operator, card.ability.extra.mult_operator_mod, '{', '}'} }
	end,
	rarity = 'r_beyond_cracked',
	atlas = 'placeholders',
	pos = { x = 11, y = 0 },
	cost = 1000000,
	update = function(self, card, dt)
		card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
		card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
	end,
	calculate = function(self, card, context)
		if context.before
		or context.main_scoring
		or context.pre_joker
		or context.other_joker
		or context.post_joker
		or context.debuffed_hand
		or context.setting_blind
		or context.pre_discard
		or context.discard
		or context.open_booster
		or context.skipping_booster
		or context.selling_card
		or context.reroll_shop
		or context.ending_shop
		or context.first_hand_drawn
		or context.hand_drawn
		or context.using_consumeable
		or context.skip_blind
		or context.playing_card_added
		or context.card_added
		or context.ending_booster
		or context.blind_disabled
		or context.blind_defeated
		or context.press_play
		then
			card.ability.extra.chips_operator = card.ability.extra.chips_operator + card.ability.extra.chips_operator_mod
			card.ability.extra.mult_operator = card.ability.extra.mult_operator + card.ability.extra.mult_operator_mod
			return {
				message = 'Upgrade!',
				colour = G.C.DARK_EDITION,
				card = card
			}
		end
		if context.joker_main then
			return {
				hyperchip_mod = {card.ability.extra.chips_operator, card.ability.extra.chips},
				message = '{' .. card.ability.extra.chips_operator .. '}' .. card.ability.extra.chips .. ' Chips',
                color = G.C.DARK_EDITION,
				extra = {
					hypermult_mod = {card.ability.extra.mult_operator, card.ability.extra.mult},
					message = '{' .. card.ability.extra.mult_operator .. '}' .. card.ability.extra.mult .. ' Mult',
            	    color = G.C.DARK_EDITION
				}
			}
		end
	end
}


SMODS.Joker {
	key = 'multiverse',
	loc_txt = {
		name = 'The Fucking Multiverse Itself',
		text = {
			"When a hand is played, played poker hand gains",
			"{X:edition,C:white}#2#X#3#2{} Chips, Mult, Level Chips, and Level Mult",
			"where X is the amount of times poker hand has been played"
		}
	},
	config = { extra = { power = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.power, '{', '}' } }
	end,
	rarity = 'r_beyond_cracked',
	atlas = 'placeholders',
	pos = { x = 11, y = 0 },
	cost = 1000000,
	calculate = function(self, card, context)
		if context.before then
			--update_hand_text(
			--	{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
			--	{ handname = G.GAME.hands[context.scoring_name], chips = G.GAME.hands[context.scoring_name].chips, mult = G.GAME.hands[context.scoring_name].mult, level = G.GAME.hands[context.scoring_name].level }
			--)
			--G.E_MANAGER:add_event(Event({
			--	trigger = "after",
			--	delay = 0.2,
			--	func = function()
			--		play_sound("tarot1")
			--		self:juice_up(0.8, 0.5)
			--		return true
			--	end,
			--}))
			--update_hand_text({ delay = 0 }, { mult = '{' .. G.GAME.hands[context.scoring_name].played .. '}' .. card.ability.extra.power, StatusText = true })
			--G.E_MANAGER:add_event(Event({
			--	trigger = "after",
			--	delay = 0.9,
			--	func = function()
			--		play_sound("tarot1")
			--		self:juice_up(0.8, 0.5)
			--		return true
			--	end,
			--}))
			--update_hand_text({ delay = 0 }, { mult = '{' .. G.GAME.hands[context.scoring_name].played .. '}' .. card.ability.extra.power, StatusText = true })
			--G.E_MANAGER:add_event(Event({
			--	trigger = "after",
			--	delay = 0.9,
			--	func = function()
			--		play_sound("tarot1")
			--		self:juice_up(0.8, 0.5)
			--		return true
			--	end,
			--}))
			--delay(1.3)
				G.GAME.hands[context.scoring_name].chips = G.GAME.hands[context.scoring_name].chips:arrow(G.GAME.hands[context.scoring_name].played, card.ability.extra.power)
				G.GAME.hands[context.scoring_name].mult = G.GAME.hands[context.scoring_name].mult:arrow(G.GAME.hands[context.scoring_name].played, card.ability.extra.power)
				G.GAME.hands[context.scoring_name].l_chips = G.GAME.hands[context.scoring_name].l_chips:arrow(G.GAME.hands[context.scoring_name].played, card.ability.extra.power)
				G.GAME.hands[context.scoring_name].l_mult = G.GAME.hands[context.scoring_name].l_mult:arrow(G.GAME.hands[context.scoring_name].played, card.ability.extra.power)
			--update_hand_text(
			--	{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
			--	{ mult = 0, chips = 0, handname = "", level = "" }
			--)
		end
	end
}


SMODS.Joker {
	key = 'insignificance',
	loc_txt = {
		name = 'Insignificance',
		text = {
			"Blind size is always {C:dark_edition,s:10}1{}"
		}
	},
	config = { extra = { chips = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	rarity = 'r_beyond_cracked',
	atlas = 'placeholders',
	pos = { x = 11, y = 0 },
	cost = 1000000,
	calculate = function(self, card, context)
		if context.setting_blind then
            G.GAME.blind.chips = 1
		end
	end
}

SMODS.Joker {
	key = 'economical_crash',
	loc_txt = {
		name = 'The Economical Crash',
		text = {
			"Allows you to go into {X:dark_edition,C:white}infinite{} debt",
			"{C:green}All rerolls are free{}",
			"{C:inactive}crustulum 2{}"
		}
	},
	config = { extra = { chips = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips } }
	end,
	rarity = 'r_beyond_cracked',
	atlas = 'placeholders',
	pos = { x = 11, y = 0 },
	cost = 1000000,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - math.huge
        SMODS.change_free_rerolls(math.huge)
	end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + math.huge
        SMODS.change_free_rerolls(-math.huge)
	end
}
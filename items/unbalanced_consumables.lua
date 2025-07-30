-- atlas dump

SMODS.Atlas {
    key = "unbalanced_consumables",
    path = "unbalanced_consumables.png",
    px = 71,
    py = 95
}

-- unbalanced shits type

SMODS.ConsumableType {
    key = 'unbalanced_tarot',
    shader = 'tarot',
    primary_colour = HEX('666666'),
    secondary_colour = HEX('666666'),
    collection_rows = { 4, 5 },
    shop_rate = 0.1,
    loc_txt = {
        name = "Unbalanced Tarots",
        collection = "Unbalanced Tarot Cards",
    }
}

SMODS.ConsumableType {
    key = 'unbalanced_planet',
    shader = 'tarot',
    primary_colour = HEX('006B72'),
    secondary_colour = HEX('006B72'),
    collection_rows = { 4, 5 },
    shop_rate = 0.1,
    loc_txt = {
        name = "Unbalanced Planets",
        collection = "Unbalanced Planet Cards",
    }
}

SMODS.ConsumableType {
    key = 'unbalanced_spectral',
    shader = 'tarot',
    primary_colour = HEX('02004A'),
    secondary_colour = HEX('02004A'),
    collection_rows = { 4, 5 },
    shop_rate = 0.1,
    loc_txt = {
        name = "Unbalanced Spectrals",
        collection = "Unbalanced Spectral Cards",
    }
}

-- unbalanced enhancements pool
local unbalanced_enhancements_pool = {
	m_r_unbalanced_bonus = "m_r_unbalanced_bonus",
	m_r_unbalanced_glass = "m_r_unbalanced_glass",
	m_r_unbalanced_gold = "m_r_unbalanced_gold",
	m_r_unbalanced_lucky = "m_r_unbalanced_lucky",
	m_r_unbalanced_mult = "m_r_unbalanced_mult",
	m_r_unbalanced_steel = "m_r_unbalanced_steel",
	m_r_unbalanced_stone = "m_r_unbalanced_stone",
	m_r_unbalanced_wild = "m_r_unbalanced_wild"
}


-- unbalanced tarots
SMODS.Consumable {
	key = 'unbalanced_hermit',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Hermit',
		text = {
			'Become {X:edition,C:dark_edition}infinitely wealthy{}'
		}
	},
	pos = { x = 9, y = 0 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
    loc_vars = function(self, info_queue, center)
        return {vars = { } }
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		ease_dollars(math.huge)
	end
}

--SMODS.Consumable {
--	key = 'unbalanced_temperance',
--	set = 'unbalanced_tarot',
--	loc_txt = {
--		name = 'The Unbalanced Temperance',
--		text = {
--			'All jokers and consumables gain {X:money,C:dark_edition}^#1#${} sell value'
--		}
--	},
--	config = {
--        powersell = 2
--    },
--	pos = { x = 4, y = 1 },
--	cost = 50,
--	unlocked = true,
--	discovered = true,
--	atlas = 'unbalanced_consumables',
--    loc_vars = function(self, info_queue, center)
--        return {vars = { self.config.powersell } }
--    end,
--	--hidden = true,
--    --soul_rate = 0.0001,
--    --soul_set = 'Tarot',
--	can_use = function(self, card)
--		return true
--	end,
--	use = function(self, card, area, copier)
--        for _, area in ipairs({ G.jokers, G.consumeables }) do
--        	for i, other_card in ipairs(area.cards) do
--        	    if other_card.set_cost then
--        	        other_card.ability.extra_value = (other_card.ability.extra_value) + ((function() local total = 0; for _, joker in ipairs(G.jokers.cards) do total = total + joker.sell_cost end; return total end)()) ^ self.config.powersell
--        	        other_card:set_cost()
--        	    end
--			end
--        end
--	end
--}

SMODS.Consumable {
	key = 'unbalanced_magician',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Magician',
		text = {
			'Enhances up to {C:attention}#1#{} selected card into an',
			'{C:attention}Unbalanced Lucky Card{}',
			'Enhances every other card in deck into {C:attention}Lucky Cards{}',
			'{C:inactive}(Does not affect other Unbalanced Enhanced Cards){}'
		}
	},
	config = {
        max_highlighted = 1
    },
	pos = { x = 1, y = 0 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if not SMODS.get_enhancements(v) == unbalanced_enhancements_pool then
				if v.area == G.hand then
					Q(function() v:set_ability('m_lucky') play_sound('tarot1') v:juice_up(1, 0.5) return true end, 0.75)
				else
					v:set_ability('m_lucky')
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(1, 0.5)
                return true end }))
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
                 G.hand.highlighted[i]:set_ability('m_r_unbalanced_lucky')
                return true end }))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}


SMODS.Consumable {
	key = 'unbalanced_death',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Death',
		text = {
			'Select {C:attention}#1#{} card, all cards in deck are converted to that card'
		}
	},
	config = {
        max_highlighted = 1
    },
	pos = { x = 3, y = 1 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	use = function(self, card, area, copier)
        for i=1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
			for k, v in ipairs(G.playing_cards) do
        	    G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
        	        copy_card(G.hand.highlighted[i], v) play_sound('tarot1') v:juice_up(1, 0.5) return true end, 0.75}))
				end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
		end
    end
}

--SMODS.Consumable {
--	key = 'unbalanced_hanged_man',
--	set = 'unbalanced_tarot',
--	loc_txt = {
--		name = 'The Unbalanced Hanged Man',
--		text = {
--			'Select {C:attention}#1#{} card, destroys all cards in deck that',
--			'share the same rank or suit as this card'
--		}
--	},
--	config = {
--        max_highlighted = 1
--    },
--	pos = { x = 2, y = 1 },
--	cost = 50,
--	unlocked = true,
--	discovered = true,
--	hidden = true,
--    soul_rate = 0.0001,
--    soul_set = 'Tarot',
--	atlas = 'unbalanced_consumables',
--    loc_vars = function(self, info_queue, center, card)
--        return {vars = {self.config.max_highlighted}}
--    end,
--	use = function(self, card, area, copier)
--        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
--            play_sound('tarot1')
--            return true end }))
--        for i=1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
--			for k, v in pairs(G.playing_cards) do
--				if G.hand.highlighted[i].base.suit == v.base.suit or G.hand.highlighted[i].base.id == v.base.id then
--        			destroyed_cards = v
--        			G.E_MANAGER:add_event(Event({
--        			    trigger = 'after',
--        			    delay = 0.1,
--        			    func = function() 
--        			        local card = destroyed_cards
--        			        if card.ability.name == 'Glass Card' then 
--        			            card:shatter()
--        			        else
--        			            card:start_dissolve(nil, i ~= #destroyed_cards)
--        			        end
--        			        return true end }))
--						end
--					end
--				end
--        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
--    end
--}

SMODS.Consumable {
	key = 'unbalanced_justice',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Justice',
		text = {
			'Enhances up to {C:attention}#1#{} selected card into an',
			'{C:attention}Unbalanced Glass Card{}',
			'Enhances every other card in deck into {C:attention}Glass Cards{}',
			'{C:inactive}(Does not affect other Unbalanced Enhanced Cards){}'
		}
	},
	config = {
        max_highlighted = 1
    },
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
	pos = { x = 8, y = 0 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if not SMODS.get_enhancements(v)[unbalanced_enhancements_pool] == true then
				if v.area == G.hand then
					Q(function() v:set_ability('m_glass') play_sound('tarot1') v:juice_up(1, 0.5) return true end, 0.75)
				else
					v:set_ability('m_glass')
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(1, 0.5)
                return true end }))
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
                 G.hand.highlighted[i]:set_ability('m_r_unbalanced_glass')
                return true end }))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}



SMODS.Consumable {
	key = 'unbalanced_chariot',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Chariot',
		text = {
			'Enhances up to {C:attention}#1#{} selected card into an',
			'{C:attention}Unbalanced Steel Card{}',
			'Enhances every other card in deck into {C:attention}Steel Cards{}',
			'{C:inactive}(Does not affect other Unbalanced Enhanced Cards){}'
		}
	},
	config = {
        max_highlighted = 1
    },
	pos = { x = 7, y = 0 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if not SMODS.get_enhancements(v)[unbalanced_enhancements_pool] == true then
				if v.area == G.hand then
					Q(function() v:set_ability('m_steel') play_sound('tarot1') v:juice_up(1, 0.5) return true end, 0.75)
				else
					v:set_ability('m_steel')
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(1, 0.5)
                return true end }))
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
                 G.hand.highlighted[i]:set_ability('m_r_unbalanced_steel')
                return true end }))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}


SMODS.Consumable {
	key = 'unbalanced_devil',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Devil',
		text = {
			'Enhances up to {C:attention}#1#{} selected card into an',
			'{C:attention}Unbalanced Gold Card{}',
			'Enhances every other card in deck into {C:attention}Gold Cards{}',
			'{C:inactive}(Does not affect other Unbalanced Enhanced Cards){}'
		}
	},
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
	config = {
        max_highlighted = 1
    },
	pos = { x = 5, y = 1 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if SMODS.get_enhancements(v)[unbalanced_enhancements_pool] == true then
				if v.area == G.hand then
					Q(function() v:set_ability('m_gold') play_sound('tarot1') v:juice_up(1, 0.5) return true end, 0.75)
				else
					v:set_ability('m_gold')
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(1, 0.5)
                return true end }))
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
                 G.hand.highlighted[i]:set_ability('m_r_unbalanced_gold')
                return true end }))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}


SMODS.Consumable {
	key = 'unbalanced_empress',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Empress',
		text = {
			'Enhances up to {C:attention}#1#{} selected card into an',
			'{C:attention}Unbalanced Mult Card{}',
			'Enhances every other card in deck into {C:attention}Mult Cards{}',
			'{C:inactive}(Does not affect other Unbalanced Enhanced Cards){}'
		}
	},
	config = {
        max_highlighted = 1
    },
	pos = { x = 3, y = 0 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if SMODS.get_enhancements(v)[unbalanced_enhancements_pool] == true then
				if v.area == G.hand then
					Q(function() v:set_ability('m_mult') play_sound('tarot1') v:juice_up(1, 0.5) return true end, 0.75)
				else
					v:set_ability('m_mult')
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(1, 0.5)
                return true end }))
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
                 G.hand.highlighted[i]:set_ability('m_r_unbalanced_mult')
                return true end }))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}


SMODS.Consumable {
	key = 'unbalanced_hierophant',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Hierophant',
		text = {
			'Enhances up to {C:attention}#1#{} selected card into an',
			'{C:attention}Unbalanced Bonus Card{}',
			'Enhances every other card in deck into {C:attention}Bonus Cards{}',
			'{C:inactive}(Does not affect other Unbalanced Enhanced Cards){}'
		}
	},
	config = {
        max_highlighted = 1
    },
	pos = { x = 5, y = 0 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if SMODS.get_enhancements(v)[unbalanced_enhancements_pool] == true then
				if v.area == G.hand then
					Q(function() v:set_ability('m_bonus') play_sound('tarot1') v:juice_up(1, 0.5) return true end, 0.75)
				else
					v:set_ability('m_bonus')
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(1, 0.5)
                return true end }))
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.5,func = function()
                 G.hand.highlighted[i]:set_ability('m_r_unbalanced_bonus')
                return true end }))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}

SMODS.Consumable {
	key = 'unbalanced_wheel',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Wheel of Fortune',
		text = {
			'All jokers and playing cards become any edition'
		}
	},
	pos = { x = 0, y = 1 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
    loc_vars = function(self, info_queue, center)
        return {vars = { } }
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.jokers.cards) do
            edition = poll_edition('unbalanced_wheel_of_fortune', nil, false, true)
            v:set_edition(edition, true)
		end
		for k, v in ipairs(G.playing_cards) do
            edition = poll_edition('unbalanced_wheel_of_fortune', nil, false, true)
            v:set_edition(edition, true)
		end
	end
}

SMODS.Consumable {
	key = 'unbalanced_priestess',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Priestess',
		text = {
			'Creates {C:attention}#1# Black Holes{}',
			'{C:attention}1 in 5{} chance to create {C:attention}#2# Unbalanced Planet Cards{} instead',
			'{C:attention}1 in 10{} chance to create {C:attention}#3# Unbalanced Black Hole{} instead'
		}
	},
	config = {
        black_holes = 5,
		planets = 2,
		unbalanced_black_holes = 1
    },
	pos = { x = 2, y = 0 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
    loc_vars = function(self, info_queue, center)
        return {vars = { self.config.black_holes, self.config.planets, self.config.unbalanced_black_holes } }
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		if math.random(0, 10) <= 2 then
			for i=1, self.config.planets do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					local card2 = create_card('unbalanced_planet', G.consumeables, nil, nil, nil, nil, nil, 'planetary_planets')
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
					return true
				end }))
			end
		else if math.random(0, 10) <= 1 then
			for i=1, self.config.unbalanced_black_holes do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_r_unbalanced_black_hole', 'planetary_planets')
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
					return true
				end }))
			end
		else
			for i=1, self.config.black_holes do
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'planetary_planets')
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
					return true
				end }))
			end
		end
	end
	end
}


SMODS.Consumable {
	key = 'unbalanced_lovers',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Lovers',
		text = {
			'Enhances all cards in deck into {C:attention}Unbalanced Wild Cards{}',
			'{C:inactive}(Does not affect other Unbalanced Enhanced Cards){}'
		}
	},
	config = {
    },
	pos = { x = 6, y = 0 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {  }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if SMODS.get_enhancements(v)[unbalanced_enhancements_pool] == true then
				if v.area == G.hand then
					Q(function() v:set_ability('m_r_unbalanced_wild') play_sound('tarot1') v:juice_up(1, 0.5) return true end, 0.75)
				else
					v:set_ability('m_r_unbalanced_wild')
				end
			end
		end
    end
}


SMODS.Consumable {
	key = 'unbalanced_tower',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Tower',
		text = {
			'Enhances all cards in deck into {C:attention}Unbalanced Stone Cards{}',
			'{C:inactive}(Does not affect other Unbalanced Enhanced Cards){}'
		}
	},
	config = {
    },
	pos = { x = 6, y = 1 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {  }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if SMODS.get_enhancements(v)[unbalanced_enhancements_pool] == true then
				if v.area == G.hand then
					Q(function() v:set_ability('m_r_unbalanced_stone') play_sound('tarot1') v:juice_up(1, 0.5) return true end, 0.75)
				else
					v:set_ability('m_r_unbalanced_stone')
				end
			end
		end
    end
}

SMODS.Consumable {
	key = 'unbalanced_judgement',
	set = 'unbalanced_tarot',
	loc_txt = {
		name = 'The Unbalanced Judgement',
		text = {
			'Select {C:attention}#1#{} Joker, create {C:attention}#2# Jokers{}',
            'of the same rarity'
		}
	},
	config = {
        max_highlighted = 1,
		jokers = 5,
    },
	pos = { x = 0, y = 2 },
	cost = 50,
	unlocked = true,
	discovered = true,
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Tarot',
	atlas = 'unbalanced_consumables',
    loc_vars = function(self, info_queue, center)
        return {vars = { self.config.max_highlighted, self.config.jokers } }
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
        for i = 1, math.min(#G.jokers.highlighted, self.config.max_highlighted) do
            for j = 1, self.config.jokers do
			    G.E_MANAGER:add_event(Event({func = function()
			    	local card1 = create_card('Joker', G.jokers, nil, G.jokers.highlighted[i].config.center.rarity, nil, nil, nil, 'unbalance_my_judgements')
			    	card1:add_to_deck()
			    	G.jokers:emplace(card1)
			    	card1:juice_up(0.3, 0.5)
			    	return true
			    end }))
            end
        end
	end
}

-- unbalanced planets

SMODS.Consumable {
	key = 'unbalanced_pluto',
	set = 'unbalanced_planet',
	loc_txt = {
		name = 'The Unbalanced Pluto',
		text = {
			'{X:dark_edition, C:edition}^#1#{} to all High Card values',
			'{C:inactive}(Chips, Mult, Level Chips, Level Mult, and Level){}'
		}
	},
	config = {
		power = 2,
		hand = "High Card"
    },
	pos = { x = 8, y = 3 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Planet',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.power, self.config.hand }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		G.GAME.hands[self.config.hand].chips = G.GAME.hands[self.config.hand].chips ^ self.config.power
		G.GAME.hands[self.config.hand].mult = G.GAME.hands[self.config.hand].mult ^ self.config.power
		G.GAME.hands[self.config.hand].l_chips = G.GAME.hands[self.config.hand].l_chips ^ self.config.power
		G.GAME.hands[self.config.hand].l_mult = G.GAME.hands[self.config.hand].l_mult ^ self.config.power
		G.GAME.hands[self.config.hand].level = G.GAME.hands[self.config.hand].level ^ self.config.power
    end
}

SMODS.Consumable {
	key = 'unbalanced_mercury',
	set = 'unbalanced_planet',
	loc_txt = {
		name = 'The Unbalanced Mercury',
		text = {
			'{X:dark_edition, C:edition}^#1#{} to all Pair values',
			'{C:inactive}(Chips, Mult, Level Chips, Level Mult, and Level){}'
		}
	},
	config = {
		power = 2,
		hand = "Pair"
    },
	pos = { x = 0, y = 3 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Planet',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.power, self.config.hand }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		G.GAME.hands[self.config.hand].chips = G.GAME.hands[self.config.hand].chips ^ self.config.power
		G.GAME.hands[self.config.hand].mult = G.GAME.hands[self.config.hand].mult ^ self.config.power
		G.GAME.hands[self.config.hand].l_chips = G.GAME.hands[self.config.hand].l_chips ^ self.config.power
		G.GAME.hands[self.config.hand].l_mult = G.GAME.hands[self.config.hand].l_mult ^ self.config.power
		G.GAME.hands[self.config.hand].level = G.GAME.hands[self.config.hand].level ^ self.config.power
    end
}

SMODS.Consumable {
	key = 'unbalanced_jupiter',
	set = 'unbalanced_planet',
	loc_txt = {
		name = 'The Unbalanced Jupiter',
		text = {
			'{X:dark_edition, C:edition}^#1#{} to all Flush values',
			'{C:inactive}(Chips, Mult, Level Chips, Level Mult, and Level){}'
		}
	},
	config = {
		power = 2,
		hand = "Flush"
    },
	pos = { x = 4, y = 3 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Planet',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.power, self.config.hand }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		G.GAME.hands[self.config.hand].chips = G.GAME.hands[self.config.hand].chips ^ self.config.power
		G.GAME.hands[self.config.hand].mult = G.GAME.hands[self.config.hand].mult ^ self.config.power
		G.GAME.hands[self.config.hand].l_chips = G.GAME.hands[self.config.hand].l_chips ^ self.config.power
		G.GAME.hands[self.config.hand].l_mult = G.GAME.hands[self.config.hand].l_mult ^ self.config.power
		G.GAME.hands[self.config.hand].level = G.GAME.hands[self.config.hand].level ^ self.config.power
    end
}


-- the unbalanced spectrals
SMODS.Consumable {
	key = 'unbalanced_grim',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Grim',
		text = {
			'Destroy your entire deck',
			'For each card destroyed, create {C:attention}#1#{} random {C:attention}Enhanced Aces{}'
		}
	},
	config = {
		aces = 2
    },
	pos = { x = 1, y = 4 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.aces }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local number_of_cards = #G.playing_cards
        destroyed_cards = G.playing_cards
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#destroyed_cards, 1, -1 do
                    local card = destroyed_cards[i]
                    if card.ability.name == 'Glass Card' then 
                        card:shatter()
                    else
                        card:start_dissolve(nil, i ~= #destroyed_cards)
                    end
                end
                return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function() 
                local cards = {}
                for i=1, number_of_cards * self.config.aces do
                    cards[i] = true
                    local _suit, _rank = nil, nil
                        _rank = 'A'
                        _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('grim_create'))
                    _suit = _suit or 'S'; _rank = _rank or 'A'
                    local cen_pool = {}
                    for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if v.key ~= 'm_stone' then 
                            cen_pool[#cen_pool+1] = v
                        end
                    end
                    create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))}, G.hand, nil, i ~= 1, {G.C.SECONDARY_SET.Spectral})
                end
                playing_card_joker_effects(cards)
                return true end }))
    end
}

SMODS.Consumable {
	key = 'unbalanced_familiar',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Familiar',
		text = {
			'Destroy your entire deck',
			'For each card destroyed, create {C:attention}#1#{} random {C:attention}Enhanced Face Cards{}',
		}
	},
	config = {
		faces = 3
    },
	pos = { x = 0, y = 4 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.faces }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local number_of_cards = #G.playing_cards
        destroyed_cards = G.playing_cards
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#destroyed_cards, 1, -1 do
                    local card = destroyed_cards[i]
                    if card.ability.name == 'Glass Card' then 
                        card:shatter()
                    else
                        card:start_dissolve(nil, i ~= #destroyed_cards)
                    end
                end
                return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function() 
                local cards = {}
                for i=1, number_of_cards * self.config.faces do
                    cards[i] = true
                    local _suit, _rank = nil, nil
					_rank = pseudorandom_element({'K','Q','J'}, pseudoseed('grim_create'))
                        _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('grim_create'))
                    _suit = _suit or 'S'; _rank = _rank or 'K'
                    local cen_pool = {}
                    for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if v.key ~= 'm_stone' then 
                            cen_pool[#cen_pool+1] = v
                        end
                    end
                    create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))}, G.hand, nil, i ~= 1, {G.C.SECONDARY_SET.Spectral})
                end
                playing_card_joker_effects(cards)
                return true end }))
    end
}

SMODS.Consumable {
	key = 'unbalanced_incantation',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Incantation',
		text = {
			'Destroy your entire deck',
			'For each card destroyed, create {C:attention}#1#{} random {C:attention}Enhanced Numbered Cards{}',
		}
	},
	config = {
		numbers = 4
    },
	pos = { x = 2, y = 4 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.numbers }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local number_of_cards = #G.playing_cards
        destroyed_cards = G.playing_cards
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#destroyed_cards, 1, -1 do
                    local card = destroyed_cards[i]
                    if card.ability.name == 'Glass Card' then 
                        card:shatter()
                    else
                        card:start_dissolve(nil, i ~= #destroyed_cards)
                    end
                end
                return true end }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.7,
            func = function() 
                local cards = {}
                for i=1, number_of_cards * self.config.numbers do
                    cards[i] = true
                    local _suit, _rank = nil, nil
                    _rank = pseudorandom_element({'T','9','8','7','6','5','4','3','2'}, pseudoseed('grim_create'))
                    _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('grim_create'))
                    _suit = _suit or 'S'; _rank = _rank or 'T'
                    local cen_pool = {}
                    for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                        if v.key ~= 'm_stone' then 
                            cen_pool[#cen_pool+1] = v
                        end
                    end
                    create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))}, G.hand, nil, i ~= 1, {G.C.SECONDARY_SET.Spectral})
                end
                playing_card_joker_effects(cards)
                return true end }))
    end
}


SMODS.Consumable {
	key = 'unbalanced_talisman',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Talisman',
		text = {
			'Applies {C:attention}Unbalanced Gold Seal{} to up to {C:attention}#1#{} selected card',
			'Applies {C:attention}Gold Seal{} to every other card in deck',
			'{C:inactive}(Does not affect other Unbalanced Sealed Cards){}'
		}
	},
	config = {
        max_highlighted = 1
    },
	pos = { x = 3, y = 4 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if SMODS.get_enhancements(v)[unbalanced_seals_pool] == false then
				if v.area == G.hand then
            		G.E_MANAGER:add_event(Event({func = function()
            		    play_sound('tarot1')
            		    card:juice_up(0.3, 0.5)
            		    G.hand.highlighted[i]:set_seal('Gold', false, true)
            		    return true end
					}))
				else
                G.hand.highlighted[i]:set_seal('Gold', false, true)
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            		G.E_MANAGER:add_event(Event({func = function()
            		    play_sound('tarot1')
            		    card:juice_up(0.3, 0.5)
            		    G.hand.highlighted[i]:set_seal('r_unbalanced_gold_seal', false, true)
            		    return true end
					}))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}

SMODS.Consumable {
	key = 'unbalanced_immolate',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Immolate',
		text = {
			'Select {C:attention}any number of cards{} to destroy',
			'For each card destroyed, gain {C:money}+#1#${}, {C:attention}+#2# Joker slots,',
			'{C:attention}+#3#{} Consumable Slots, and {C:attention}+#4# Hand Size',
		}
	},
	config = {
        money = 50,
        joker_slots = 5,
        consumable_slots = 5,
        hand_size = 5,
    },
	pos = { x = 9, y = 4 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.money, self.config.joker_slots, self.config.consumable_slots, self.config.hand_size }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
        destroyed_cards = G.hand.highlighted
        for i = 1, math.min(#G.hand.highlighted, 2000000) do
        	G.E_MANAGER:add_event(Event({
        	    trigger = 'after',
        	    delay = 0.1,
        	    func = function() 
        	        for i=#destroyed_cards, 1, -1 do
        	            local card = destroyed_cards[i]
        	            if card.ability.name == 'Glass Card' then 
        	                card:shatter()
        	            else
        	                card:start_dissolve(nil, i ~= #destroyed_cards)
        	            end
        	        end
        	        return true end }))
			ease_dollars(self.config.money)
            G.jokers.config.card_limit = G.jokers.config.card_limit + self.config.joker_slots
            G.consumeables.config.card_limit = G.consumeables.config.card_limit + self.config.consumable_slots
            G.hand:change_size(self.config.hand_size)
        end
    end
}

SMODS.Consumable {
	key = 'unbalanced_ankh',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Ankh',
		text = {
			'Select {C:attention}#1#{} Joker, creates {C:attention}#2#{} {C:edition}Negative{} copies of it',
		}
	},
	config = {
        max_highlighted = 1,
		copies = 10,
    },
	pos = { x = 0, y = 5 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.max_highlighted, self.config.copies }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
        for i = 1, math.min(#G.jokers.highlighted, self.config.max_highlighted) do
            for j = 1, self.config.copies do
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local copied_joker = copy_card(G.jokers.highlighted[i], nil, nil, nil, G.jokers.highlighted[i].edition and G.jokers.highlighted[i].edition.negative)
                    	copied_joker:set_edition("e_negative", true)
                        copied_joker:add_to_deck()
                        G.jokers:emplace(copied_joker)
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Consumable {
	key = 'unbalanced_deja_vu',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Deja Vu',
		text = {
			'Applies {C:attention}Unbalanced Red Seal{} to up to {C:attention}#1#{} selected card',
			'Applies {C:attention}Red Seal{} to every other card in deck',
			'{C:inactive}(Does not affect other Unbalanced Sealed Cards){}'
		}
	},
	config = {
        max_highlighted = 1
    },
	pos = { x = 1, y = 5 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if SMODS.get_enhancements(v)[unbalanced_seals_pool] == false then
				if v.area == G.hand then
            		G.E_MANAGER:add_event(Event({func = function()
            		    play_sound('tarot1')
            		    card:juice_up(0.3, 0.5)
            		    G.hand.highlighted[i]:set_seal('Red', false, true)
            		    return true end
					}))
				else
                G.hand.highlighted[i]:set_seal('Red', false, true)
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            		G.E_MANAGER:add_event(Event({func = function()
            		    play_sound('tarot1')
            		    card:juice_up(0.3, 0.5)
            		    G.hand.highlighted[i]:set_seal('r_unbalanced_red_seal', false, true)
            		    return true end
					}))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}


SMODS.Consumable {
	key = 'unbalanced_trance',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Trance',
		text = {
			'Applies {C:attention}Unbalanced Blue Seal{} to up to {C:attention}#1#{} selected card',
			'Applies {C:attention}Blue Seal{} to every other card in deck',
			'{C:inactive}(Does not affect other Unbalanced Sealed Cards){}'
		}
	},
	config = {
        max_highlighted = 1
    },
	pos = { x = 3, y = 5 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if SMODS.get_enhancements(v)[unbalanced_seals_pool] == false then
				if v.area == G.hand then
            		G.E_MANAGER:add_event(Event({func = function()
            		    play_sound('tarot1')
            		    card:juice_up(0.3, 0.5)
            		    G.hand.highlighted[i]:set_seal('Blue', false, true)
            		    return true end
					}))
				else
                G.hand.highlighted[i]:set_seal('Blue', false, true)
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            		G.E_MANAGER:add_event(Event({func = function()
            		    play_sound('tarot1')
            		    card:juice_up(0.3, 0.5)
            		    G.hand.highlighted[i]:set_seal('r_unbalanced_blue_seal', false, true)
            		    return true end
					}))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}


SMODS.Consumable {
	key = 'unbalanced_medium',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Medium',
		text = {
			'Applies {C:attention}Unbalanced Purple Seal{} to up to {C:attention}#1#{} selected card',
			'Applies {C:attention}Purple Seal{} to every other card in deck',
			'{C:inactive}(Does not affect other Unbalanced Sealed Cards){}'
		}
	},
	config = {
        max_highlighted = 1
    },
	pos = { x = 4, y = 5 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {self.config.max_highlighted}}
    end,
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
		for k, v in ipairs(G.playing_cards) do
			if SMODS.get_enhancements(v)[unbalanced_seals_pool] == false then
				if v.area == G.hand then
            		G.E_MANAGER:add_event(Event({func = function()
            		    play_sound('tarot1')
            		    card:juice_up(0.3, 0.5)
            		    G.hand.highlighted[i]:set_seal('Purple', false, true)
            		    return true end
					}))
				else
                G.hand.highlighted[i]:set_seal('Purple', false, true)
				end
			end
		end
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            		G.E_MANAGER:add_event(Event({func = function()
            		    play_sound('tarot1')
            		    card:juice_up(0.3, 0.5)
            		    G.hand.highlighted[i]:set_seal('r_unbalanced_purple_seal', false, true)
            		    return true end
					}))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}

SMODS.Consumable {
	key = 'unbalanced_cryptid',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Cryptid',
		text = {
			'Select {C:attention}#1#{} Card, creates {C:attention}#2#{} copies of it',
		}
	},
	config = {
        max_highlighted = 1,
		copies = 10,
    },
	pos = { x = 5, y = 5 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.max_highlighted, self.config.copies }}
    end,
	use = function(self, card, area, copier)
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            for j = 1, self.config.copies do
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local copied_card = copy_card(G.hand.highlighted[i], nil, nil, G.playing_card)
                copied_card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, copied_card)
                G.hand:emplace(copied_card)
                copied_card.states.visible = nil
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        copied_card:start_materialize()
                        return true
                    end
                }))
            end
        end
    end
}

SMODS.Consumable {
	key = 'unbalanced_black_hole',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Black Hole',
		text = {
			'{X:dark_edition, C:edition}^#1#{} to all poker hand values',
			'{C:inactive}(Chips, Mult, Level Chips, Level Mult, and Level){}'
		}
	},
	config = {
		power = 4
    },
	pos = { x = 9, y = 3 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.power }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local used_consumable = copier or card
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
					{ handname = localize("k_all_hands"), chips = "...", mult = "...", level = "" }
				)
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.2,
					func = function()
						play_sound("tarot1")
						used_consumable:juice_up(0.8, 0.5)
						G.TAROT_INTERRUPT_PULSE = true
						return true
					end,
				}))
				update_hand_text({ delay = 0 }, { mult = "^" .. self.config.power, StatusText = true })
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.9,
					func = function()
						play_sound("tarot1")
						used_consumable:juice_up(0.8, 0.5)
						return true
					end,
				}))
				update_hand_text({ delay = 0 }, { chips = "^" .. self.config.power, StatusText = true })
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.9,
					func = function()
						play_sound("tarot1")
						used_consumable:juice_up(0.8, 0.5)
						G.TAROT_INTERRUPT_PULSE = nil
						return true
					end,
				}))
				update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = "^" .. self.config.power })
				delay(1.3)
				for k, v in pairs(G.GAME.hands) do
					G.GAME.hands[k].chips = G.GAME.hands[k].chips ^ self.config.power
					G.GAME.hands[k].mult = G.GAME.hands[k].mult ^ self.config.power
					G.GAME.hands[k].l_chips = G.GAME.hands[k].l_chips ^ self.config.power
					G.GAME.hands[k].l_mult = G.GAME.hands[k].l_mult ^ self.config.power
					G.GAME.hands[k].level = G.GAME.hands[k].level ^ self.config.power
				end
				update_hand_text(
					{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
					{ mult = 0, chips = 0, handname = "", level = "" }
				)
    end
}

SMODS.Consumable {
	key = 'unbalanced_soul',
	set = 'unbalanced_spectral',
	loc_txt = {
		name = 'The Unbalanced Soul',
		text = {
			'Creates a {C:cracked}Cracked Joker{}'
		}
	},
	config = {
        max_highlighted = 1,
		jokers = 5,
    },
	pos = { x = 2, y = 2 },
	soul_pos = { x = 6, y = 5 },
	cost = 50,
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_consumables',
	--hidden = true,
    --soul_rate = 0.0001,
    --soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center)
        return {vars = { } }
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		return {
			G.E_MANAGER:add_event(Event({func = function()
				local card1 = create_card('Joker', G.jokers, nil, 'r_cracked', nil, nil, nil, 'unbalance_my_soules')
				card1:add_to_deck()
				G.jokers:emplace(card1)
				card1:juice_up(0.3, 0.5)
				return true
			end }))
		}
	end
}
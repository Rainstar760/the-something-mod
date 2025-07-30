-- atlas dump

SMODS.Atlas {
    key = "unbalanced_enhancements",
    path = "unbalanced_enhancements.png",
    px = 71,
    py = 95
}

-- all the fucking unbalanced enhancements
SMODS.Enhancement {
	key = 'unbalanced_lucky',
	loc_txt = {
		name = 'Unbalanced Lucky Card',
		text = {
			'{C:attention}1 in 1{} chance for {C:mult}+1000{} Mult',
			'{C:attention}9 in 10{} chance for {C:money}+50${}',
			'{C:attention}4 in 5{} chance for {C:money}+1{C:chips} Planet Card{}',
			'{C:attention}7 in 10{} chance for {C:money}+1{C:attention} Tarot Card{}',
			'{C:attention}3 in 5{} chance for {C:money}+1{C:attention} Hand Size{}',
			'{C:attention}1 in 2{} chance for {X:chips,C:white}x1000{} Chips',
			'{C:attention}2 in 5{} chance for {C:money}+1{C:attention} Spectral Card{}',
			'{C:attention}3 in 10{} chance for {C:money}+1{C:attention} Joker Slot{}',
			'{C:attention}2 in 5{} chance for {C:money}+1{C:attention} Consumable Slot{}',
			'{C:attention}1 in 10{} chance for {C:money}+1{C:attention} Joker{}',
			'{C:attention}1 in 20{} chance for {C:money}+1{C:attention} Soul{}',
		}
	},
	config = {mult = 1000},
	pos = { x = 4, y = 1 },
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_enhancements',
    loc_vars = function(self, info_queue, center)
        return {vars = {  } }
    end,
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			if math.random(0, 100) <= 90 then
				ease_dollars(50)
			end
			if math.random(0, 100) <= 80 then
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					local card2 = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'planetary_planets')
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
					return true
				end }))
			end
			if math.random(0, 100) <= 70 then
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					local card2 = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'tarotary_tarots')
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
					return true
				end }))
			end
			if math.random(0, 100) <= 60 then
				G.hand:change_size(1)
			end
			if math.random(0, 100) <= 50 then
				Xchip_mod = 1000
			end
			if math.random(0, 100) <= 40 then
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, nil, 'spectralized_spectrals')
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
					return true
				end }))
			end
			if math.random(0, 100) <= 30 then
				G.jokers.config.card_limit = G.jokers.config.card_limit + 1
			end
			if math.random(0, 100) <= 20 then
				G.consumeables.config.card_limit = G.consumeables.config.card_limit + 1
			end
			if math.random(0, 100) <= 10 then
				return {
					G.E_MANAGER:add_event(Event({func = function()
						local card1 = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'jokered_jokers')
						card1:add_to_deck()
						G.jokers:emplace(card1)
						card1:juice_up(0.3, 0.5)
						return true
					end }))
				}
			end
			if math.random(0, 100) <= 5 then
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
					local card2 = create_card('Spectral', G.consumeables, nil, nil, nil, nil, 'c_soul', 'la_soule')
					card2:add_to_deck()
					G.consumeables:emplace(card2)
					card:juice_up(0.3, 0.5)
					return true
				end }))
			end
		end
	end
}

SMODS.Enhancement {
	key = 'unbalanced_glass',
	loc_txt = {
		name = 'Unbalanced Glass Card',
		text = {
			'{X:mult, C:white}x#1#{} Mult',
			'{C:attention}never{} breaks'
		}
	},
	config = {x_mult = 200},
	pos = { x = 5, y = 1 },
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_enhancements',
    loc_vars = function(self, info_queue, center)
        return {vars = { self.config.x_mult } }
    end,
	calculate = function(self, card, context)
	end
}

SMODS.Enhancement {
	key = 'unbalanced_steel',
	loc_txt = {
		name = 'Unbalanced Steel Card',
		text = {
			'{X:mult, C:white}x#1#{} Mult when held in hand'
		}
	},
	config = {h_x_mult = 1500},
	pos = { x = 6, y = 1 },
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_enhancements',
    loc_vars = function(self, info_queue, center)
        return {vars = { self.config.h_x_mult } }
    end,
	calculate = function(self, card, context)
	end
}

SMODS.Enhancement {
	key = 'unbalanced_gold',
	loc_txt = {
		name = 'Unbalanced Gold Card',
		text = {
			'Earn {C:money}#1#${} when held in hand',
			'Earn {C:money}#2#${} instead when scored'
		}
	},
	config = {h_dollars = 50, p_dollars = 25},
	pos = { x = 6, y = 0 },
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_enhancements',
    loc_vars = function(self, info_queue, center)
        return {vars = { self.config.h_dollars, self.config.p_dollars } }
    end,
	calculate = function(self, card, context)
	end
}

SMODS.Enhancement {
	key = 'unbalanced_mult',
	loc_txt = {
		name = 'Unbalanced Mult Card',
		text = {
			'{C:mult}+#1#{} Mult',
			'{X:mult, C:white}x#2#{} Mult',
			'{X:dark_edition, C:edition}^#3#{} Mult',
		}
	},
	config = {mult = 4, x_mult = 4, e_mult = 4},
	pos = { x = 2, y = 1 },
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_enhancements',
    loc_vars = function(self, info_queue, center)
        return {vars = { self.config.mult, self.config.x_mult, self.config.e_mult } }
    end,
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			return {
				Emult_mod = self.config.e_mult,
				message = '^' .. self.config.e_mult .. ' Mult',
                color = G.C.DARK_EDITION
			}
		end
	end
}

SMODS.Enhancement {
	key = 'unbalanced_bonus',
	loc_txt = {
		name = 'Unbalanced Bonus Card',
		text = {
			'{C:chip}+#1#{} Chips',
			'{X:chip, C:white}x#2#{} Chips',
			'{X:dark_edition, C:edition}^#3#{} Chips',
		}
	},
	config = {bonus = 4, x_chips = 4, e_chips = 4},
	pos = { x = 1, y = 1 },
	unlocked = true,
	discovered = true,
	atlas = 'unbalanced_enhancements',
    loc_vars = function(self, info_queue, center)
        return {vars = { self.config.bonus, self.config.x_chips, self.config.e_chips } }
    end,
	calculate = function(self, card, context)
		if context.main_scoring and context.cardarea == G.play then
			return {
				Echip_mod = self.config.e_chip,
				message = '^' .. self.config.e_chips .. ' Chips',
                color = G.C.DARK_EDITION
			}
		end
	end
}


SMODS.Enhancement {
	key = 'unbalanced_wild',
	loc_txt = {
		name = 'Unbalanced Wild Card',
		text = {
			'Counts as every suit',
			'{C:attention}Always{} scores',
			--'{C:attention}Cannot be debuffed{}'
		}
	},
	config = {  },
	pos = { x = 3, y = 1 },
	unlocked = true,
	discovered = true,
	any_suit = true,
	always_scores = true,
	atlas = 'unbalanced_enhancements',
    loc_vars = function(self, info_queue, center)
        return {vars = {  } }
    end,
	calculate = function(self, card, context)
	end
}

SMODS.Enhancement {
	key = 'unbalanced_stone',
	loc_txt = {
		name = 'Unbalanced Stone Card',
		text = {
			'{C:chips}+500{} and {X:chips,C:white}x50{} Chips',
			'Has no rank or suit'
		}
	},
	config = { bonus = 500, x_chips = 50 },
	pos = { x = 5, y = 0 },
	unlocked = true,
	discovered = true,
	no_suit = true,
	no_rank = true,
	always_scores = true,
	atlas = 'unbalanced_enhancements',
    loc_vars = function(self, info_queue, center)
        return {vars = { self.config.bonus, self.config.x_chips } }
    end,
	calculate = function(self, card, context)
	end
}

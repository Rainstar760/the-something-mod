-- atlas dump

SMODS.Atlas {
    key = "circleseal_atlas",
    path = "circleseal.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "t4somcjokers_atlas",
    path = "t4somcjokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "pentagon_atlas",
    path = "the_pentagon.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "text_atlas",
    path = "the_text.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "arrow_atlas",
    path = "the_arrow.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "object_atlas",
    path = "the_object.png",
    px = 71,
    py = 95
}

-- gradient s

local shapes_gradient = SMODS.Gradient({
    key="shapes",
    colours = {
        HEX("FF0000"),
        HEX("00FF00"),
        HEX("1010FF"),
        HEX("FF00FF")
    },
	cycle = 5
})

local hexagone = SMODS.Gradient({
    key="shapes",
    colours = {
        HEX("FF00FF"),
    },
	cycle = 1
})

local corrupted_shapes_gradient = SMODS.Gradient({
    key="corrupted_shapes",
    colours = {
        HEX("FFFF00"),
        HEX("00FFFF"),
        HEX("64FF00")
    },
	cycle = 5
})

local core_gradient = SMODS.Gradient({
    key="core",
    colours = {
        HEX("000000")
    },
	cycle = 5
})

-- rarities for. a lot of things actually

SMODS.Rarity({
	key = "shape",
	loc_txt = {
		name = 'Shape'
	},
	badge_colour = shapes_gradient,
	default_weight = 0.175,
	pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
		return weight
	end
})

SMODS.Rarity({
	key = "the_four_shapes",
	loc_txt = {
		name = 'The Four Shapes'
	},
	badge_colour = shapes_gradient,
	pools = { ["Joker"] = true },
})

SMODS.Rarity({
	key = "corrupted_shape",
	loc_txt = {
		name = 'Corrupted Shape'
	},
	badge_colour = corrupted_shapes_gradient,
	pools = { ["Joker"] = true },
})

SMODS.Rarity({
	key = "the_core",
	loc_txt = {
		name = 'The Core'
	},
	badge_colour = core_gradient,
	pools = { ["Joker"] = true },
})

SMODS.Rarity({
	key = "the_object",
	loc_txt = {
		name = 'THE_OBJECT'
	},
	badge_colour = core_gradient,
	pools = { ["Joker"] = true },
})

-- circle seal
SMODS.Seal {
    name = "Circle Seal",
    key = "circleseal",
    badge_colour = HEX("FF0000"),
	config = { mult = 3 },
    loc_txt = {
        label = 'Circle Seal',
        name = 'Circle Seal',
        text = {
            '{C:mult}+#1#{} Mult',
            'Mainly used with {C:mult}Circle Jokers{}'
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = { self.config.mult } }
    end,
    atlas = "circleseal_atlas",
    pos = {x=0, y=0},
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                mult = self.config.mult
            }
        end
    end
}

-- the circles
SMODS.Joker {
	key = 'circle',
	loc_txt = {
		name = '{C:mult}The Circle{}',
		text = {
			"Gains {C:mult}+#2#{} Mult whenever you play anything {C:mult}red{}",
			"(Hearts, Red-Sealed Cards, etc)",
			"{C:mult}Circle-Sealed Hearts{} add {C:mult}+#3#{} Mult instead",
			"{C:inactive}(Currently {C:Mult}+#1#{C:inactive} Mult)"
		}
	},
	config = { extra = { currentmult = 0, multgain = 1, extramultgain = 5 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.currentmult, card.ability.extra.multgain, card.ability.extra.extramultgain } }
	end,
	rarity = 'r_shape',
	atlas = 't4somcjokers_atlas',
	pos = { x = 2, y = 0 },
	cost = 10,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.currentmult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.currentmult } }
			}
		end
        if context.cardarea == G.play and context.individual then
			if context.other_card:is_suit("Hearts") and context.other_card.seal and context.other_card:get_seal() == 'r_circleseal' then
				card.ability.extra.currentmult = card.ability.extra.currentmult + card.ability.extra.extramultgain
                return {
                    extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT }
                }
			elseif context.other_card:is_suit("Hearts") then
				card.ability.extra.currentmult = card.ability.extra.currentmult + card.ability.extra.multgain
				return {
					extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT }
				}
			elseif context.other_card.seal and context.other_card:get_seal() == 'r_circleseal' then
				card.ability.extra.currentmult = card.ability.extra.currentmult + card.ability.extra.multgain
				return {
					extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT }
				}
			elseif context.other_card.seal and context.other_card:get_seal() == 'Red' then
				card.ability.extra.currentmult = card.ability.extra.currentmult + card.ability.extra.multgain
				return {
					extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT }
				}
			end
        end
	end
}

SMODS.Joker {
	key = 'swarm',
	loc_txt = {
		name = '{C:mult}The Circle Swarm{}',
		text = {
			"{C:mult}+#1#{} Mult",
			"{C:mult}-#2#{} Mult every hand played",
			"{C:mult}Circle-Sealed cards{} held in hand add {C:mult}+#3#{} Mult"
		}
	},
	config = { extra = { currentmult = 16, multloss = 1, multgain = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.currentmult, card.ability.extra.multloss, card.ability.extra.multgain } }
	end,
	rarity = 'r_shape',
	atlas = 't4somcjokers_atlas',
	pos = { x = 1, y = 0 },
	cost = 6,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.currentmult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.currentmult } }
			}
		end
		if context.after then
			card.ability.extra.currentmult = card.ability.extra.currentmult - card.ability.extra.multloss
			return {
				message = '-' .. card.ability.extra.multloss .. 'Mult', colour = G.C.MULT
			}
		end
        if context.cardarea == G.hand and context.individual and not context.end_of_round then
			if context.other_card.seal and context.other_card:get_seal() == 'r_circleseal' then
				card.ability.extra.currentmult = card.ability.extra.currentmult + card.ability.extra.multgain
				return {
					extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT }
				}
			end
        end
	end
}


SMODS.Joker {
	key = 'seal_of_approval',
	loc_txt = {
		name = '{C:mult}Seal of Approval{}',
		text = {
			"{C:mult}Circle-Sealed Cards{} each give {C:mult}+#1#{} extra Mult"
		}
	},
	config = { extra = { mult = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult } }
	end,
	rarity = 'r_shape',
	atlas = 't4somcjokers_atlas',
	pos = { x = 5, y = 0 },
	cost = 5,
	calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and context.other_card.seal and context.other_card:get_seal() == 'r_circleseal' then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
        end
	end
}

--SMODS.Joker {
--	key = 'circle_mitosis',
--	loc_txt = {
--		name = '{C:mult}Mitosis{}',
--		text = {
--			"Applies a {C:mult}Circle Seal{} to a random scoring card",
--			"After #1# {C:mult}Circle Seals{} added, turns into {C:mult}The Circle{}"
--		}
--	},
--	config = { extra = { circle_seals = 5 } },
--	loc_vars = function(self, info_queue, card)
--		return { vars = { card.ability.extra.circle_seals } }
--	end,
--	rarity = 'r_shape',
--	atlas = 't4somcjokers_atlas',
--	pos = { x = 4, y = 0 },
--	cost = 10,
--	calculate = function(self, card, context)
--        if context.before and context.cardarea == G.play then
--			if card.ability.extra.circle_seals >= 0 then
--            		G.E_MANAGER:add_event(Event({func = function()
--            		    play_sound('tarot1')
--            		    card:juice_up(0.3, 0.5)
--            		    return true end }))
--					
--            		G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
--            		    context.full_hand[math.random(1, #context.full_hand)]:set_seal('r_circle_seal', false, true)
--            		    return true end }))
--					
--            		delay(0.5)
--				card.ability.extra.circle_seals = card.ability.extra.circle_seals - 1
--			else
--				self:start_dissolve()
--				self:remove_from_deck()
--				SMODS.add_card({key = "j_r_circle"})
--			end
--        end
--	end
--}

SMODS.Joker {
	key = 'bullet_hell',
	loc_txt = {
		name = '{C:mult}Bullet Hell{}',
		text = {
			"{C:mult}+#1#{} Mult",
			"{X:mult,C:white}X#2#{} this value at the end of round",
		}
	},
	config = { extra = { mult = 1, mult_xmod = 2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_xmod } }
	end,
	rarity = 'r_shape',
	atlas = 't4somcjokers_atlas',
	pos = { x = 6, y = 0 },
	cost = 10,
	calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers then
			card.ability.extra.mult = card.ability.extra.mult * card.ability.extra.mult_xmod
			return {
				message = "Upgraded!",
				colour = G.C.MULT
			}
        end
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = "+" .. card.ability.extra.mult .. " Mult",
				colour = G.C.MULT
			}
		end
	end
}

-- square nation
SMODS.Joker {
	key = 'square',
	loc_txt = {
		name = '{C:green}The Square{}',
		text = {
			"Scored cards have a {C:attention}1{} in {C:attention}(amount of cards in hand){}",
			"chance to give {X:chips,C:white}X#1#{} Chips"
		}
	},
	config = { extra = { xchips = 2, random_card = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xchips } }
	end,
	rarity = 'r_shape',
	atlas = 't4somcjokers_atlas',
	pos = { x = 8, y = 0 },
	cost = 10,
	calculate = function(self, card, context)
		if context.cardarea == G.play then
			card.ability.extra.random_card = math.floor(math.random(1, #context.scoring_hand))
		end
		if context.cardarea == G.play and context.individual and context.other_card == context.scoring_hand[card.ability.extra.random_card] then
			return {
				Xchip_mod = card.ability.extra.xchips,
				message = "X" .. card.ability.extra.xchips .. " Chips",
				colour = G.C.CHIPS
			}
		end
	end
}


SMODS.Joker {
	key = 'laser_sequence',
	loc_txt = {
		name = '{C:green}Laser Sequence{}',
		text = {
			"A random scoring card gives {X:chips,C:white}X#1#{} Chips",
			"Every other scoring card that triggers after that gives",
			"{X:chips,C:white}X#2#{} less Chips"
		}
	},
	config = { extra = { xchips = 1.5, xchip_decrease = 0.1, random_card = 0 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xchips, card.ability.extra.xchip_decrease } }
	end,
	rarity = 'r_shape',
	atlas = 't4somcjokers_atlas',
	pos = { x = 2, y = 1 },
	cost = 10,
	calculate = function(self, card, context)
		if context.cardarea == G.play then
			card.ability.extra.random_card = math.random(0, #context.scoring_hand)
		end
		if context.cardarea == G.play and context.individual then
			for i = 0, (#context.scoring_hand - card.ability.extra.random_card) do
				if context.other_card == context.scoring_hand[card.ability.extra.random_card] then
					card.ability.extra.xchips = 1.5
					return {
						Xchip_mod = card.ability.extra.xchips,
						message = "X" .. card.ability.extra.xchips .. " Chips",
						colour = G.C.CHIPS
					}
				else if context.other_card == context.scoring_hand[card.ability.extra.random_card + i] then
					card.ability.extra.xchips = math.max(card.ability.extra.xchips - card.ability.extra.xchip_decrease, 1)
					return {
						Xchip_mod = card.ability.extra.xchips,
						message = "X" .. card.ability.extra.xchips .. " Chips",
						colour = G.C.CHIPS
					}
				end
			end
		end
	end
	end
}

-- the triangulars
SMODS.Joker {
	key = 'triangle',
	loc_txt = {
		name = '{C:blue}The Triangle{}',
		text = {
			"When a hand is played, the {C:attention}middle card{} gives {C:chips}+#1#{} Chips when scored",
			"Every other card gives {C:chips}+#2#{} Chips"
		}
	},
	config = { extra = { middle_chips = 100, other_chips = 25, middle_card = 3 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.middle_chips, card.ability.extra.other_chips } }
	end,
	rarity = 'r_shape',
	atlas = 't4somcjokers_atlas',
	pos = { x = 9, y = 0 },
	cost = 10,
	calculate = function(self, card, context)
		if context.cardarea == G.play then
			if math.fmod(#context.scoring_hand, 2) == 0 then
				card.ability.extra.middle_card = #context.scoring_hand / 2
				--print("wow! " .. #context.scoring_hand .. " cards and the middle one is the " .. card.ability.extra.middle_card .. "th one !")
			else if math.fmod(#context.scoring_hand, 2) == 1 then
				card.ability.extra.middle_card = (#context.scoring_hand / 2) + 0.5
				--print("wow! " .. #context.scoring_hand .. " cards and the middle one is the " .. card.ability.extra.middle_card .. "th one !")
			end
		end
		if context.individual and context.cardarea == G.play then 
			if context.other_card == context.scoring_hand[card.ability.extra.middle_card] then
				return {
					chip_mod = card.ability.extra.middle_chips,
					message = "+" .. card.ability.extra.middle_chips .. " Chips",
					colour = G.C.CHIPS
				}
			else
				return {
					chip_mod = card.ability.extra.other_chips,
					message = "+" .. card.ability.extra.other_chips .. " Chips",
					colour = G.C.CHIPS
				}
			end
		end
	end
end
}


-- six sided shapers
SMODS.Joker {
	key = 'hexagon',
	loc_txt = {
		name = '{C:hexagone}The Hexagon{}',
		text = {
			"Gains {X:mult,C:white}X#2#{} Mult for each Diamond in your deck",
			"{C:inactive}Currently {X:mult,C:white}X#1#{C:inactive} Mult"
		}
	},
	config = { extra = { xmult = 1, xmult_mod = 0.01, active = false } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, card.ability.extra.xmult_mod } }
	end,
	rarity = 'r_shape',
	atlas = 't4somcjokers_atlas',
	pos = { x = 7, y = 0 },
	cost = 10,
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.active = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.extra.active = false
	end,
	update = function(self, card, dt)
		local diamondcount = 0
		if card.ability.extra.active == true then
			for _, pcard in ipairs(G.playing_cards) do 
				if pcard:is_suit("Diamonds") then 
					diamondcount = diamondcount + 1
					card.ability.extra.xmult = 1 + (card.ability.extra.xmult_mod * diamondcount)
				end
			end
		end
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.xmult,
				message = "X" .. card.ability.extra.xmult .. " Mult",
				colour = G.C.MULT
			}
		end
	end
}

-- john core
SMODS.Joker {
	key = 'the_core',
	loc_txt = {
		name = 'The Core',
		text = {
			"Creates a random {C:shapes_gradient}Shape{} Joker when blind is selected",
			"Each {C:shapes_gradient}Shape{} Joker gives {X:chips,C:white}X#2#{} Chips and Mult when triggered",
			"{C:shapes_gradient}The Four Shapes Of Mind Control{} instead give {X:attention,C:white}X#3#{} that amount",
			"{C:red}Fixed{} {C:attention}1 in 10{} chance to {X:dark_edition,C:edition,s:1.5}corrupt...{}"
		}
	},
	config = { extra = { amount = 1, xchipmult = 1.5, multiplier = 4, active = false } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.amount, card.ability.extra.xchipmult, card.ability.extra.multiplier } }
	end,
	rarity = 'r_the_core',
	atlas = 't4somcjokers_atlas',
	pos = { x = 3, y = 0 },
	cost = 20,
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.active = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.extra.active = false
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			if math.random() >= 0.1 then
				return {
					G.E_MANAGER:add_event(Event({func = function()
						local card1 = create_card('Joker', G.jokers, nil, 'r_shape', nil, nil, nil, 'normal')
						card1:add_to_deck()
						G.jokers:emplace(card1)
						card1:juice_up(0.3, 0.5)
						return true
					end }))
				}
			else
				return {
					G.E_MANAGER:add_event(Event({func = function()
						local card1 = create_card('Joker', G.jokers, nil, 'r_corrupted_shape', nil, nil, nil, 'corruptedandfuckedup')
						card1:add_to_deck()
						G.jokers:emplace(card1)
						card1:juice_up(0.3, 0.5)
						return true
					end }))
				}
			end
		end
		if context.other_joker then
			if context.other_joker.config.center.rarity == "r_shape" then
				return {
					Xchip_mod = card.ability.extra.xchipmult,
					Xmult_mod = card.ability.extra.xchipmult,
					message = 'X' .. card.ability.extra.xchipmult .. ' Chips & Mult',
					color = G.C.WHITE,
					other_joker = card
				}
			else if context.other_joker.config.center.key == "j_r_the_four_shapes" then
				return {
					Xchip_mod = card.ability.extra.xchipmult * card.ability.extra.multiplier,
					Xmult_mod = card.ability.extra.xchipmult * card.ability.extra.multiplier,
					message = 'X' .. card.ability.extra.xchipmult * card.ability.extra.multiplier .. ' Chips & Mult',
					color = G.C.WHITE,
					other_joker = card
				}
			end
		end
	end
	end
}

-- the shapes!!!!!!!!!!!!!!
SMODS.Joker {
	key = 'the_four_shapes',
	loc_txt = {
		name = 'The Four Shapes of Mind Control',
		text = {
			"Scoring Hearts give {C:mult}+#1#{} Mult, increases by {C:mult}+#2#{} for every {C:mult}Circle Sealed{} Cards in deck",
			"Spades held in hand give {X:chips,C:white}X#3#{} Chips, increases by {X:chips,C:white}+X#4#{} for every other Spade held in hand",
			"{C:chips}+#5#{} Chips, increases by {C:chips}+#6#{} for every discarded Clubs",
			"ALL Diamonds in deck give {X:mult,C:white}X#7#{} Mult, increases by {X:mult,C:white}+X#8#{} for each Diamond in deck",
			"{C:inactive}everyone is here"
		}
	},
	config = { extra = { mult = 0, mult_mod = 1, xchips = 1, xchip_mod = 0.25, chips = 0, chip_mod = 50, xmult = 1, xmult_mod = 0.05, active = false } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_mod, card.ability.extra.xchips, card.ability.extra.xchip_mod, card.ability.extra.chips, card.ability.extra.chip_mod, card.ability.extra.xmult, card.ability.extra.xmult_mod, card.ability.extra.active, } }
	end,
	rarity = 'r_the_four_shapes',
	atlas = 't4somcjokers_atlas',
	pos = { x = 0, y = 1 },
	cost = 20,
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.active = true
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.extra.active = false
	end,
	update = function(self, card, dt)
		local sealcount = 0
		local diamondcount = 0
		local spadecount = 0
		if card.ability.extra.active == true then
			for _, pcard in ipairs(G.playing_cards) do 
				if pcard.seal == 'r_circleseal' then 
					sealcount = sealcount + 1
					card.ability.extra.mult = card.ability.extra.mult_mod * sealcount
				end
			end
			for _, pcard in ipairs(G.playing_cards) do 
				if pcard:is_suit("Diamonds") then 
					diamondcount = diamondcount + 1
					card.ability.extra.xmult = 1 + (card.ability.extra.xmult_mod * diamondcount)
				end
			end
			for _, pcard in ipairs(G.hand.cards) do 
				if pcard:is_suit("Spades") then 
					spadecount = spadecount + 1
					card.ability.extra.xchips = 1 + (card.ability.extra.xmult_mod * spadecount)
				end
			end
		end
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and not context.blueprint then
            if context.other_card:is_suit("Hearts") then
                return {
                    mult_mod = card.ability.extra.mult,
					message = '+' .. card.ability.extra.mult .. ' Mult',
					color = G.C.MULT
                }
            end
        end
		if context.discard then
			if context.other_card:is_suit("Clubs") then
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
				return {
					message = "Upgraded!",
					colour = G.C.CHIPS
				}
			end
		end
        if context.cardarea == G.jokers and context.joker_main then
            return {
                chip_mod = card.ability.extra.chips,
				message = '+' .. card.ability.extra.chips .. ' Chips',
				color = G.C.CHIPS
            }
        end
        if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.blueprint then
            if context.other_card:is_suit("Spades") then
                return {
                    Xchip_mod = card.ability.extra.xchips,
					message = 'X' .. card.ability.extra.xchips .. ' Chips',
					color = G.C.CHIPS
                }
			end
		end
        if context.individual and not context.end_of_round and not context.blueprint then
            if context.other_card:is_suit("Diamonds") then
                return {
                    Xmult_mod = card.ability.extra.xmult,
					message = 'X' .. card.ability.extra.xmult .. ' Mult',
					color = G.C.MULT
                }
			end
		end
	end
}

-- the guardian themselves
SMODS.Joker {
	key = 'the_guardian',
	loc_txt = {
		name = '???',
		text = {
			"Protects {C:attention}The Core{} at all costs",
			"Retriggers all {C:shapes_gradient}Shape{} Jokers {C:attention}#1#{} additional time",
			"{C:inactive}...What is this place? Why am I stuck inside of a card?{}",
			"{C:inactive}Well, at least {C:attention}The Core{C:inactive} seems to be functional...{}",
		}
	},
	config = { extra = { retriggers = 1, active = false, } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.j_r_the_core
		return { vars = { card.ability.extra.retriggers, card.ability.extra.active, } }
	end,
	rarity = 'r_the_core',
	atlas = 't4somcjokers_atlas',
	pos = { x = 1, y = 1 },
	cost = 20,
	add_to_deck = function(self, card, from_debuff)
		card.ability.extra.active = true
	end,
	update = function(self, card, dt)
		if card.ability.extra.active == true then
			local count = 0
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i].config.center.key == "j_r_the_core" then
					G.jokers.cards[i]:set_eternal(true)
				end
			end
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		card.ability.extra.active = false
	end,
	calculate = function(self, card, context)
		if context.retrigger_joker_check and not context.retrigger_joker and (context.other_card.config.center.rarity == "r_shape" or context.other_card.config.center.key == "j_r_the_four_shapes") then
			return {
				message = localize("k_again_ex"),
				repetitions = lenient_bignum(card.ability.extra.retriggers),
			}
		end
	end
}

-- the corrupted shapes
SMODS.Joker {
	key = 'pentagon',
	loc_txt = {
		name = '{C:money}The Pentagon{}',
		text = {
			"{C:mult}=???{} Mult",
			"{C:mult}=???{} Chips",
		}
	},
	config = { extra = { maxmult = 25, maxchips = 25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.maxmult, card.ability.extra.maxchips } }
	end,
	rarity = 'r_corrupted_shape',
	atlas = 'pentagon_atlas',
	pos = { x = 0, y = 0 },
	cost = 2,
    no_collection = true,
    animation = {
        macro = {
        type = "skim",
        pos = {
            include = {{x1=0,x2=9,y1=0,y2=0}},
        },
        }
    },
	calculate = function(self, card, context)
		if context.joker_main then
			local randmult = math.random(0, card.ability.extra.maxmult)
			local randchips = math.random(0, card.ability.extra.maxchips)
			return {
				Xchip_mod = 0,
				chip_mod = randchips,
				message = '=' .. randchips .. ' Chips',
				colour = G.C.CHIPS,
				extra = {
					Xmult_mod = 0,
					message = '=' .. randmult .. ' Mult',
					mult_mod = randmult,
					colour = G.C.MULT,
				}
			}
		end
	end
}

SMODS.Joker {
	key = 'text',
	loc_txt = {
		name = '{C:blue}The Text{}',
		text = {
			"{C:chips}=???{} hands and {C:mult}=???{} discards when exiting shop",
		}
	},
	config = { extra = { maxhands = 7, maxdiscards = 7 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.maxhands, card.ability.extra.maxdiscards } }
	end,
	rarity = 'r_corrupted_shape',
	atlas = 'text_atlas',
	pos = { x = 0, y = 0 },
	cost = 2,
    no_collection = true,
    animation = {
        macro = {
        type = "skim",
        pos = {
            include = {{x1=0,x2=9,y1=0,y2=0}},
        },
        }
    },
	calculate = function(self, card, context)
		if context.ending_shop then
			G.GAME.round_resets.hands = math.random(1, card.ability.extra.maxhands)
			G.GAME.round_resets.discards = math.random(1, card.ability.extra.maxdiscards)
			return {
				message = '=' .. G.GAME.round_resets.hands .. ' Hands',
				colour = G.C.CHIPS,
				extra = {message = '=' .. G.GAME.round_resets.discards .. ' Discards', colour = G.C.MULT}
			}
		end
	end
}

SMODS.Joker {
	key = 'arrow',
	loc_txt = {
		name = '{C:money}The Arrow{}',
		text = {
			"{C:money}=???${}",
		}
	},
	config = { extra = { maxdollars = 25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.maxdollars } }
	end,
	rarity = 'r_corrupted_shape',
	atlas = 'arrow_atlas',
	pos = { x = 0, y = 0 },
    no_collection = true,
	cost = 2,
    animation = {
        macro = {
        type = "skim",
        pos = {
            include = {{x1=0,x2=9,y1=0,y2=0}},
        },
        }
    },
	calculate = function(self, card, context)
		if context.end_of_round and context.cardarea == G.jokers then
			local randmoney = math.random(0, card.ability.extra.maxdollars)
			ease_dollars(randmoney - G.GAME.dollars)
			return {
				message = '=' .. randmoney .. '$',
				colour = G.C.MONEY,
			}
		end
	end
}

SMODS.Joker {
	key = 'the_object',
	loc_txt = {
		name = 'THE_OBJECT',
		text = {
			"{X:dark_edition,C:white}?????"
		}
	},
	config = { extra = {  } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	rarity = 'r_the_object',
	atlas = 'object_atlas',
	pos = { x = 0, y = 0 },
    no_collection = true,
	cost = 1e100,
    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,
	update = function(self, card, dt)
		G.jokers.config.card_limit = math.random(0, -1000)
		G.consumeables.config.card_limit = math.random(0, -1000)
	end,
	calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            return {
                repetitions = pseudorandom('THE_OBJECT', 0, 5),
                message = localize('k_again_ex')
            }
		end
        if context.individual and context.cardarea == G.play and not context.blueprint then
            --assert(SMODS.change_base(
			--context.other_card, 
			--pseudorandom_element({"Spades", "Diamonds", "Clubs", "Hearts"}, pseudoseed('THE_OBJECT'), true),
			--pseudorandom_element({"2", "3", "4", "5", "6", "7", "8", "9", "Ten", "Jack", "Queen", "King", "Ace"}, pseudoseed('THE_OBJECT'), true)))
            context.other_card:set_ability(G.P_CENTER_POOLS.Enhanced[math.random(0, #G.P_CENTER_POOLS.Enhanced)].key, true)
            context.other_card:set_seal(G.P_CENTER_POOLS.Seal[math.random(0, #G.P_CENTER_POOLS.Seal)].key, true)
            context.other_card:set_edition(G.P_CENTER_POOLS['Edition'][math.random(0, #G.P_CENTER_POOLS['Edition'])].key, true, true)
            context.other_card.ability.perma_bonus = pseudorandom('THE_OBJECT', 0, 100)
            context.other_card.ability.perma_mult = pseudorandom('THE_OBJECT', 0, 100)
            context.other_card.ability.perma_x_chips = pseudorandom('THE_OBJECT', 0, 100)
            context.other_card.ability.perma_x_mult = pseudorandom('THE_OBJECT', 0, 100)
            context.other_card.ability.perma_h_chips = pseudorandom('THE_OBJECT', 0, 100)
            context.other_card.ability.perma_h_mult = pseudorandom('THE_OBJECT', 0, 100)
            context.other_card.ability.perma_h_x_chips = pseudorandom('THE_OBJECT', 0, 100)
            context.other_card.ability.perma_h_x_mult = pseudorandom('THE_OBJECT', 0, 100)
            context.other_card.ability.perma_p_dollars = pseudorandom('THE_OBJECT', 0, 100)
            context.other_card.ability.perma_h_dollars = pseudorandom('THE_OBJECT', 0, 100)
        end
	end
}
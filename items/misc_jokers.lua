-- atlas dump

SMODS.Atlas {
    key = "miscjokers_atlas",
    path = "miscjokers.png",
    px = 71,
    py = 95
}
--[[
SMODS.Joker {
	key = 'incomprehensible_joker',
	loc_txt = {
		name = 'Incomprehensible Joker',
		text = {
			"All playing cards count as {C:attention}all suits{}",
			"All playing cards count as {C:attention}all ranks{}",
			"Playing cards cannot be {C:attention}debuffed{}",
		}
	},
	config = { extra = {  } },
	loc_vars = function(self, info_queue, card)
		return { vars = {  } }
	end,
	rarity = 4,
	atlas = 'miscjokers_atlas',
	pos = { x = 0, y = 0 },
	cost = 20,
	update = function(self, card, dt)
		if G.deck and card.added_to_deck then
			for i, v in pairs(G.deck.cards) do
				v:set_debuff(false)
			end
		end
		if G.hand and card.added_to_deck then
			for i, v in pairs(G.hand.cards) do
				v:set_debuff(false)
			end
		end
	end,
}
-- the suits thing
local card_is_suit_ref = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    local ret = card_is_suit_ref(self, suit, bypass_debuff, flush_calc)
    if not ret and not SMODS.has_no_suit(self) then
        if next(SMODS.find_card("j_r_incomprehensible_joker")) then
            if suit == "Spades" and (self.base.suit == "Hearts" or self.base.suit == "Clubs" or self.base.suit == "Diamonds") then
                ret = true
            end
            if suit == "Hearts" and (self.base.suit == "Spades" or self.base.suit == "Clubs" or self.base.suit == "Diamonds") then
                ret = true
            end
            if suit == "Clubs" and (self.base.suit == "Spades" or self.base.suit == "Hearts" or self.base.suit == "Diamonds") then
                ret = true
            end
            if suit == "Diamonds" and (self.base.suit == "Spades" or self.base.suit == "Clubs" or self.base.suit == "Hearts") then
                ret = true
            end
        end
    end
    return ret
end
-- ranks
local card_get_id_ref = Card.get_id
function Card:get_id()
    local original_id = card_get_id_ref(self)
    if not original_id then return original_id end

    if next(SMODS.find_card("j_r_incomprehensible_joker")) then
        return 2 or 3 or 4 or 5 or 6 or 7 or 8 or 9 or 10 or 11 or 12 or 13 or 14
    end
    return original_id
end
-- ig for faces too
local card_is_face_ref = Card.is_face
function Card:is_face(from_boss)
    local original_result = card_is_face_ref(self, from_boss)
    if original_result then return true end
    
    local card_id = self:get_id()
    if not card_id then return false end

    if next(SMODS.find_card("j_r_incomprehensible_joker")) then
        local source_ids = {2, 3, 4, 5, 6, 7, 8, 9, 14}
        for _, source_id in pairs(source_ids) do
            if card_id == source_id then return true end
        end
    end
    return false
end
]]

--[[SMODS.Joker {
	key = 'john_jimbo',
	loc_txt = {
		name = 'John Jimbo',
		text = {
			"Gains {X:mult,C:white}X#1#{} Mult for each owned {C:attention}Vanilla Joker{}",
			"Default Jokers instead give {X:mult,C:white}X#2#{} Mult",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)"
		}
	},
	config = { extra = { xmult_mod = 0.5, xmult_mod_jimbo = 4, xmult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult_mod_jimbo, card.ability.extra.xmult } }
	end,
	rarity = 3,
	atlas = 'placeholders',
	pos = { x = 2, y = 0 },
	cost = 10,
	update = function(self, card, dt)
        local vanilla_jokers = {
        "j_greedy_joker", 
        "j_lusty_joker", 
        "j_wrathful_joker", 
        "j_gluttenous_joker", 
        "j_jolly", 
        "j_zany", 
        "j_mad", 
        "j_crazy", 
        "j_droll", 
        "j_sly", 
        "j_wily", 
        "j_clever", 
        "j_devious", 
        "j_crafty", 
        "j_half", 
        "j_stencil", 
        "j_four_fingers", 
        "j_mime", 
        "j_credit_card", 
        "j_ceremonial", 
        "j_banner", 
        "j_mystic_summit", 
        "j_marble", 
        "j_loyalty_card", 
        "j_8_ball", 
        "j_misprint", 
        "j_dusk", 
        "j_raised_fist", 
        "j_chaos",
        "j_fibonacci", 
        "j_steel_joker", 
        "j_scary_face", 
        "j_abstract", 
        "j_delayed_grat", 
        "j_hack", 
        "j_pareidolia", 
        "j_gros_michel", 
        "j_even_steven", 
        "j_odd_todd", 
        "j_scholar", 
        "j_business", 
        "j_supernova", 
        "j_ride_the_bus", 
        "j_space", 
        "j_egg", 
        "j_burglar", 
        "j_blackboard", 
        "j_runner", 
        "j_ice_cream", 
        "j_dna", 
        "j_splash", 
        "j_blue_joker", 
        "j_sixth_sense", 
        "j_constellation", 
        "j_hiker", 
        "j_faceless", 
        "j_green_joker", 
        "j_superposition", 
        "j_todo_list", 
        "j_cavendish", 
        "j_card_sharp", 
        "j_red_card", 
        "j_madness", 
        "j_square", 
        "j_seance", 
        "j_riff_raff", 
        "j_vampire", 
        "j_shortcut", 
        "j_hologram", 
        "j_vagabond", 
        "j_baron", 
        "j_cloud_9",
        "j_rocket", 
        "j_obelisk", 
        "j_midas_mask", 
        "j_luchador", 
        "j_photograph", 
        "j_gift", 
        "j_turtle_bean", 
        "j_erosion", 
        "j_reserved_parking", 
        "j_mail", 
        "j_to_the_moon", 
        "j_hallucination", 
        "j_fortune_teller", 
        "j_juggler", 
        "j_drunkard", 
        "j_stone", 
        "j_golden", 
        "j_lucky_cat", 
        "j_baseball", 
        "j_bull", 
        "j_diet_cola", 
        "j_trading", 
        "j_flash", 
        "j_popcorn", 
        "j_trousers", 
        "j_ancient", 
        "j_ramen", 
        "j_walkie_talkie", 
        "j_selzer", 
        "j_castle", 
        "j_smiley", 
        "j_campfire", 
        "j_ticket", 
        "j_mr_bones", 
        "j_acrobat", 
        "j_sock_and_buskin", 
        "j_swashbuckler", 
        "j_troubadour", 
        "j_certificate", 
        "j_smeared", 
        "j_throwback", 
        "j_hanging_chad",
        "j_rough_gem", 
        "j_bloodstone",
        "j_arrowhead", 
        "j_onyx_agate", 
        "j_glass", 
        "j_ring_master", 
        "j_flower_pot", 
        "j_blueprint", 
        "j_wee", 
        "j_merry_andy", 
        "j_oops", 
        "j_idol", 
        "j_seeing_double", 
        "j_matador", 
        "j_hit_the_road", 
        "j_duo", 
        "j_trio", 
        "j_family", 
        "j_order", 
        "j_tribe", 
        "j_stuntman", 
        "j_invisible", 
        "j_brainstorm", 
        "j_satellite", 
        "j_shoot_the_moon", 
        "j_drivers_license", 
        "j_cartomancer", 
        "j_astronomer", 
        "j_burnt", 
        "j_bootstraps", 
        "j_caino", 
        "j_triboulet", 
        "j_yorick", 
        "j_chicot", 
        "j_perkeo"}
		for k, v in pairs(G.joker.cards) do
            local count = 0
            for i=1, #vanilla_jokers do
			    if v.config.center.key == vanilla_jokers[i] then
                    count = count + 1
                    card.ability.extra.xmult = 1 + (card.ability.extra.xmult_mod * count)
                end
            end
        end
        for i=1, #SMODS.find_card("j_joker") do
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod_jimbo
        end
	end,
}
]]--

SMODS.Joker {
	key = 'diamond_joker',
	loc_txt = {
		name = 'Diamond Joker',
		text = {
			"Earn {C:money}the amount of $ you have{} at the end of round",
			"{C:inactive}(#1# max){}",
		}
	},
	config = { extra = { maxmoney = 25 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.maxmoney } }
	end,
	rarity = 3,
	atlas = 'placeholders',
	pos = { x = 2, y = 0 },
	cost = 10,
	calc_dollar_bonus = function(self, card)
	return 
		math.max(G.GAME.dollars, card.ability.extra.maxmoney)
	end
}

SMODS.Joker {
	key = 'the_incredible_photochud',
	loc_txt = {
		name = 'The Incredible Photochud',
		text = {
			"Retriggers the {C:attention}first{} scoring card {C:attention}#1#{} times",
            "The first scoring {C:attention}Face Card{} gives {X:mult,C:white}X#2#{} Mult when triggered"
		}
	},
	config = { extra = { retriggers = 4, xmult = 4 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.retriggers, card.ability.extra.xmult } }
	end,
	rarity = 4,
	atlas = 'placeholders',
	pos = { x = 3, y = 0 },
	cost = 20,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card == context.scoring_hand[1] then
                return {
                    repetitions = card.ability.extra.retriggers,
                    message = localize('k_again_ex')
                }
            end
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card == context.scoring_hand[1] and context.other_card:is_face() then
                return {
                    Xmult_mod = card.ability.extra.xmult,
                    message = "X" .. card.ability.extra.xmult .. " Mult",
                    colour = G.C.MULT
                }
            end
        end
    end
}

SMODS.Joker {
	key = 'factory',
	loc_txt = {
		name = 'Factory',
		text = {
			"{C:mult}+#2#?{} Mult",
            "Value increase by {C:attention}#3#{} at the end of round"
		}
	},
	config = { extra = { mult = 1, increase = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.increase } }
	end,
	rarity = 3,
	atlas = 'placeholders',
	pos = { x = 3, y = 0 },
	cost = 12,
    calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = addition_factorial(card.ability.extra.mult),
				message = '+' .. addition_factorial(card.ability.extra.mult) .. ' Mult',
                color = G.C.MULT,
			}
		end
        if (context.end_of_round and context.cardarea == G.jokers) or context.forcetrigger then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.increase
			return {
				message = "Upgraded!",
                color = G.C.ATTENTION,
			}
        end
    end
}


-- henry is back
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
	dependencies = {"cryptposting"},
	rarity = 'crp_2exomythic4me',
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

-- zulu 2
SMODS.Joker {
	key = 'zulu_2',
	loc_txt = {
		name = 'zulu but better',
		text = {
			"{C:valk_prestigious,s:10}+pi Zulu{}",
		}
	},
	config = { extra = { zulu = math.pi } },
	dependencies = {"vallkarri"},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.zulu } }
	end,
	rarity = 'valk_prestigious',
	atlas = 'placeholders',
	pos = { x = 10, y = 0 },
	cost = 500 * math.pi,
	calculate = function(self, card, context)
		if context.joker_main then
        	G.GAME.zulu = (G.GAME.zulu and G.GAME.zulu+card.ability.extra.zulu) or (math.pi+card.ability.extra.zulu)
		end
	end
}

-- deluxe edition
SMODS.Joker {
	key = 'oil_lamp_deluxe',
	loc_txt = {
		name = 'Oil Lamp: Deluxe Edition',
		text = {
			"Increases values of {C:attention}ALL Jokers{} by {X:attention,C:white}^#1#{}",
			"at the end of round",
			"{C:inactive}(Works on itself)"
		}
	},
	config = { extra = { value_increase = 1.2 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.value_increase } }
	end,
	dependencies = {"Cryptid"},
	rarity = 'cry_exotic',
	atlas = 'placeholders',
	pos = { x = 10, y = 0 },
	cost = 50,
	calculate = function(self, card, context)
        if (context.end_of_round and context.cardarea == G.jokers) or context.forcetrigger then
            for i, v in pairs(G.jokers.cards) do
				Cryptid.manipulate(G.jokers.cards[i], { value = { arrows = 1, height = card.ability.extra.value_increase }, type = "hyper" })
            end
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = localize("k_upgrade_ex"), colour = G.C.GREEN }
			)
        end
	end
}

--[[
-- im yoinking that thank you
SMODS.Joker:take_ownership('j_cavendish', {
	no_pool_flag = 'cavendish_extinct',
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult
			}
		end
		if context.end_of_round and context.game_over == false and not context.repetition and not context.blueprint then
			if pseudorandom('cavendish') < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				G.GAME.pool_flags.cavendish_extinct = true
				return {
					message = 'Extinct!'
				}
			else
				return {
					message = 'Safe!'
				}
			end
		end
	end
})

SMODS.Joker {
	key = 'grossus_michus',
	loc_txt = {
		name = 'Grossus Michus',
		text = {
			"{X:dark_edition,C:white}^#1#{} Mult",
            "{C:green}#2# in #3#{} chance this card is destroyed",
            "at the end of round",
		}
	},
	config = { extra = { emult = 1.67, destroy_chance = 1000000 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.emult, (G.GAME.probabilities.normal or 1), card.ability.extra.destroy_chance } }
	end,
	yes_pool_flag = 'cavendish_extinct',
	no_pool_flag = 'grossus_michus_extinct',
	rarity = 1,
	atlas = 'placeholders',
	pos = { x = 0, y = 0 },
	cost = 4,
    calculate = function(self, card, context)
		if context.joker_main then
			return {
				Emult_mod = card.ability.extra.emult,
				message = '^' .. card.ability.extra.emult .. ' Mult',
                color = G.C.MULT
			}
		end
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if pseudorandom('grossus_michus') < G.GAME.probabilities.normal / card.ability.extra.destroy_chance then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				G.GAME.pool_flags.grossus_michus_extinct = true
				return {
					message = 'Extinct!'
				}
			else
				return {
					message = 'Safe!'
				}
			end
			end
    end
}

SMODS.Joker {
	key = 'cavendus',
	loc_txt = {
		name = 'Cavendus',
		text = {
			"{X:dark_edition,C:white}^^#1#{} Mult",
            "{C:green}#2# in #3#{} chance this card is destroyed",
            "at the end of round",
		}
	},
	config = { extra = { eemult = 1.067, destroy_chance = 1e10 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.eemult, (G.GAME.probabilities.normal or 1), card.ability.extra.destroy_chance } }
	end,
	yes_pool_flag = 'grossus_michus_extinct',
	no_pool_flag = 'cavendus_extinct',
	rarity = 1,
	atlas = 'placeholders',
	pos = { x = 0, y = 0 },
	cost = 4,
    calculate = function(self, card, context)
		if context.joker_main then
			return {
				EEmult_mod = card.ability.extra.eemult,
				message = '^' .. card.ability.extra.eemult .. ' Mult',
                color = G.C.MULT
			}
		end
		if context.end_of_round and not context.repetition and context.game_over == false and not context.blueprint then
			if pseudorandom('cavendus') < G.GAME.probabilities.normal / card.ability.extra.destroy_chance then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				G.GAME.pool_flags.cavendus_extinct = true
				return {
					message = 'Extinct!'
				}
			else
				return {
					message = 'Safe!'
				}
			end
			end
    end
}

SMODS.Joker {
	key = 'hua_moa',
	loc_txt = {
		name = 'Hua Moa',
		text = {
			"{C:mult}+#1#{} Mult, {X:mult,C:white}X#2#{} Mult, {X:dark_edition,C:white}^#3#{} Mult, {X:dark_edition,C:white}^^#4#{} Mult",
			"{C:attention}Cannot go extinct{}"
		}
	},
	config = { extra = { mult = 30, xmult = 6, emult = 2.34, eemult = 1.134 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.xmult, card.ability.extra.emult, card.ability.extra.eemult, (G.GAME.probabilities.normal or 1), card.ability.extra.destroy_chance } }
	end,
	yes_pool_flag = 'cavendus_extinct',
	rarity = 1,
	atlas = 'placeholders',
	pos = { x = 0, y = 0 },
	cost = 4,
    calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = card.ability.extra.mult,
				message = '+' .. card.ability.extra.mult .. ' Mult',
                color = G.C.MULT,
                extra = {
				    Xmult_mod = card.ability.extra.xmult,
				    message = 'X' .. card.ability.extra.xmult .. ' Mult',
                    color = G.C.MULT,
                    extra = {
				        Emult_mod = card.ability.extra.emult,
				        message = '^' .. card.ability.extra.emult .. ' Mult',
                        color = G.C.MULT,
                        extra = {
				            EEmult_mod = card.ability.extra.eemult,
				            message = '^^' .. card.ability.extra.eemult .. ' Mult',
                            color = G.C.MULT,
                        }
                    }
                }
			}
		end
    end
}
]]--
-- all types of factorials
function factorial(n)
    local result = 1
    for i = 1, n do
        result = result * i
    end
    return result
end

function addition_factorial(n)
    local result = 0
    for i = 1, n do
        result = result + i
    end
    return result
end

function exponential_factorial(n)
    local result = 1
    for i = 1, n do
        result = result ^ i
    end
    return result
end
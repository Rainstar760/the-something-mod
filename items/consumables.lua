-- spectrals

-- atlas

SMODS.Atlas {
    key = "consumables",
    path = "consumables.png",
    px = 71,
    py = 95
}

SMODS.Consumable {
	key = 'game_breaker',
	set = 'Spectral',
	loc_txt = {
		name = 'Game Breaker',
		text = {
			'Destroy your entire deck, create #1# {C:attention}Polychrome Steel Red Seal King of Hearts{}',
			'Create {C:attention}#2# Perkeo{}, {C:attention}#3# Mime{}, {C:attention}#4# Triboulet{}, {C:attention}#5# Baron{}, {C:attention}#6# Blueprint{}, {C:attention}#7# Brainstorm{}, and {C:attention}#8# Cryptids{}',
            "{C:inactive}come on. do it. i know you want to.{}"
		}
	},
	config = {
		kings = 1,
		perkeos = 1,
		mimes = 1,
		triboulets = 1,
		barons = 1,
		blueprints = 1,
		brainstorms = 1,
		cryptids = 25,
    },
	pos = { x = 2, y = 2 },
	cost = 15,
	hidden = true,
    soul_rate = 0.1,
    soul_set = 'Spectral',
	unlocked = true,
	discovered = true,
	atlas = 'placeholders',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.kings, self.config.perkeos, self.config.mimes, self.config.triboulets, self.config.barons, self.config.blueprints, self.config.brainstorms, self.config.cryptids, self.config.hand_size, self.config.ante_mult }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function() 
                for i=#G.playing_cards, 1, -1 do
                    local card = G.playing_cards[i]
                    if card.ability.name == 'Glass Card' then 
                        card:shatter()
                    else
                        card:start_dissolve(nil, i ~= #G.playing_cards)
                    end
                end
            for i = 1, self.config.kings do
                local card_front = G.P_CARDS.H_K
                local new_card = create_playing_card({
                front = card_front,
                center = G.P_CENTERS.m_steel
                }, G.hand, true, false, nil, true)
                new_card:set_seal("Red", true)
                new_card:set_edition("e_polychrome", true)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        new_card:start_materialize()
                        G.hand:emplace(new_card)
                        return true
                    end
                }))
                draw_card(G.hand, G.deck, 90, 'up')
                SMODS.calculate_context({ playing_card_added = true, cards = { new_card } })
        end
                return true end }))
        for i = 1, self.config.perkeos do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_perkeo')
                    joker_card:set_edition("e_negative", true)
                    joker_card:add_to_deck()
                    G.jokers:emplace(joker_card)
                    return true
                end
            }))
        end
        for i = 1, self.config.mimes do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_mime')
                    joker_card:set_edition("e_negative", true)
                    joker_card:add_to_deck()
                    G.jokers:emplace(joker_card)
                    return true
                end
            }))
        end
        for i = 1, self.config.triboulets do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_triboulet')
                    joker_card:set_edition("e_negative", true)
                    joker_card:add_to_deck()
                    G.jokers:emplace(joker_card)
                    return true
                end
            }))
        end
        for i = 1, self.config.barons do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_baron')
                    joker_card:set_edition("e_negative", true)
                    joker_card:add_to_deck()
                    G.jokers:emplace(joker_card)
                    return true
                end
            }))
        end
        for i = 1, self.config.blueprints do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_blueprint')
                    joker_card:set_edition("e_negative", true)
                    joker_card:add_to_deck()
                    G.jokers:emplace(joker_card)
                    return true
                end
            }))
        end
        for i = 1, self.config.brainstorms do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local joker_card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_brainstorm')
                    joker_card:set_edition("e_negative", true)
                    joker_card:add_to_deck()
                    G.jokers:emplace(joker_card)
                    return true
                end
            }))
        end
        for i = 1, self.config.cryptids do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local consumable_card = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_cryptid')
                    consumable_card:set_edition("e_negative", true)
                    consumable_card:add_to_deck()
                    G.consumeables:emplace(consumable_card)
                    return true
                end
            }))
        end
    end
}

SMODS.Consumable {
    set = "Spectral",
    key = "circlification",
	config = {
        max_highlighted = 1,
        extra = 'r_circleseal',
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_SEALS[(card.ability or self.config).extra]
        return {vars = {(card.ability or self.config).max_highlighted}}
    end,
    loc_txt = {
        name = '{C:mult}Circlification{}',
        text = {
            "Apply {C:mult}Circle Seal{} to",
            "{C:attention}#1#{} selected card in hand"
        }
    },
    cost = 4,
    atlas = "consumables",
    pos = {x=2, y=0},
    use = function(self, card, area, copier)
        for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true end }))
            
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.hand.highlighted[i]:set_seal(card.ability.extra, false, true)
                return true end }))
            
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}


SMODS.Consumable {
	key = 'shape_groupup',
	set = 'Spectral',
	loc_txt = {
		name = 'Shape Group-up',
		text = {
			'If you have {C:attention}The Circle{}, {C:attention}The Square{}, {C:attention}The Triangle{} and {C:attention}The Hexagon{},',
			'group all of them up into {C:attention}The Four Shapes of Mind Control{}',
			'Otherwise, create any one of them',
		}
	},
	config = {
    },
	pos = { x = 1, y = 0 },
	cost = 10,
	unlocked = true,
	discovered = true,
	atlas = 'consumables',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {  }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
        local circle = false
        local square = false
        local triangle = false
        local hexagon = false
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.key == "j_r_circle" then
                circle = true
            end
			if G.jokers.cards[i].config.center.key == "j_r_square" then
                square = true
            end
			if G.jokers.cards[i].config.center.key == "j_r_triangle" then
                triangle = true
            end
			if G.jokers.cards[i].config.center.key == "j_r_hexagon" then
                hexagon = true
            end
        end
        if circle and square and triangle and hexagon then
		    for i = 1, #G.jokers.cards do
		    	if G.jokers.cards[i].config.center.key == "j_r_circle" or G.jokers.cards[i].config.center.key == "j_r_square" or G.jokers.cards[i].config.center.key == "j_r_triangle" or G.jokers.cards[i].config.center.key == "j_r_hexagon" then
                    G.jokers.cards[i]:start_dissolve()
                    G.jokers.cards[i]:remove_from_deck()
                end
            end
		    SMODS.add_card({key = "j_r_the_four_shapes"})
        else
            local shapes = {"j_r_circle", "j_r_square", "j_r_triangle", "j_r_hexagon"}
		    SMODS.add_card({key = shapes[math.random(1, 4)]})
        end
    end
}


SMODS.Consumable {
	key = 'calling',
	set = 'Spectral',
	loc_txt = {
		name = 'The Calling',
		text = {
			'Creates {C:attention}The Core{}',
			'Creates {C:attention}???{} instead if you already have {C:attention}The Core{}',
			'Creates a random {C:shape_gradient}Shape Joker{} instead if you already have both',
		}
	},
	config = {
    },
	pos = { x = 0, y = 0 },
	cost = 20,
	unlocked = true,
	discovered = true,
	atlas = 'consumables',
	hidden = true,
    soul_rate = 0.1,
    soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {  }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		if #SMODS.find_card("j_r_the_core") >= 1 and #SMODS.find_card("j_r_the_guardian") < 1 then
		    SMODS.add_card({key = "j_r_the_guardian"})
        else if #SMODS.find_card("j_r_the_guardian") >= 1 and #SMODS.find_card("j_r_the_core") >= 1 then
			G.E_MANAGER:add_event(Event({func = function()
				local card1 = create_card('Joker', G.jokers, nil, 'r_shape', nil, nil, nil, 'calling')
				card1:add_to_deck()
				G.jokers:emplace(card1)
				card1:juice_up(0.3, 0.5)
				return true
			end }))
        else
		    SMODS.add_card({key = "j_r_the_core"})
        end
    end
end
}


SMODS.Consumable {
	key = 'corruption',
	set = 'Spectral',
	loc_txt = {
		name = 'C0RRUPT10N',
		text = {
			'If you have {C:attention}The Core{} and all 3 {C:attention}Corrupted Shapes{},',
			'{C:attention}something happens.{}',
            "Otherwise, does nothing"
		}
	},
	config = {
    },
	pos = { x = 3, y = 0 },
	cost = 20,
	unlocked = true,
	discovered = true,
	atlas = 'consumables',
	hidden = true,
    soul_rate = 0.1,
    soul_set = 'Spectral',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {  }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
        local core = false
        local pentagon = false
        local text = false
        local arrow = false
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i].config.center.key == "j_r_the_core" then
                core = true
            end
			if G.jokers.cards[i].config.center.key == "j_r_pentagon" then
                pentagon = true
            end
			if G.jokers.cards[i].config.center.key == "j_r_text" then
                text = true
            end
			if G.jokers.cards[i].config.center.key == "j_r_arrow" then
                arrow = true
            end
        end
        if core and pentagon and text and arrow then
		    for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:start_dissolve()
                G.jokers.cards[i]:remove_from_deck()
            end
			G.E_MANAGER:add_event(Event({func = function()
				local card1 = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_r_the_object', 'corruption')
				card1:add_to_deck()
				G.jokers:emplace(card1)
				card1:juice_up(0.3, 0.5)
				return true
			end }))
        end
    end
}

SMODS.Consumable {
	key = 'package',
	set = 'Tarot',
	loc_txt = {
		name = 'The Whole Package',
		text = {
			'Applies a random {C:attention}enhancement{}, {C:attention}seal{} and {C:attention}edition{} to',
            '{C:attention}#1#{} selected card'
		}
	},
	config = {
        max_highlighted = 1,
    },
	pos = { x = 1, y = 2 },
	cost = 8,
	unlocked = true,
	discovered = true,
	atlas = 'placeholders',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.max_highlighted }}
    end,
	--can_use = function(self, card)
	--	return true
	--end,
	use = function(self, card, area, copier)
        for i = 1, math.min(#G.hand.highlighted, self.config.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                G.hand.highlighted[i]:set_ability(G.P_CENTER_POOLS.Enhanced[math.random(1, #G.P_CENTER_POOLS.Enhanced)].key, true)
                G.hand.highlighted[i]:set_seal(G.P_CENTER_POOLS.Seal[math.random(1, #G.P_CENTER_POOLS.Seal)].key, true)
                G.hand.highlighted[i]:set_edition(G.P_CENTER_POOLS["Edition"][math.random(1, #G.P_CENTER_POOLS["Edition"])].key, true, true)
                return true end }))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}


SMODS.Consumable {
	key = 'wheel_of_fortunet',
	set = 'Tarot',
	loc_txt = {
		name = 'Wheel of Fortune\'t',
		text = {
			'Applies a random {C:attention}edition{} to',
            '{C:attention}#1#{} selected joker'
		}
	},
	config = {
        max_highlighted = 1,
    },
	pos = { x = 1, y = 2 },
	cost = 15,
	unlocked = true,
	discovered = true,
	atlas = 'placeholders',
    loc_vars = function(self, info_queue, center, card)
        return {vars = { self.config.max_highlighted }}
    end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
        for i = 1, math.min(#G.jokers.highlighted, self.config.max_highlighted) do
            G.E_MANAGER:add_event(Event({func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                G.hand.highlighted[i]:set_edition(G.P_CENTER_POOLS["Edition"][math.random(1, #G.P_CENTER_POOLS["Edition"])].key, true, true)
                return true end }))
            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
    end
}


SMODS.Consumable {
	key = 'chicot_in_a_tarot',
	set = 'Tarot',
	loc_txt = {
		name = 'Chicot-in-a-Tarot',
		text = {
			'Disables current {C:attention}Boss Blind{} when used'
		}
	},
	config = {
        max_highlighted = 1,
    },
	pos = { x = 1, y = 2 },
	cost = 5,
	unlocked = true,
	discovered = true,
	atlas = 'placeholders',
    loc_vars = function(self, info_queue, center, card)
        return {vars = {  }}
    end,
	can_use = function(self, card)
		return G.GAME.blind and G.GAME.blind.boss
	end,
	use = function(self, card, area, copier)
        if G.GAME.blind and G.GAME.blind.boss then
            G.GAME.blind:disable()
            play_sound('timpani')
            card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('ph_boss_disabled') })
	    end
    end
}


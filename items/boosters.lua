
SMODS.Booster{
    key = 'cracked_joker_booster',
    atlas = 'placeholders', 
    pos = { x = 8, y = 2 },
    discovered = true,
    loc_txt= {
        name = 'Cracked Booster Pack',
        text = {
            "Choose {C:attention}#1#{} out of {C:attention}#2# Cracked Jokers{}",
            "Fixed {C:attention}#3#{} in {C:attention}100{} chance for a {C:attention}Beyond Cracked Joker{}", },
    },
    
    draw_hand = false,
    config = {
        choose = 1,
        extra = 4,
        chance_of_beyond = 1
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra, card.ability.chance_of_beyond } }
    end,

    weight = 0.01,
    cost = 750,
    
    create_card = function(self, card, i)
        if card.ability.chance_of_beyond >= math.random(0, 100) then
		    return create_card("Joker", G.pack_cards, nil, 'r_beyond_cracked', true, true, nil, nil)
        else
		    return create_card("Joker", G.pack_cards, nil, 'r_cracked', true, true, nil, nil)
        end
    end,
    select_card = 'jokers',

    in_pool = function() return true end
}

SMODS.Booster{
    key = 'shape_pack',
    atlas = 'placeholders', 
    pos = { x = 8, y = 2 },
    discovered = true,
    loc_txt= {
        name = 'Shape Pack',
        text = {
            "Choose {C:attention}#1#{} out of {C:attention}#2# Shape Jokers{}", },
    },
    
    draw_hand = false,
    config = {
        choose = 1,
        extra = 2
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    weight = 0.1,
    cost = 4,
    
    create_card = function(self, card, i)
		return create_card("Joker", G.pack_cards, nil, 'r_shape', true, true, nil, nil)
    end,
    select_card = 'jokers',

    in_pool = function() return true end
}

SMODS.Booster{
    key = 'jumbo_shape_pack',
    atlas = 'placeholders', 
    pos = { x = 8, y = 2 },
    discovered = true,
    loc_txt= {
        name = 'Jumbo Shape Pack',
        text = {
            "Choose {C:attention}#1#{} out of {C:attention}#2# Shape Jokers{}", },
    },
    
    draw_hand = false,
    config = {
        choose = 1,
        extra = 4
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    weight = 0.1,
    cost = 6,
    
    create_card = function(self, card, i)
		return create_card("Joker", G.pack_cards, nil, 'r_shape', true, true, nil, nil)
    end,
    select_card = 'jokers',

    in_pool = function() return true end
}

SMODS.Booster{
    key = 'mega_shape_pack',
    atlas = 'placeholders', 
    pos = { x = 8, y = 2 },
    discovered = true,
    loc_txt= {
        name = 'Mega Shape Pack',
        text = {
            "Choose {C:attention}#1#{} out of {C:attention}#2# Shape Jokers{}", },
    },
    
    draw_hand = false,
    config = {
        choose = 2,
        extra = 4
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
    end,

    weight = 0.1,
    cost = 8,
    
    create_card = function(self, card, i)
		return create_card("Joker", G.pack_cards, nil, 'r_shape', true, true, nil, nil)
    end,
    select_card = 'jokers',

    in_pool = function() return true end
}
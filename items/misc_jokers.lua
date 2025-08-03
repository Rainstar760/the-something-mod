-- atlas dump

SMODS.Atlas {
    key = "miscjokers_atlas",
    path = "miscjokers.png",
    px = 71,
    py = 95
}

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
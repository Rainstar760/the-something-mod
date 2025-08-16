
SMODS.Atlas {
	key = "blinds",
    atlas_table = "ANIMATION_ATLAS",
	path = "blinds.png",
	px = 34,
	py = 34,
	frames = 21
}

SMODS.Blind {
	key = "convex",
	loc_txt = {
		name = 'The Convex',
		text = {
			"All Shape Jokers are debuffed"
		}
	},
	pos = { x = 1, y = 0 },
	atlas = "blinds",
	boss = { min = 3 },
    mult = 2,
	dollars = 5,
    boss_colour = HEX("444444"),
	recalc_debuff = function(self, card, from_blind)
		if (card.area == G.jokers) and not G.GAME.blind.disabled and card.config.center.rarity == 'r_shape' then
			return true
		end
		return false
	end,
}
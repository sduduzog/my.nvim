return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure {
			filetyps_denylist = { "telescope" },
		}
	end,
}

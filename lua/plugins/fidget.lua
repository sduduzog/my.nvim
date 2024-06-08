return {
	"j-hui/fidget.nvim",
	tag = "v1.4.5",
	config = function()
		require("fidget").setup {
			progress = {
				display = {
					done_ttl = 1,
				},
			},
		}
	end,
}

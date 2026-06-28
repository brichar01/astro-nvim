return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
	{
        "<leader>ff",
        require("telescope.builtin").find_files, desc = "Telescope find files",
	},
	{
		"<leader>fw", require("telescope.builtin").live_grep, desc = "Telescope find word",
	},
	{
		"<leader>fb", require('telescope.builtin').buffers, desc = "Find buffers",
	},
	{
		'<leader>fh', require('telescope.builtin').help_tags, desc = "Help",
	},
},
}

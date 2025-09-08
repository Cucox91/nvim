return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- telescope bits
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		-- Build a fresh finder from the current harpoon list
		local function make_finder(hlist)
			local file_paths = {}
			for _, item in ipairs(hlist.items) do
				table.insert(file_paths, item.value)
			end
			return finders.new_table({ results = file_paths })
		end

		local function toggle_telescope(hlist)
			pickers
				.new({}, {
					prompt_title = "Harpoon",
					finder = make_finder(hlist),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
					attach_mappings = function(prompt_bufnr, map)
						-- Remove selected entry and refresh WITHOUT closing Telescope
						local function remove_selected()
							local entry = action_state.get_selected_entry()
							if not entry then
								return
							end
							-- prefer index; fall back to value if needed
							if entry.index and harpoon:list().remove_at then
								harpoon:list():remove_at(entry.index)
							else
								local val = entry.value
								if type(val) == "table" and val.value then
									val = val.value
								end
								if type(val) == "string" then
									harpoon:list():remove(val)
								else
									vim.notify("Harpoon: couldn't determine selected entry", vim.log.levels.ERROR)
									return
								end
							end

							local picker = action_state.get_current_picker(prompt_bufnr)
							-- refresh the finder; keep the prompt as-is
							picker:refresh(make_finder(harpoon:list()), { reset_prompt = false })
						end

						-- Your keybind (insert mode). <D-d> is Command-d on macOS.
						map("i", "<D-d>", remove_selected)
						-- Optional extras:
						map("n", "d", remove_selected) -- normal mode "d"
						--map("i", "<C-d>", remove_selected) -- insert mode Ctrl-d

						return true
					end,
				})
				:find()
		end

		vim.keymap.set("n", "<C-e>", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon window" })

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)

		--vim.keymap.set("n", "<C-e>", function()
		--  harpoon.ui:toggle_quick_menu(harpoon:list())
		--end)

		vim.keymap.set("n", "<C-h>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<C-t>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<C-s>", function()
			harpoon:list():select(4)
		end)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end)
	end,
}

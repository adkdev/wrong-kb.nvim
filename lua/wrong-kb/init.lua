local M = {}

--- Default configuration table
--- Users can override these settings via setup({ ... }) or lazy.nvim's opts
local defaults = {
	-- Toggle screen/command-line flash effect on or off
	enable_flash = true,

	-- Toggle display of an icon before the warning message
	enable_icon = true,

	-- Custom icon to prepend to the warning message (e.g., "󰌌 ", "⚠️ ", "󰗖 ")
	icon = "󰌌 ",

	-- Custom message to display in the command line when a non-English key is pressed
	msg = "Please switch your keyboard language to English",

	-- Initial highlight group used for the message (Defaults to WarningMsg from your colorscheme)
	primary_hl = "WarningMsg",

	-- Flash highlight group used during the flash effect (Defaults to ErrorMsg from your colorscheme)
	flash_hl = "ErrorMsg",

	-- Duration of the flash effect in milliseconds
	flash_delay = 250,
}

--- Initialize the plugin with user options
--- @param opts table|nil Configuration options provided by the user
function M.setup(opts)
	-- Merge user provided options with default settings
	local config = vim.tbl_deep_extend("force", defaults, opts or {})

	-- Construct the final message string with or without the icon
	local full_msg = config.msg
	if config.enable_icon and config.icon and config.icon ~= "" then
		full_msg = " " .. config.icon .. " " .. config.msg
	end

	--- Displays the warning message with an optional color flash effect
	local function show_warning()
		if config.enable_flash then
			-- 1. Render message using flash highlight group (e.g., ErrorMsg)
			vim.api.nvim_echo({ { full_msg, config.flash_hl } }, false, {})

			-- 2. Schedule color reversion after specified delay (in milliseconds)
			vim.defer_fn(function()
				vim.api.nvim_echo({ { full_msg, config.primary_hl } }, false, {})
			end, config.flash_delay)
		else
			-- Render static message using primary highlight group
			vim.api.nvim_echo({ { full_msg, config.primary_hl } }, false, {})
		end
	end

	-- Create an autocommand group to prevent duplicate event bindings on reload
	local lang_warn_group = vim.api.nvim_create_augroup("NonEnglishKBWarning", { clear = true })

	-- Register global key listener callback
	vim.on_key(function(key)
		local mode = vim.api.nvim_get_mode().mode

		-- Only check in Normal ('n') and Operator-pending ('no') modes
		if mode ~= "n" and mode ~= "no" then
			return
		end

		-- Filter out Neovim internal special keys / escape sequences
		-- Internal special keys usually start with byte 128 (\128) or byte 27 (ESC)
		local first_byte = string.byte(key, 1)
		if not first_byte or first_byte == 128 or first_byte == 27 then
			return
		end

		local char_code = vim.fn.char2nr(key)

		-- Trigger only for printable non-ASCII characters (e.g., Thai, CJK, Cyrillic, Arabic)
		-- Ignore standard control characters and Neovim special key range
		if char_code > 127 and char_code < 0xF0000 then
			vim.schedule(function()
				show_warning()
			end)
		end
	end, lang_warn_group)
end

return M

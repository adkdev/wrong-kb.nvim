# wrong-kb.nvim

A lightweight and responsive Neovim plugin written in Lua that warns you when typing non-English characters (such as Thai, Chinese, Japanese, Cyrillic, Arabic, etc.) in **Normal Mode** or **Operator-pending Mode**.

Useful for avoiding command errors when you forget to switch your keyboard layout back to English after typing in another window or application.

---

## 💡 Motivation & Background

This plugin was created out of a personal pain point: while working in other applications (such as a browser, chat app, or terminal), I frequently type in Thai. When switching back to Neovim, I often forget to change my keyboard layout back to English and start typing Normal mode commands—leading to unintended behavior or confusion.

Key design decisions:

- **Notification Only**: The goal of this plugin is strictly to **warn/notify** the user when a non-English keypress is detected in Normal or Operator-pending mode. It does **not** attempt to automatically map or translate Thai characters back to English layout equivalents (`langmap`), nor does it auto-switch system input sources.
- **Tested Scope**: This plugin has been primary developed and tested using a **Thai keyboard layout**. However, because the underlying detection logic checks for non-ASCII Unicode characters, it should theoretically work for other non-English language layouts as well.

---

## ⚡ Features

- **Non-English Key Detection**: Automatically captures printable Non-ASCII character inputs without interfering with Neovim internal shortcuts or special keys.
- **Visual Flash Effect**: Briefly flashes the warning message in the Command Line using customizable highlight groups (defaults to `ErrorMsg` and `WarningMsg`).
- **Icon Support**: Optionally display a custom icon (e.g., Nerd Font icons) before the warning text.
- **Zero Dependencies**: Pure Lua implementation using Neovim's built-in `vim.on_key` and API functions.

---

## 📦 Installation

Install using your favorite plugin manager.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
  "adkdev/wrong-kb.nvim",
  event = "VeryLazy",
  opts = {
    enable_flash = true,
    enable_icon = true,
    icon = "󰌌 ",
    msg = "Please switch your keyboard language to English",
    primary_hl = "WarningMsg",
    flash_hl = "ErrorMsg",
    flash_delay = 250,
  },
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "adkdev/wrong-kb.nvim",
  config = function()
    require("wrong-kb").setup({
      enable_flash = true,
      enable_icon = true,
      icon = "󰌌 ",
    })
  end
}
```

### ⚙️ Configuration

Here is the default configuration with all available options:

```lua
require("wrong-kb").setup({
  -- Toggle screen/command-line flash effect on or off
  enable_flash = true,

  -- Toggle display of an icon before the warning message
  enable_icon = true,

  -- Custom icon to prepend to the warning message (requires Nerd Font)
  icon = "󰌌 ",

  -- Custom message to display in the command line
  msg = "Please switch your keyboard language to English",

  -- Highlight group for the static/normal warning state (e.g., WarningMsg, DiagnosticWarn)
  primary_hl = "WarningMsg",

  -- Highlight group for the flash effect state (e.g., ErrorMsg, DiagnosticError)
  flash_hl = "ErrorMsg",

  -- Duration of the flash effect in milliseconds
  flash_delay = 250,
})
```

### 📄 License

MIT

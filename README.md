# 💤 Neovim Config

My personal Neovim configuration, written in Lua and managed with [lazy.nvim](https://github.com/folke/lazy.nvim).  
This repo is meant to be cloned on any machine (macOS, Linux, WSL), with a single script to bootstrap everything.

---

## 📦 Requirements

- [Neovim](https://neovim.io/) **v0.9+**
- [Git](https://git-scm.com/)
- (Optional) [Ripgrep](https://github.com/BurntSushi/ripgrep) for better Telescope search

---

## 🚀 Installation

Clone the repo anywhere you like (I use `~/Repos/nvim`):

# Neovim Config

Opinionated Neovim config optimized for macOS/Linux, Zellij-friendly keymaps, and Telescope-first navigation.

---

## ✅ Requirements

- **Neovim 0.9+** (0.10+ recommended)
- **git**
- macOS or Linux (WSL works too)
- Optional: **ripgrep** (for Telescope live_grep), **fd** (faster file finding)


```bash
# macOS
brew install neovim git ripgrep fd
```

# Debian/Ubuntu
sudo apt update && sudo apt install -y neovim git ripgrep fd-find
# fd on Debian may be 'fdfind'; you can alias it:
command -v fd >/dev/null || sudo ln -s "$(command -v fdfind)" /usr/local/bin/fd

## 🚀 Quick Start

Clone this repo wherever you keep code (e.g., ~/Repos/nvim) and run the installer:

```bash
git clone https://github.com/<YOUR_USERNAME>/nvim.git ~/Repos/nvim
cd ~/Repos/nvim
chmod +x install.sh
./install.sh
```

What it does:
	•	Backs up any existing ~/.config/nvim to ~/.config-backups/nvim.YYYYMMDD-HHMMSS
	•	Symlinks this repo to ~/.config/nvim
	•	Ensures lazy.nvim is installed

Then bootstrap plugins:

```bash
nvim +Lazy\! sync +qa
# After it finishes, start Neovim normally:
nvim
```

## 🧭 Key Things to Know
	•	Leader key: Space
If you use Telescope mappings like <leader>ff, press Space f f.
	•	Zellij users: This config avoids Ctrl-based Telescope mappings by default.
Suggested Telescope mappings:
	•	<leader>ff – Find files
	•	<leader>fg – Live grep
	•	<leader>fb – Buffers
	•	<leader>fr – Recent files
	•	<leader>fh – Help tags


## 🔁 Updating / Syncing

Pull latest config and sync plugins:

```bash
cd ~/Repos/nvim
git pull
nvim +Lazy\! sync +qa
```

If you change plugin versions, commit lazy-lock.json so clones are reproducible.


# 🗂 Repo Layout (recommended)

nvim/
├─ README.md
├─ install.sh
├─ init.lua
├─ lazy-lock.json            # commit this (pins plugin versions)
├─ lua/
│  └─ user/
│     ├─ options.lua
│     ├─ keymaps.lua
│     ├─ autocmds.lua
│     ├─ plugins.lua
│     └─ private.example.lua  # copy to private.lua, keep gitignored
├─ after/
├─ ftplugin/
├─ snippets/
└─ spell/


Git-ignore machine files/secrets:

 .gitignore
lua/user/private.lua
.swap/
.backup/
.undodir/
plugin/packer_compiled.lua
site/

## 🧼 Uninstall / Restore
Your previous config backups live in ~/.config-backups/.

To restore the most recent backup:

```bash
rm -rf ~/.config/nvim
cp -a ~/.config-backups/nvim.* ~/.config/nvim  # pick the timestamp you want
```

Or simply remove this config:

```bash
rm -rf ~/.config/nvim
```

# 🛠 Troubleshooting

“E5113 rhs: expected string|function, got nil” at startup
A keymap likely calls a function instead of passing it:

```lua
-- ❌ wrong
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float(), {})

-- ✅ correct
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, {})
```

“Permission denied” or script won’t run
Make the installer executable:

```bash
chmod +x install.sh
```

Telescope live_grep finds nothing
Ensure ripgrep is installed and on PATH.

Zellij steals Ctrl keys
Stick to <leader> mappings (Space-based). If you must, edit ~/.config/zellij/config.kdl to change/disable conflicting bindings.

## 📦 Installer Script Usage
```bash
./install.sh         # backup old config (if any) and link this repo
./install.sh --force # overwrite existing ~/.config/nvim without backup
```

What it does (summary):
	•	Detects existing ~/.config/nvim, backs it up (unless --force)
	•	Symlinks this repo to ~/.config/nvim
	•	Installs lazy.nvim if missing

## 🧪 Optional: First-Run Health Check

```vim
:checkhealth
```

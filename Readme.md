# Neovim Config

A personal Neovim configuration built on [lazy.nvim](https://github.com/folke/lazy.nvim), providing a full IDE-like experience with LSP, intelligent formatting, linting, testing, and AI assistance.

---

## Table of Contents

- [Fresh Install](#fresh-install)
- [Config Structure](#config-structure)
- [How Everything Works Together](#how-everything-works-together)
  - [Treesitter](#treesitter--syntax-highlighting)
  - [Mason](#mason--package-manager)
  - [LSP](#lsp--language-intelligence)
  - [None-ls](#none-ls--formatting--linting)
  - [Completion](#completion)
- [Language Support](#language-support)
- [Key Commands](#key-commands)
- [Keymaps](#keymaps)
- [Adding a New Language](#adding-a-new-language)

---

## Config Structure

```
~/.config/nvim/
├── init.lua                  # Entry point — loads bootstrap then user config
├── bootstrap.lua             # Pre-plugin globals (leader keys, providers, netrw)
│                             # ⚠️  Must load before lazy.nvim initialises
├── install-deps.sh           # macOS Homebrew setup script
└── lua/
    └── user/
        ├── init.lua          # Loads all modules in order
        ├── options.lua       # Neovim options (tabstop, scrolloff, etc.)
        ├── keymaps.lua       # Global keymaps
        ├── plugins.lua       # lazy.nvim plugin specs
        ├── colorscheme.lua   # Theme setup
        ├── cmp.lua           # Completion (nvim-cmp + LuaSnip)
        ├── treesitter.lua    # Syntax parser config + installed parsers
        ├── nvimtree.lua      # File explorer
        ├── lualine.lua       # Status line
        ├── fzf.lua           # fzf-lua setup
        ├── gitsigns.lua      # Git decorations
        ├── fidget.lua        # LSP progress notifications
        ├── toggleterm.lua    # Integrated terminal
        ├── copilot.lua       # GitHub Copilot config
        ├── refactor.lua      # Refactor.nvim config
        └── lsp/
            ├── init.lua      # Wires up Mason, handlers, null-ls
            ├── mason.lua     # LSP servers + formatter/linter tool lists
            ├── handlers.lua  # on_attach, keymaps, diagnostics, inlay hints
            ├── null-ls.lua   # none-ls sources (formatters & linters)
            └── settings/     # Per-server config overrides
                ├── lua_ls.lua
                ├── ruby_lsp.lua
                ├── terraformls.lua
                └── ...
```

**Load order in `init.lua`:**
```
require "bootstrap"   -- 1. globals that must exist before any plugin loads
require "user"        -- 2. lazy.nvim + all plugins + LSP + keymaps
```

---



### 1. Clone the config

```bash
git clone <repo-url> ~/.config/nvim
```

### 2. Install system dependencies

| Tool | Purpose | Install |
|------|---------|---------|
| [Neovim](https://neovim.io/) v0.11+ | The editor | `brew install neovim` |
| [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter) v0.26.1+ | Compiles syntax parsers | `brew install tree-sitter` |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | fzf-lua live grep | `brew install ripgrep` |
| [fd](https://github.com/sharkdp/fd) | Fast file search for fzf-lua | `brew install fd` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finding | `brew install fzf` |
| C compiler (gcc/clang) | Builds Treesitter parsers | Xcode CLT on macOS |
| [Hack Nerd Font](https://www.nerdfonts.com/) | Icons & special characters | Install via font manager |

> Run `./install-deps.sh` from the repo root to install all Homebrew dependencies at once.

> **Linux only:** install `xclip` for clipboard support.

### 3. Launch Neovim

```bash
nvim
```

On first launch, [lazy.nvim](https://github.com/folke/lazy.nvim) automatically:
- Installs all plugins
- Mason installs all LSP servers, formatters, and linters
- Treesitter downloads and compiles all language parsers

Wait for everything to finish, then restart Neovim. Run `:checkhealth` to verify.

### 4. Language-specific external setup

Some languages require tools **outside of Mason** — see the [Language Support](#language-support) table for details.

---

## How Everything Works Together

Four separate systems collaborate to give you IDE features. Each one has a distinct job:

```
┌──────────────────────────────────────────────────────────────────────┐
│                        init.lua                                      │
│  require "bootstrap"  →  providers, leader keys, netrw (pre-plugin) │
│  require "user"       →  everything below                            │
└───────┬───────────────┬──────────────────┬───────────────────────────┘
        │               │                  │
        ▼               ▼                  ▼
┌───────────────┐ ┌──────────────┐ ┌──────────────────┐
│  Treesitter   │ │     LSP      │ │     None-ls      │
│               │ │              │ │                  │
│ Syntax        │ │ Diagnostics  │ │ Formatting       │
│ highlighting  │ │ Completions  │ │ Extra linting    │
│ Code folding  │ │ Go-to-def    │ │ (runs external   │
│ Text objects  │ │ Hover docs   │ │  CLI tools)      │
│ Indentation   │ │ Rename       │ │                  │
└───────────────┘ └──────┬───────┘ └──────────────────┘
                         │
                  ┌──────▼───────┐
                  │    Mason     │
                  │              │
                  │ Installs &   │
                  │ manages all  │
                  │ the binaries │
                  └──────────────┘
```

---

### Treesitter — Syntax Highlighting

Treesitter **parses your code into a syntax tree**. This is fundamentally different from the old regex-based highlighting — it actually understands the structure of your code.

**What it powers:**
- Accurate, context-aware syntax highlighting
- Smart code folding
- Indentation (for most languages)
- Text objects (select a function, a block, etc.)

Treesitter parsers are compiled native libraries. The `tree-sitter-cli` binary is required to build them. Parsers are auto-installed on first launch from `lua/user/treesitter.lua`.

> ⚠️ Treesitter gives you *highlighting* — it does **not** know about types, errors, or completions. That's LSP's job.

---

### Mason — Package Manager

Mason is the **package manager for developer tools**. It downloads and manages LSP server binaries, formatters, and linters into `~/.local/share/nvim/mason/`.

```
Mason installs tools here:
~/.local/share/nvim/mason/bin/
  ├── lua-language-server     ← LSP server
  ├── pyright                 ← LSP server
  ├── gopls                   ← LSP server
  ├── black                   ← formatter
  ├── stylua                  ← formatter
  ├── pylint                  ← linter
  └── ...
```

Mason **only installs binaries**. It does not configure them or connect them to Neovim. That's the job of `mason-lspconfig` (for LSP) and `mason-null-ls` (for formatters/linters).

---

### LSP — Language Intelligence

The Language Server Protocol (LSP) is a standard that allows editors to talk to language-specific servers for deep code intelligence.

```
┌─────────────────────────────────────────────────────────────────┐
│                         Neovim                                  │
│                                                                 │
│  ┌─────────────┐    ┌──────────────────┐    ┌───────────────┐  │
│  │  vim.lsp    │◄──►│  nvim-lspconfig  │◄──►│ mason-lspcon  │  │
│  │             │    │                  │    │ -fig          │  │
│  │ Built-in    │    │ Knows HOW to     │    │               │  │
│  │ LSP client  │    │ start each       │    │ Tells lspcon  │  │
│  │ (the engine)│    │ server           │    │ WHERE mason   │  │
│  └─────────────┘    └──────────────────┘    │ installed it  │  │
│                                             └───────────────┘  │
└─────────────────────────────────────────────────────────────────┘
        ▲                                           │
        │ JSON-RPC                                  │ binary path
        ▼                                           ▼
┌───────────────┐                        ┌──────────────────────┐
│ Language      │                        │       Mason          │
│ Server        │                        │  (~/.local/share/    │
│ (e.g. gopls)  │                        │   nvim/mason/)       │
└───────────────┘                        └──────────────────────┘
```

**The three LSP components and their roles:**

| Component | Role |
|-----------|------|
| `vim.lsp` | Built-in Neovim LSP engine — speaks the protocol |
| `nvim-lspconfig` | Knows the startup command & options for each server |
| `mason-lspconfig` | Bridges Mason's install paths into lspconfig |

**What LSP provides:** completions, diagnostics, go-to-definition, hover docs, find references, rename, code actions, inlay hints.

---

### None-ls — Formatting & Linting

None-ls (a maintained fork of null-ls) **pretends to be an LSP server** so that standalone CLI tools (black, prettier, stylua, etc.) can plug into Neovim's LSP formatting pipeline without needing a real language server.

```
On BufWritePre (save):

vim.lsp.buf.format()
      │
      ├──► ruby_lsp  (if Ruby file)  → formats via standard addon
      │
      └──► none-ls client            → runs the right CLI tool:
                │
                ├── Python  → black
                ├── Lua     → stylua
                ├── Go      → goimports
                ├── JS/TS   → prettier
                ├── C#      → csharpier
                └── YAML    → yamlfmt
```

> **Why not just use the LSP formatter directly?** Some LSP servers (like `ts_ls` and `lua_ls`) have built-in formatters that don't match your preferred style tool. None-ls lets you override them with the exact tool you want. For those servers, the built-in formatter is explicitly disabled in this config.

---

### Completion

`nvim-cmp` is the completion engine. It aggregates suggestions from multiple sources and displays them in a unified popup.

```
nvim-cmp sources (in priority order):
  1. LSP         ← type/function/variable suggestions from language server
  2. LuaSnip     ← code snippet expansions
  3. Buffer      ← words from open buffers
  4. Path        ← filesystem paths
  5. Cmdline     ← Neovim command completions (in : mode)
```

---

## Language Support

### What the columns mean

| Column | Description |
|--------|-------------|
| **LSP** | Language server providing completions, go-to-def, hover, diagnostics |
| **Formatter** | Tool that auto-formats on save |
| **Linter** | Tool that provides additional diagnostic warnings |
| **Test Runner** | Neotest adapter for running tests inside Neovim |
| **External Setup** | Things you must install/configure *outside* Mason |

---

### Languages

#### 🟢 Mason-only — works out of the box after first launch

| Language | LSP | Formatter | Linter | Test Runner |
|----------|-----|-----------|--------|-------------|
| **Lua** | lua_ls | stylua | — | — |
| **Python** | pyright | black | pylint | — |
| **Go** | gopls | goimports | golangci_lint | neotest-golang |
| **TypeScript / JavaScript** | ts_ls | prettierd | eslint_d¹ | neotest-jest / neotest-vitest² |
| **JSON** | jsonls | prettierd | — | — |
| **HTML** | html + emmet_ls | prettierd | — | — |
| **CSS / SCSS** | — | prettierd | stylelint | — |
| **YAML** | yamlls | yamlfmt | yamllint | — |
| **Bash** | bashls | — | — | — |
| **TOML** | taplo | — | — | — |
| **Terraform / HCL** | terraformls | terraform_fmt | terraformls | — |
| **C#** | csharp_ls | csharpier | — | neotest-vstest |
| **SQL / PostgreSQL** | postgres_lsp | — | — | — |
| **Dockerfile** | dockerls | — | hadolint | — |

> ¹ ESLint diagnostics only activate when `.eslintrc` or `eslint.config.js` is present in the project.
> ² Jest adapter activates with `jest.config.*`; Vitest adapter activates with `vitest.config.*` or `vite.config.*`.

---

#### 🔵 Requires external setup

| Language | LSP | Formatter | Linter | External Requirement |
|----------|-----|-----------|--------|----------------------|
| **Ruby** | ruby_lsp (Mason) | standard (via ruby_lsp) | standard (via ruby_lsp) | Install `standard` gem — see below |

**Ruby setup:**

ruby_lsp uses the `standard` gem as an internal addon for both formatting and linting. Mason installs the `ruby_lsp` binary, but the `standard` gem must be available in your Ruby environment separately (Mason's isolated environment is invisible to ruby_lsp).

Option A — global (works for all projects):
```bash
gem install standard
```

Option B — per project (recommended for teams):
```ruby
# Gemfile
group :development do
  gem "standard"
end
```
```bash
bundle install
```

ruby_lsp checks the project bundle first, then falls back to global gems automatically.

---

#### ⚪ Treesitter-only — highlighting only, no LSP/formatting

These languages have syntax highlighting via Treesitter but no LSP server or formatter configured:

| Language | Highlights | Notes |
|----------|-----------|-------|
| Rust | ✓ | Add `rust_analyzer` via Mason to enable LSP |
| GraphQL | ✓ | — |
| C | ✓ | Add `clangd` via Mason to enable LSP |
| XML | ✓ | — |
| Helm | ✓ | — |
| Make | ✓ | — |
| HTTP | ✓ | — |
| Git files | ✓ | gitcommit, gitconfig, gitignore, gitrebase |
| Diff | ✓ | — |
| Dockerfile | ✓ | dockerls provides LSP; hadolint provides linting |
| Protocol Buffers | ✓ | — |
| SQL | ✓ | postgres_lsp provides LSP for PostgreSQL specifically |
| Regex | ✓ | Embedded in other languages |

---

## Key Commands

| Command | Description |
|---------|-------------|
| `:Lazy` | Open plugin manager — update/install plugins |
| `:Mason` | Open Mason dashboard — manage LSP servers & tools |
| `:TSUpdate` | Update all Treesitter parsers |
| `:LspInfo` | Show LSP clients attached to the current buffer |
| `:NullLsInfo` | Show none-ls sources active in the current buffer |
| `:Neotest summary` | Open test suite explorer |
| `:checkhealth` | Diagnose configuration issues |

---

## Keymaps

### LSP (active when an LSP is attached)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gI` | Go to implementation |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>f` | Format buffer |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code actions |
| `gl` | Open diagnostics float |
| `<leader>lj` | Next diagnostic |
| `<leader>lk` | Previous diagnostic |
| `<leader>ls` | Signature help |
| `<leader>lq` | Send diagnostics to location list |

### Navigation

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file tree |
| `<leader>ff` | Find files (fzf-lua) |
| `<leader>fg` | Live grep (fzf-lua) |
| `<leader>fb` | Browse open buffers (fzf-lua) |

### Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Fugitive (git status) |

### Testing

| Key | Action |
|-----|--------|
| `<leader>tt` | Run nearest test |
| `<leader>tf` | Run all tests in file |
| `<leader>ts` | Toggle test summary |

---

## Adding a New Language

1. **LSP** — add the server name to `lsp_servers` in `lua/user/lsp/mason.lua`. Find the correct name at [mason-lspconfig server list](https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers). Add a settings file to `lua/user/lsp/settings/<server_name>.lua` if needed.

2. **Formatter / Linter** — add the tool name to `lint_and_format` in `lua/user/lsp/mason.lua`, then add the corresponding none-ls source in `lua/user/lsp/null-ls.lua`.

3. **Treesitter** — add the parser name to `parsers_to_install` in `lua/user/treesitter.lua`.

4. **External tools** — if the language requires gems, pip packages, or other system tools outside Mason (like Ruby's `standard` gem), document it in the [External Setup](#-requires-external-setup) section above.

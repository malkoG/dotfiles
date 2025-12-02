# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Tools Managed

### Shell & Terminal
- **zsh** - Primary shell with Oh-My-Zsh, Zinit plugin manager, and Starship prompt
- **Wezterm** - Terminal emulator with custom keybindings and styling
- **Ghostty** - Alternative terminal with TokyoNight theme

### Neovim
Highly customized Neovim setup with 80+ plugins using Lazy.nvim:
- LSP support for Python, TypeScript, Ruby, Rust, Go, and more
- Treesitter for syntax highlighting
- Telescope for fuzzy finding
- AI assistance (Copilot, NeoAI with OpenAI)
- Oil.nvim for file navigation
- Multiple colorschemes (tokyonight, catppuccin, melange, nordic)

### Development Tools
- **mise** - Version manager for Ruby, Node.js, and CLI tools
- **Delta** - Syntax-aware git diff viewer
- **lsd** - Modern ls replacement with git integration
- **fzf** - Fuzzy finder with custom completions
- **zoxide** - Smart directory navigation

### Editors
- **Zed** - Vim mode enabled with One Dark theme

## Directory Structure

```
.
├── automation/              # Ruby scripts for git workflows
├── dot_zshrc                # Zsh configuration
├── dot_gitconfig            # Git config with delta integration
├── private_dot_config/
│   ├── nvim/                # Neovim configuration (54 files)
│   │   ├── lua/
│   │   │   ├── config/      # Core configs (keymaps, options, cmp)
│   │   │   ├── deps/        # Plugin dependencies by category
│   │   │   ├── lsp/         # Language server configurations
│   │   │   ├── plugins/     # Individual plugin configs
│   │   │   └── utilities/   # Custom utilities (scheduler, zettelkasten)
│   │   └── snippets/        # Code snippets
│   ├── wezterm/             # Wezterm terminal config
│   ├── ghostty/             # Ghostty terminal config
│   ├── starship.toml        # Starship prompt config
│   ├── mise/                # Mise version manager config
│   └── zed/                 # Zed editor config
└── dot_local/bin/           # Local executables
```

## Key Features

- **Multi-language LSP** - Intelligent language server switching with support for Deno, Python (Ruff, BasedPyright), Ruby, and more
- **Productivity Tools** - Pomodoro timer, monthly planning, Zettelkasten note-taking
- **Time-based Notifications** - Scheduler for work slots and routine reminders
- **Git Workflow Tools** - Interactive diff browsing, repository comparison scripts
- **Custom FZF Completions** - Enhanced completions for make, git, docker

## Prerequisites

- [chezmoi](https://www.chezmoi.io/install/)
- [Neovim](https://neovim.io/) (0.9+)
- [mise](https://mise.jdx.dev/)
- [Starship](https://starship.rs/)
- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [delta](https://github.com/dandavison/delta)

## Installation

```bash
# Initialize chezmoi with this repository
chezmoi init https://github.com/<username>/dotfiles.git

# Preview changes
chezmoi diff

# Apply the dotfiles
chezmoi apply
```

## License

MIT

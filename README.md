# .dotfiles

One repo, one config for **Fedora (i3)** and **macOS**. [mise](https://mise.jdx.dev) does all of it:
links the dotfiles, installs packages and CLI tools, clones helper repos, and builds the Helix fork.

Everything is declared in [`mise.toml`](mise.toml). There is no install script to maintain.

> Status: this setup lives on the `spike/mise-bootstrap` branch. It is verified with dry-runs on macOS.
> **The Fedora side is untested**; the steps below are the first real run. See [Known gaps](#known-gaps).

## What is in here

| Path | What it holds | Applies on |
|---|---|---|
| `zsh/.zshrc` | zsh config (zinit, p10k, mise activation) | both |
| `tmux/` | `tmux.conf`, resurrect/continuum scripts | both |
| `alacritty/` | `alacritty.toml.tera` (template), themes | both, per-OS values |
| `helix/config.toml.tera`, `helix/languages.toml` | Helix settings | both, per-OS values |
| `helix/steel/` | Steel plugin config for the Helix fork (`init.scm`, `cogs/`, `vim/`, `cog.scm`) | both |
| `i3/` | i3 config and scripts | Linux only |
| `mise.toml` | links, packages, tools, repos, tasks | both |

## Set up Fedora (fresh machine)

Run these as your normal user. `sudo` is asked for when dnf needs it.

**1. Prerequisites**

```sh
sudo dnf install -y git curl
```

**2. Install mise**

```sh
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
mise --version
```

**3. Clone this repo**

```sh
mkdir -p ~/Projects
git clone -b spike/mise-bootstrap git@github.com:gramos93/.dotfiles.git ~/Projects/.dotfiles
cd ~/Projects/.dotfiles
mise trust
```

mise reads `mise.toml` only inside this directory, so run the commands below from here.

**4. Preview** (changes nothing)

```sh
mise bootstrap --dry-run
```

It lists the dnf packages, the repos it would clone, the dotfile links, and the tools it would install.
If a dnf package name is wrong, the dry-run or the real run names it. Fix it in `mise.toml` (see
[Known gaps](#known-gaps)).

**5. Move existing configs out of the way**

`mise dot apply` refuses to overwrite files it does not own. On a fresh install there is usually nothing
to move, but if you already have configs:

```sh
mkdir -p ~/dotfiles-backup
for p in ~/.zshrc ~/.config/tmux ~/.config/helix ~/.config/alacritty ~/.config/i3; do
  [ -e "$p" ] && mv "$p" ~/dotfiles-backup/
done
```

**6. Apply everything**

```sh
mise bootstrap
```

Order, from the mise docs: dnf packages → clone repos (Helix fork, tmux plugin manager) → link dotfiles →
install tools → the `bootstrap` task. That last task installs the tmux plugins, then builds the Helix fork
and installs its Steel plugins. The Helix build is a full `cargo` build: expect several minutes the first time.

It is safe to run again. Parts that already match are skipped.

**7. Nerd Font** (not in the package list; alacritty and tmux icons need it)

```sh
mkdir -p ~/.local/share/fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | tar -xJ -C ~/.local/share/fonts
fc-cache -f
```

**8. Make zsh your login shell**

```sh
chsh -s "$(command -v zsh)"
```

Log out and back in. On the first zsh start, zinit clones its plugins. Pick the i3 session at the login screen.

**9. Check it worked**

```sh
mise dot status                 # every dotfile entry up to date
mise bootstrap packages status  # every package installed
hx --health                     # runtime directory resolves, languages found
tmux                            # no errors; plugins loaded
```

## Set up macOS (existing machine)

macOS already has your old links into the previous checkout, so adopt carefully:

```sh
cd ~/Projects/.dotfiles
git switch spike/mise-bootstrap
mise trust
mise bootstrap --dry-run
```

Things the dry-run will flag:

- `~/.config/alacritty` is a directory symlink into the old checkout. Remove that link first
  (`rm ~/.config/alacritty`), or the templated `alacritty.toml` is written through it.
- The old `~/.config/helix/*.scm` files are regular files. Identical content, but mise will not replace
  them unless you pass `mise dot apply --force`.

When it is clean:

```sh
mise bootstrap
```

## Daily use

| I want to… | Command (run in this repo) |
|---|---|
| See what differs from the repo | `mise dot status` and `mise dot diff` |
| Apply dotfile changes | `mise dot apply` |
| Pull changes from the other machine | `git pull --ff-only && mise bootstrap` |
| Add a CLI tool (same version on both OSes) | `mise use <tool>`, then commit `mise.toml` |
| Add a host package (dnf/brew) | edit `[bootstrap.packages]` in `mise.toml`, then `mise bootstrap packages apply` |
| Upgrade tools | `mise upgrade` |
| Update the Helix fork and rebuild | `mise run helix:update` |
| Rebuild Helix without pulling | `mise run --force helix:build` |
| Reinstall Helix Steel plugins | `mise run helix:plugins` |
| Install tmux plugins | `mise run tmux:plugins` |

`mise use <tool>` writes to the `mise.toml` in the current directory, so run it inside this repo.
Look the tool up first with `mise registry | grep <name>`. If it is not there, use a `[bootstrap.packages]` entry.

Dotfiles that are plain symlinks (`.zshrc`, `tmux.conf`, `languages.toml`, the Steel files) are edited in
place. Templated files (`*.tera`) are rendered copies: edit the `.tera` file in the repo, then run
`mise dot apply`.

## Keeping both machines in step

Both machines use the same branch and the same `mise.toml`. Differences are explicit, in one of three forms:

1. **Per-OS package or tool:** add `os = "linux"` or `os = "macos"` to the entry in `mise.toml`.
   A bare name such as `tmux = "latest"` resolves to dnf on Fedora and brew on macOS. Use
   `names = { dnf = "...", brew = "..." }` when the package names differ.
2. **Per-OS value inside a file:** the `*.tera` templates use `{% if os() == "macos" %}…{% endif %}`.
   Today this covers the Alacritty font size, opacity and Shift+Return binding, and the Helix
   `pasteboard` clipboard provider.
3. **Linux-only files:** the `i3/` entries in `mise.toml` carry `variants = [{ os = "linux", … }]`, so macOS skips them.

`tmux.conf` and `.zshrc` use in-file checks (`if-shell`, `$OSTYPE`) so they stay plain symlinks.

To see every intentional difference: `grep -n -E 'os *=|os\(\)|OSTYPE|uname' mise.toml */* 2>/dev/null`.

## Helix (Steel fork)

Helix runs from a hand-built fork, [`mattwparas/helix`](https://github.com/mattwparas/helix) on branch
`steel-event-system`. No prebuilt binaries exist for it. mise handles the pieces:

| Piece | How |
|---|---|
| Fork checkout | cloned to `~/Projects/personal/helix`, **pinned to a commit** in `[bootstrap.repos]` |
| Rust 1.90.0 | `rust` in `[tools]`, matching the fork's `rust-toolchain.toml` |
| `hx`, `steel`, `forge` | `mise run helix:build` runs `cargo xtask steel` (installs to `~/.cargo/bin`) |
| Runtime directory | `~/.config/helix/runtime` links to the fork's `runtime/` (a `cargo install`ed `hx` finds none otherwise) |
| Steel config | `helix/steel/` is linked file by file into `~/.config/helix` |
| Plugins (native dylibs) | `mise run helix:plugins` runs `forge install` from `helix/steel/` |

`helix:setup` = build + plugins. `helix:update` fetches the branch, fast-forwards the checkout, **rewrites the
pin in `mise.toml`**, rebuilds, and reinstalls plugins. Commit the changed pin afterwards so the other machine
follows. If the checkout has local changes, `helix:update` stops.

`forge install` runs from the repo, not `~/.config/helix`, because forge cannot copy the `runtime` symlink.

The plugin dylibs are compiled per OS, so each machine builds its own.

## Repository layout of `mise.toml`

| Section | Purpose |
|---|---|
| `[dotfiles]` | what gets linked or rendered where |
| `[tools]` | CLI tools and Rust, version-pinned the same on both OSes |
| `[bootstrap.packages]` | host packages: dnf on Fedora, brew and casks on macOS |
| `[bootstrap.repos]` | git checkouts (Helix fork, tpm) |
| `[tasks.*]` | `bootstrap`, `helix:*`, `tmux:plugins` |

## Known gaps

This is a first pass. Expect to adjust on the first Fedora run.

- **Fedora is untested.** Every `dnf:` entry marked `(F)` in `mise.toml` is a best guess at the Fedora 44
  package name (i3 stack, `awscli2`, Helix build dependencies). A wrong name stops the packages step and
  the error names it. Fix the entry and rerun `mise bootstrap`.
- **`libpq`, `tmux`, `btop`** are bare names; mise should resolve them to dnf. Not yet confirmed on Fedora.
- **macOS-only entries with no Fedora mapping yet:** `fnm`, `omp`, `jadx`, `jfrog-cli`, `jid`, `tre-command`,
  `bruno`, `caffeine`, `claude-code`, `devtunnel`, plus `bash`, `coreutils`, `gawk`. Add them as `dnf:`,
  `[tools]` or manual installs when you need them on Fedora.
- **Nerd Font** is installed by hand (step 7); the cask entry only works where Homebrew exists.
- **i3 extras** such as `xinput` (used by the i3 mouse-acceleration line) may need a different package name.
- **Tool duplicates on macOS:** many `[tools]` are also installed by brew there. After adopting mise, remove
  the brew copies (`mise bootstrap packages prune --manager brew --dry-run` previews it) or let `PATH` order decide.
- Secrets are not handled here. Keep tokens out of this repo.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `refusing to overwrite existing files` | move the named files aside (step 5), or `mise dot apply --force` if their content is the same |
| `mise: command not found` after install | `export PATH="$HOME/.local/bin:$PATH"` (the `.zshrc` does this on later shells) |
| `mise ERROR … untrusted` | run `mise trust` in this directory |
| `hx` cannot find its runtime | `hx --health`; `~/.config/helix/runtime` must link to the fork's `runtime/` |
| `forge install` fails on a symlink | run it from `helix/steel/` (`mise run helix:plugins` does) |
| Helix plugins missing on a new OS | `mise run helix:plugins` (dylibs are built per machine) |
| tmux plugins not loaded | `mise run tmux:plugins`, then restart tmux |

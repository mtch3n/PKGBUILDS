# PKGBUILDS

Personal Arch package repository, built by CI and served from GitHub Pages.

## Using it

Append to the end of `/etc/pacman.conf`, after the official repositories.
Nothing here shadows an official package, and on CachyOS the optimised `-v3`
repos must keep precedence:

```ini
[mtch3n]
SigLevel = Optional TrustAll
Server = https://mtch3n.github.io/PKGBUILDS/$arch
```

Then:

```bash
sudo pacman -Sy
sudo pacman -S claude-swap-git
```

> The repository was renamed from `PKGBUILD` to `PKGBUILDS`. If you configured
> it before that, update the `Server` line above — the old Pages URL stops
> serving once this repo's Pages deployment moves.

## Packages

| Package | What it is |
|---|---|
| `claude-swap-git` | Multi-account switcher for Claude Code, [mtch3n fork](https://github.com/mtch3n/claude-swap) — adds Linux desktop notifications and a systemd user service |
| `visual-studio-code-insiders-bin` | VS Code Insiders, official binary repackaged; `pkgver` is auto-bumped hourly by CI |

## Layout

Flat: one top-level directory per package, each containing a `PKGBUILD`.
Anything outside `.github/` and this README is treated as a package.

## How CI works

`build-and-deploy.yml` builds every package in an `archlinux:base-devel`
container, assembles a `repo-add` database, and deploys it to Pages. It runs on
push, daily, and on demand.

Two things worth knowing before editing it:

- **Unchanged packages are reused from cache**, keyed on the hash of the
  package directory. The deployed database is still assembled from *every*
  package — dropping one would break it for anyone who has it installed.
- **`*-git` packages skip that cache and always rebuild**, since their source
  moves without their directory changing. Same reason the workflow runs on a
  schedule.

`update-vscode-insiders.yml` polls Microsoft hourly, rewrites the VS Code
Insiders `pkgver`/URL/checksums, commits, then dispatches `build-and-deploy.yml`
explicitly — a `GITHUB_TOKEN` push does not trigger other workflows.

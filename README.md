# PKGBUILDS

Personal Arch package repository, built by CI and served from GitHub Pages.

## Using it

Append to `/etc/pacman.conf`, after the official repositories:

```ini
[mtch3n]
SigLevel = Optional TrustAll
Server = https://mtch3n.github.io/PKGBUILDS/$arch
```

```bash
sudo pacman -Syu claude-swap-git
```

## Packages

| Package | What it is |
|---|---|
| `claude-swap-git` | Multi-account switcher for Claude Code ([fork](https://github.com/mtch3n/claude-swap) adding desktop notifications and a systemd user service) |
| `xpsctl-git` | CLI for the Arc A370M dGPU power state and Dell EC thermal profile |
| `gnome-shell-extension-xpsctl-git` | GNOME quick-settings toggle for the dGPU, from the same source |
| `xps15-9530-acpi-patch` | SSDT overlay: fixes Dell's CNVW `_DSM` abort, unlocks Wi-Fi 6E. Reboot to apply |
| `xps15-9530-display-color` | Factory panel colour profile. Not published — see below |
| `flatpak-autoupdate` | systemd timer: daily system Flatpak update, prunes unused runtimes |
| `visual-studio-code-insiders-bin` | VS Code Insiders, official binary repackaged; auto-bumped hourly |

## Layout

One top-level directory per package. Anything outside `.github/` and this
README is treated as one.

A directory containing `.ci-skip` is built by hand instead — for sources CI
cannot fetch, like a vendor file you supply locally. `xps15-9530-display-color`
is the only one: Dell's `.icm` is proprietary and not committed, so build it
on the machine with `makepkg -si` after mounting Windows read-only, or with
the profile dropped beside the PKGBUILD.

## CI

`build-and-deploy.yml` builds each package in an `archlinux:base-devel`
container, assembles the database with `repo-add`, and deploys to Pages. Runs
on push, daily, and on demand.

- Unchanged packages are restored from cache, keyed on the directory's
  contents. The database is still assembled from *every* package — dropping
  one would break it for anyone who has it installed.
- Packages with a VCS `source=` skip that cache and always rebuild, since
  their source moves without the directory changing. That is also why the
  workflow runs on a schedule.

`update-vscode-insiders.yml` polls Microsoft hourly, rewrites the VS Code
Insiders `pkgver`/URL/checksums, commits, then dispatches the build
explicitly — a `GITHUB_TOKEN` push does not trigger other workflows.

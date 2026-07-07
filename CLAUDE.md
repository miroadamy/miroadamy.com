# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Source for **miroadamy.com** ("Miro's World"), a personal blog. It is a **Hugo** static site
(`hugo v0.163.0+extended` via Homebrew) using the **Even** theme. This repo holds the *source*;
the generated static HTML is published to two separate hosts (see Deploy).

## Critical setup — submodules

Two git submodules must be initialized before Hugo can build. Both are checked out empty by default,
so a fresh clone will fail to build until you run:

```bash
git submodule update --init --recursive
```

- `themes/even` → the Even theme (https://github.com/olOwOlo/hugo-theme-even). **Hugo build fails without it.**
- `public/` → the GitHub Pages repo `miroadamy.github.io`. Hugo writes its output *into* this submodule,
  and publishing commits/pushes it as a nested repo.

## Hugo compatibility (do not regress)

This 2006-era WordPress-imported blog was revived on modern Hugo (v0.163) on 2026-07-07.
Several deliberate compatibility choices keep it building — don't undo them:

- **The `themes/even` submodule is pinned to upstream `origin/master` (2024-12), NOT a tagged
  release.** The Hugo-compat fixes (removed `.Site.Author`/`.Site.RSSLink`/`_internal/google_news`,
  GA4) landed on `master` only — `v4.1.0` and earlier still break on modern Hugo. **Do not reset
  the theme to a tag.** (The theme is otherwise semi-abandoned; a future move to a maintained theme
  is tracked in the vault under `[[Stampa-Press]]`.)
- `config.toml` carries required compat settings (see its "Compatibility with modern Hugo" block):
  `security.allowContent = ['.*']` (Hugo blocks `text/html` content by default — needed for the
  200+ `.html` posts), `[markup.goldmark.renderer] unsafe = true` (posts embed raw HTML),
  and `[params.author]` (theme reads `.Site.Params.Author.name`).
- Posts no longer carry the WordPress `published:` field — Hugo parsed the bool as a date and
  errored on all 550+ posts. It was removed; `published: false` became `draft: true`.

## Commands

```bash
hugo server -D          # local dev server, includes drafts (draft = true in archetype)
hugo                    # build static site into ./public (the submodule)
./update-status.sh      # regenerate content/status.md (hugo + pygmentize versions, commit hashes)
./github-publish.sh "commit message"   # full publish — see below
```

`update-status.sh` shells out to `pygmentize` (Python Pygments) — it must be on PATH or the status
page generation breaks.

## Deploy (two independent targets)

1. **GitHub Pages (primary)** — via `./github-publish.sh "<msg>"`. This script:
   runs `update-status.sh`, runs `hugo`, then **commits and pushes the `public/` submodule**
   (deploying to `miroadamy.github.io`), then **commits and pushes this source repo**.
   Running it is an outward-facing publish that pushes to two remotes — confirm before invoking.
2. **GitLab Pages** — via `.gitlab-ci.yml`, builds on the `gitlab-pages` branch only, using the
   `monachus/hugo` image with `GIT_SUBMODULE_STRATEGY: recursive`. Independent of the GitHub path.

## Content conventions

- Posts live in `content/posts/` (~556 files). Filename pattern: `YYYY-MM-DD-slug.md` or `.html`.
- Both `.md` and `.html` files are used as post sources — many `.html` posts are raw WordPress-export
  HTML bodies. Preserve the format of the file you're editing; don't convert `.html` posts to Markdown.
- Front matter is **YAML** (`---` delimited), WordPress-export style:
  `layout, title, date, type, published, status, categories, tags, author`.
  (`content/status.md` is the lone TOML/`+++` file — it's machine-generated, don't hand-edit it.)
- New posts: `hugo new posts/YYYY-MM-DD-slug.md` uses `archetypes/default.md` (sets `draft: true`).
- Global site config is `config.toml`; per-post overrides go in front matter (see `archetypes/default.md`
  comment). `config.toml` also pins CDN asset tags under `[params.publicCDN]`.

## Notes

- The working tree often carries a large number of modified post files (line-ending / normalization
  churn). Check `git diff` intent before committing a mass change.

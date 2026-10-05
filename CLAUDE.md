# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Source for **miroadamy.com** ("Miro's World"), a personal blog. It is a **Hugo** static site
(`hugo v0.166.0+extended` via Homebrew) using the **Blowfish** theme (v3.8.0, submodule
`themes/blowfish`; the former **Even** theme is still checked out under `themes/even` but unused
since 2026-08-22). This repo holds the *source*;
the generated static HTML is pushed to `miroadamy.github.io`, from where Cloudflare Pages serves
www.miroadamy.com (GitHub Pages stays on as the rollback) — see Deploy.

## Critical setup — submodules

Two git submodules must be initialized before Hugo can build. Both are checked out empty by default,
so a fresh clone will fail to build until you run:

```bash
git submodule update --init --recursive
```

- `themes/blowfish` → the Blowfish theme (https://github.com/nunocoracao/blowfish), pinned to the
  `v3.8.0` tag. **Hugo build fails without it** (`config.toml` sets `theme = "blowfish"`).
- `themes/even` → the former Even theme (https://github.com/olOwOlo/hugo-theme-even), kept as a
  submodule for history only; nothing in `config.toml` references it.
- `public/` → the GitHub Pages repo `miroadamy.github.io`. Hugo writes its output *into* this submodule,
  and publishing commits/pushes it as a nested repo.

## Hugo compatibility (do not regress)

This 2006-era WordPress-imported blog was revived on modern Hugo (v0.163) on 2026-07-07.
Several deliberate compatibility choices keep it building — don't undo them:

- Historical, Even era (2026-07 to 2026-08-22): the `themes/even` submodule is pinned to upstream
  `origin/master` (2024-12), NOT a tagged release, because the Hugo-compat fixes (removed
  `.Site.Author`/`.Site.RSSLink`/`_internal/google_news`, GA4) landed on `master` only. If Even is
  ever reused, do not reset it to a tag. The theme move to Blowfish is logged in the vault under
  `[[Stampa-Press]]`.
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

1. **Cloudflare Pages (serves www.miroadamy.com since 2026-10-03)** — via `./github-publish.sh "<msg>"`.
   This script: runs `update-status.sh`, runs `hugo`, then **commits and pushes the `public/` submodule**
   to `miroadamy.github.io`, then **commits and pushes this source repo**.
   Running it is an outward-facing publish that pushes to two remotes — confirm before invoking.
   The push to `miroadamy.github.io` (branch `master`) is picked up by the Cloudflare Pages project
   `miroadamy-github-io` (Git integration, no build step, output directory `/`), which deploys it
   within a few minutes. Preview address: https://miroadamy-github-io.pages.dev. There is no
   wrangler, no API token and no Cloudflare step in this repo; the script is the whole deploy.
   Verified 2026-10-04 on the first publish after the switch: the new post was live on www within
   27 minutes of the push with no manual step, byte-identical to the pages.dev address, and the GitHub
   Pages origin had it 50 s after the push (so the rollback target is always current).
   - **GitHub Pages is still enabled on `miroadamy.github.io` as the standby rollback.** It receives
     every publish too. DNS in Cloudflare: `www` CNAME → `miroadamy-github-io.pages.dev` (Pages);
     apex `miroadamy.com` CNAME → `miroadamy.github.io` (GitHub, which 301s the apex to `https://www.`).
   - **Revert to GitHub Pages**: in the Cloudflare DNS page for miroadamy.com
     (`https://dash.cloudflare.com/?to=/:account/:zone/dns/records`) edit the `www` row to
     CNAME `miroadamy.github.io`, Proxied, TTL Auto. Nothing in this repo changes. Verify with
     `curl -sI https://www.miroadamy.com/ | grep -i x-github-request-id` (a value = GitHub again).
     Full procedure and clean-up steps: vault note `[[Stampa-Press]]`, section "Hosting".
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

## Content editing policy (Miro's rule, 2026-08-22)

- **Never generate, rewrite, or restyle blog content** (posts, notes, pages) unless Miro
  explicitly asks for it in the current conversation. The imperfect, human sound of the
  writing is intentional and must be preserved.
- **Fixing grammar, typos, spelling, and punctuation is always okay** — list every fix
  made so Miro can veto.
- If a passage reads oddly, **offer 2-3 suggestions and stop** — never apply a style or
  wording change without Miro's go-ahead.
- Legacy posts (2006-2021) are a historical record, written without AI — do not "improve"
  them at all.

## Notes

- The working tree often carries a large number of modified post files (line-ending / normalization
  churn). Check `git diff` intent before committing a mass change.

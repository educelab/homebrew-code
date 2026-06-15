# Educelab Code

## How do I install these formulae?

`brew install educelab/code/<formula>`

Or `brew tap educelab/code` and then `brew install <formula>`.

## Updating formulae

### Automatic (scheduled)

`bump.yml` runs daily and opens a PR for any outdated formula. After the
`brew test-bot` CI passes, a maintainer must manually add the **`pr-pull`**
label to trigger bottle publishing and merge via `publish.yml`.

### Manual

To bump a formula outside the schedule, trigger the **Bump formulae**
workflow from the Actions tab (optionally specifying one or more formula
names), then label the resulting PR with **`pr-pull`** once CI is green.

> **Note:** The `pr-pull` label must be applied by hand. Automatic labeling
> was intentionally removed because it bypassed maintainer review by
> triggering publish immediately after CI passed.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

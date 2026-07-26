# DefAI Digital Homebrew Tap

Official Homebrew formulae and casks for public software maintained by
[DefAI Digital](https://github.com/defai-digital).

## Install

Use a fully qualified package name. Homebrew adds this tap automatically:

```bash
# AutomatosX CLI
brew install defai-digital/tap/ax

# AX Code CLI and Desktop
brew install defai-digital/tap/ax-code
brew install --cask defai-digital/tap/ax-code-desktop

# AX Engine
brew install defai-digital/tap/ax-engine

# AX Studio
brew install --cask defai-digital/tap/ax-studio

# AX BI Desktop
brew install --cask defai-digital/tap/ax-bi
```

Alternatively, add the tap once and then use short package names:

```bash
brew tap defai-digital/tap
brew install ax-code
brew install --cask ax-studio
```

## Packages

| Package | Type | Project |
| --- | --- | --- |
| `ax` | Formula | [AutomatosX](https://github.com/defai-digital/automatosx) |
| `ax-code` | Formula | [AX Code](https://github.com/defai-digital/ax-code) |
| `ax-code-desktop` | Cask | [AX Code Desktop](https://github.com/defai-digital/ax-code/tree/main/desktop) |
| `ax-engine` | Formula | [AX Engine](https://github.com/defai-digital/ax-engine) |
| `ax-studio` | Cask | [AX Studio](https://github.com/defai-digital/ax-studio) |
| `ax-bi` | Cask | [AX BI](https://github.com/defai-digital/ax-bi) |

`mlx` and `mlx-c` are tap-local AX Engine dependencies. They intentionally
build from source with the deployment-target configuration required by
AX Engine and should normally be installed through `ax-engine`.

## Update

```bash
brew update
brew upgrade ax-code ax-engine
brew upgrade --cask ax-code-desktop ax-studio ax-bi
```

## Migration from legacy taps

The former product-specific taps have moved here:

- `defai-digital/ax-code`
- `defai-digital/ax-code-desktop`
- `defai-digital/ax-engine`
- `defai-digital/ax-studio`
- `defai-digital/ax-bi`

Those repositories contain Homebrew migration metadata so existing
installations move to `defai-digital/tap` during `brew update`. New
documentation and automation should use only this tap.

## Release maintenance

Each product repository owns its release artifacts and updates only its
corresponding file in this tap. Formulae and casks are distribution metadata;
the signed release binaries remain in each product's GitHub Releases.

Before publishing a change, run:

```bash
ruby -c Formula/<formula>.rb
brew audit --strict --formula defai-digital/tap/<formula>
brew audit --cask --strict defai-digital/tap/<cask>
```

## Package licenses

Each installed package retains the license declared by its source project and
recipe. The tap repository's own maintenance files are licensed under
Apache-2.0.

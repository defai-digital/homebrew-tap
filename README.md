# Homebrew Tap for AutomatosX

This is the official Homebrew tap for [AutomatosX](https://github.com/defai-digital/automatosx), a contract-first AI orchestration platform with multi-provider routing.

## Installation

```bash
# Add the tap
brew tap defai-digital/tap

# Install AutomatosX CLI
brew install ax

# Or in one command
brew install defai-digital/tap/ax
```

## Usage

```bash
ax setup        # One-time global setup
ax init         # Initialize in current project
ax doctor       # Check provider health
ax --help       # See all commands
```

## Requirements

- macOS with Homebrew
- Node.js 20+ (installed automatically as dependency)

## Updating

```bash
brew update
brew upgrade ax
```

## Documentation

- [AutomatosX GitHub](https://github.com/defai-digital/automatosx)
- [AutomatosX Documentation](https://github.com/defai-digital/automatosx#readme)

## License

BUSL-1.1

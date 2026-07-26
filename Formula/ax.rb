# typed: false
# frozen_string_literal: true

# Homebrew formula for AutomatosX CLI
# https://github.com/defai-digital/automatosx
#
# Installation:
#   brew tap defai-digital/tap
#   brew install ax
#
# Usage:
#   ax --help
#   ax setup
#   ax doctor

class Ax < Formula
  desc "Contract-first AI orchestration platform with multi-provider routing"
  homepage "https://github.com/defai-digital/automatosx"
  url "https://registry.npmjs.org/@defai.digital/cli/-/cli-13.4.8.tgz"
  sha256 "8321a0f56d707c4945e5ca03937712d53bb81ecb63f1accee480633c866b0435"
  license "BUSL-1.1"

  # Requires Node.js 20+
  depends_on "node@20"

  def install
    system "npm", "install", *std_npm_args

    # Create wrapper scripts that set NODE_PATH correctly
    # This ensures the CLI can find its dependencies
    (bin/"ax").write <<~EOS
      #!/bin/bash
      export NODE_PATH="#{libexec}/lib/node_modules"
      exec "#{formula_opt_bin("node@20")}/node" "#{libexec}/lib/node_modules/@defai.digital/cli/dist/bin.js" "$@"
    EOS

    (bin/"automatosx").write <<~EOS
      #!/bin/bash
      export NODE_PATH="#{libexec}/lib/node_modules"
      exec "#{formula_opt_bin("node@20")}/node" "#{libexec}/lib/node_modules/@defai.digital/cli/dist/bin.js" "$@"
    EOS
  end

  def caveats
    <<~EOS
      AutomatosX CLI has been installed!

      Quick start:
        ax setup        # One-time global setup
        ax init         # Initialize in current project
        ax doctor       # Check provider health

      For AI providers, install their CLIs separately:
        - Claude: npm install -g @anthropic-ai/claude-code
        - Gemini: npm install -g @anthropic-ai/gemini-cli
        - Codex:  npm install -g @openai/codex

      Documentation: https://github.com/defai-digital/automatosx
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ax --version")
    assert_match "AutomatosX", shell_output("#{bin}/ax --help")
  end
end

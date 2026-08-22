#!/bin/bash
# FPO27 — Machine Setup Script
# Run once on any new machine after cloning the repo

set -e

echo "Setting up FPO27 development environment..."

# 1. Git identity (edit these if needed)
git config user.name "HALAMADRID975"
git config user.email "ranihazan7@gmail.com"

# 2. macOS Keychain as credential helper (prompts for token once, then saves)
git config credential.helper osxkeychain

# 3. Set remote with correct GitHub username
git remote set-url origin https://HALAMADRID975@github.com/HALAMADRID975/Football-Pack-Opening-26.git

# 4. Install post-commit hook (auto-push on every commit)
cat > .git/hooks/post-commit << 'EOF'
#!/bin/sh
git push origin main
EOF
chmod +x .git/hooks/post-commit

echo ""
echo "✓ Setup complete."
echo ""
echo "Next step: make a test commit to trigger a push."
echo "You'll be asked for your GitHub password — use your Personal Access Token."
echo "It will be saved to Keychain and you won't be asked again."

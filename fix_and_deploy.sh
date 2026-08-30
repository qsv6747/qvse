#!/bin/bash

echo "[*] Starting automated fix and deployment..."

# 1. Fix the pnpm modulepreload filename mismatch in index.html
if [ -f "index.html" ]; then
    sed -i 's/\.pnpm-/pnpm-/g' index.html
    echo "[+] Fixed .pnpm- filename references in index.html"
else
    echo "[-] Error: index.html not found in current directory!"
    exit 1
fi

# 2. Ensure .nojekyll exists to bypass Jekyll processing on GitHub Pages
touch .nojekyll
echo "[+] Ensured .nojekyll file exists"

# 3. Add a basic 404.html fallback for SPA routing if missing
if [ ! -f "404.html" ]; then
    cp index.html 404.html
    echo "[+] Created 404.html fallback from index.html"
fi

# 4. Git operations: stage, commit, and push changes
git add .
git commit -m "Auto-fix: resolve pnpm paths and prep for GitHub Pages deployment"

echo "[+] Pushing updates to GitHub..."
git push origin main || git push origin master

echo "[*] Done! Check your GitHub Pages deployment status in a few moments."


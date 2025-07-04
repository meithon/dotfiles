#!/usr/bin/env bash
# Manage secrets via git-secret

set -euo pipefail

print_usage() {
  cat <<USAGE
Usage: $0 <command> [args]

Commands:
  init [KEY ...]      Initialize git-secret and authorize GPG keys (e.g. email or key IDs)
  add <file>...       Add secret file(s) to git-secret path mappings
  hide                Encrypt all added secrets
  reveal              Decrypt all secrets
  help                Show this usage message
USAGE
}

cmd="${1:-help}"
shift || true

case "$cmd" in
  update)
    changed_files=$(ls -la ./secrets/)

    for file in $changed_files; do
      # skip extension is .secret
      if [[ "$file" == *.secret ]]; then
          continue
      fi
      if [ "$file" = "./secrets/*" ]; then
        git secret add "$file"
      fi
    done
    git secret hide
    ;;
  help)
    print_usage
    ;;
  *)
    echo "Unknown command: $cmd"
    print_usage
    exit 1
    ;;
esac

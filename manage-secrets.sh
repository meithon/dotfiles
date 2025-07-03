#!/usr/bin/env bash
# Manage secrets via git-secret

set -euo pipefail

print_usage() {
  cat <<USAGE
Usage: \$0 <command> [args]

Commands:
  init [KEY ...]      Initialize git-secret and authorize GPG keys (e.g. email or key IDs)
  add <file>...       Add secret file(s) to git-secret path mappings
  hide                Encrypt all added secrets
  reveal              Decrypt all secrets
  help                Show this usage message
USAGE
}

cmd="\${1:-help}"
shift || true

case "\$cmd" in
  init)
    git secret init
    if [ "\$#" -eq 0 ]; then
      echo "No GPG keys specified. Please provide at least one key ID or email."
      exit 1
    fi
    git secret tell "\$@"
    ;;
  add)
    if [ "\$#" -eq 0 ]; then
      echo "No files specified to add"
      exit 1
    fi
    git secret add "\$@"
    ;;
  hide)
    git secret hide
    ;;
  reveal)
    git secret reveal
    ;;
  help)
    print_usage
    ;;
  *)
    echo "Unknown command: \$cmd"
    print_usage
    exit 1
    ;;
esac

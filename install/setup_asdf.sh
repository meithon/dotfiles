setup_asdf() {
  local list=(
    "deno"
    "golang"
    "nodejs"
    "python"
    "rust"
  )

  # Check if asdf is installed
  if ! command -v asdf &>/dev/null; then
    echo "Error: asdf is not installed. Please install it first."
    return 1
  fi

  for lang in "${list[@]}"; do
    (
      asdf plugin add "$lang"
      asdf install "$lang" latest
      asdf global "$lang" latest
      info "Installed asdf $lang"
    )
  done

  (
    asdf plugin add java
    asdf install java openjdk-21.0.2
    asdf global java openjdk-21.0.2
  )
  wait

  rm -rf ~/.asdf/downloads/*
  rm -rf ~/.asdf/tmp/*
  rm -rf ~/.asdf/cache/*
}
setup_asdf

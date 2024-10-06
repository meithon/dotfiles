# Declare ASDF_DIR variable
ASDF_DIR=""

# Check the operating system type
case "$OSTYPE" in
linux*)
  # In Linux
  ASDF_DIR="$HOME/.asdf"
  ;;
darwin*)
  # In macOS
  ASDF_DIR="/opt/homebrew/opt/asdf/libexec"
  PATH="/opt/homebrew/bin:$PATH"
  export PATH
  ;;
*)
  # Unsupported operating system
  echo "Error: Unsupported operating system: $OSTYPE" >&2
  exit 1
  ;;
esac

# Check if ASDF_DIR is set
if [ -z "$ASDF_DIR" ]; then
  echo "Error: Failed to set ASDF_DIR" >&2
  exit 1
fi

# Check if asdf.sh exists
if [ ! -f "$ASDF_DIR/asdf.sh" ]; then
  echo "Error: $ASDF_DIR/asdf.sh not found" >&2
  exit 1
fi

# Source the asdf.sh file
. "$ASDF_DIR/asdf.sh"

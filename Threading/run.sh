set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

LLVM_INSTALL_DIR="./../../llvm-project/build"

. "$SCRIPT_DIR/enable.sh" "$LLVM_INSTALL_DIR"

export TIMING=1

python main.py

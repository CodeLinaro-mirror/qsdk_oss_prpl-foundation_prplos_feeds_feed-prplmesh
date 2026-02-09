#!/bin/bash
# Complete prplOS build setup script
# Usage:
#   export PRPLOS_TOOLCHAIN=/path/to/toolchain  # Optional: set custom toolchain path
#   source setup_prplos_build.sh [target]
# Example: source setup_prplos_build.sh ipq54xx

SCRIPT_DIR_RESOLVED="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

if [ -n "${SCRIPTS_DIR:-}" ]; then
    echo "SCRIPTS_DIR found: $SCRIPTS_DIR"
    PRPL_SETUP_DIR="$SCRIPTS_DIR"
    QSDK_DIR="$(cd "$PRPL_SETUP_DIR/../qsdk" && pwd)"
    TOOLCHAIN_BASE="$(cd "$QSDK_DIR/.." && pwd)/toolchain"
else
    echo "SCRIPTS_DIR not found, using local path"
    PRPL_SETUP_DIR="$SCRIPT_DIR_RESOLVED"
    QSDK_DIR="$(cd "$PRPL_SETUP_DIR/../../../../.." && pwd)"
    TOOLCHAIN_BASE="$(cd "$QSDK_DIR/.." && pwd)/toolchain"
fi

echo "SCRIPT_DIR_RESOLVED=$SCRIPT_DIR_RESOLVED"
echo "PRPL_SETUP_DIR=$PRPL_SETUP_DIR"
echo "QSDK_DIR=$QSDK_DIR"
echo "TOOLCHAIN_BASE=$TOOLCHAIN_BASE"

# Get target from argument or use default
TARGET="${1:-ipq54xx}"
SUBTARGET="generic"

# Determine architecture based on target
case "$TARGET" in
    ipq53xx|ipq54xx|ipq95xx)
        ARCH="64"
        ;;
    *)
        echo "ERROR: Unknown target '$TARGET'"
        echo "Supported targets: ipq53xx, ipq54xx, ipq95xx"
        return 1
        ;;
esac

echo "=========================================="
echo "Configuration"
echo "=========================================="
echo "Target: $TARGET"
echo "Architecture: $ARCH"
echo "Subtarget: $SUBTARGET"
echo "QSDK Directory: $QSDK_DIR"

# Check if PRPLOS_TOOLCHAIN is already set in environment
if [ -z "${PRPLOS_TOOLCHAIN:-}" ]; then
    # Try to auto-detect toolchain path
    PRPLOS_TOOLCHAIN="$TOOLCHAIN_BASE/aarch64-prpl-linux/prplos-toolchain-${TARGET}-${SUBTARGET}_gcc-13.3.0_musl.Linux-x86_64/toolchain-aarch64_cortex-a55+neon-vfpv4_gcc-13.3.0_musl"
    
    # Fallback to ipq54xx if specific target toolchain doesn't exist
    if [ ! -d "$PRPLOS_TOOLCHAIN" ]; then
        echo "Target-specific toolchain not found, trying ipq54xx fallback..."
        PRPLOS_TOOLCHAIN="$TOOLCHAIN_BASE/aarch64-prpl-linux/prplos-toolchain-ipq54xx-generic_gcc-13.3.0_musl.Linux-x86_64/toolchain-aarch64_cortex-a55+neon-vfpv4_gcc-13.3.0_musl"
    fi
fi

if [ ! -d "$PRPLOS_TOOLCHAIN" ]; then
    echo "ERROR: prplOS toolchain not found at: $PRPLOS_TOOLCHAIN"
    echo ""
    echo "Please either:"
    echo "  1. Set PRPLOS_TOOLCHAIN environment variable:"
    echo "     export PRPLOS_TOOLCHAIN=/path/to/prplos/toolchain"
    echo "  2. Ensure toolchain exists at: $TOOLCHAIN_BASE"
    echo ""
    return 1
fi

echo "Toolchain: $PRPLOS_TOOLCHAIN"

export CMAKE_AR="$PRPLOS_TOOLCHAIN/bin/aarch64-openwrt-linux-musl-ar"
export CMAKE_RANLIB="$PRPLOS_TOOLCHAIN/bin/aarch64-openwrt-linux-musl-ranlib"
export CMAKE_NM="$PRPLOS_TOOLCHAIN/bin/aarch64-openwrt-linux-musl-nm"

echo ""
echo "  CMAKE variables set"
echo "  CMAKE_AR=$CMAKE_AR"
echo "  CMAKE_RANLIB=$CMAKE_RANLIB"
echo "  CMAKE_NM=$CMAKE_NM"
echo ""
echo "=========================================="
echo "Ready to run ext-toolchain"
echo "=========================================="

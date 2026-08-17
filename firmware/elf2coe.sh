#!/usr/bin/env bash
set -euo pipefail


IN_ELF="firmware.elf"
IN_BIN="firmware.bin"

OUT_COE="firmware.coe"
SIZE=65536  # 64 KiB total

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT
bin="$tmpdir/image.bin"

# 1) Get a raw 64 KiB binary

if [[ -f "$IN_ELF" ]]; then
  # prefer RISC-V objcopy, fall back to generic objcopy
  if command -v riscv32-unknown-elf-objcopy >/dev/null 2>&1; then
    objcopy=riscv32-unknown-elf-objcopy

  elif command -v objcopy >/dev/null 2>&1; then
    objcopy=objcopy
  else
    echo "error: objcopy not found (install riscv64-elf-binutils)" >&2
    exit 1
  fi
  "$objcopy" -O binary "$IN_ELF" "$bin"
elif [[ -f "$IN_BIN" ]]; then
  cp "$IN_BIN" "$bin"
else
  echo "error: neither $IN_ELF nor $IN_BIN found" >&2
  exit 1
fi

# pad or truncate to exactly 64 KiB
truncate -s $SIZE "$bin"


# 2) Emit COE: 32-bit words, one per line, hex (8 digits), little-endian
{
  echo "memory_initialization_radix=16;"
  echo "memory_initialization_vector="

  # xxd makes 4 bytes per line (-c 4). We then reverse byte order per word.
  # Example: 13000000 -> 00000013
  xxd -p -c 4 "$bin" | awk '
    {
      w=$0
      rev=substr(w,7,2) substr(w,5,2) substr(w,3,2) substr(w,1,2)

      lines[NR]=rev

    }
    END{

      for(i=1;i<=NR;i++){
        if(i<NR) printf("%s,\n", lines[i]); else printf("%s;\n", lines[i])

      }
    }'
} > "$OUT_COE"

echo "wrote $OUT_COE (32-bit words, 64 KiB total)"



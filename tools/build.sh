#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
: "${BB_HOME:=${bB:-}}"
if [[ -z "$BB_HOME" ]]; then
  echo 'Set BB_HOME to a native batari Basic installation.' >&2
  exit 1
fi
BB_HOME="$(cd -- "$BB_HOME" && pwd)"
assembler="${DASM:-$(command -v dasm || true)}"
if [[ -z "$assembler" ]]; then echo 'Set DASM or put dasm on PATH.' >&2; exit 1; fi
assembler="$(realpath -- "$assembler")"
build_tmp="$(mktemp -d)"
trap 'rm -rf -- "$build_tmp"' EXIT
mkdir -p -- "$project_dir/builds"
cd -- "$build_tmp"
{
  "$BB_HOME/preprocess" < "$project_dir/src/main.bas" | "$BB_HOME/2600basic" -i "$BB_HOME" > bB.asm
  "$BB_HOME/postprocess" -i "$BB_HOME" > game.asm
  "$assembler" game.asm -I"$BB_HOME/includes" -f3 -p20 -ogame.bin -sgame.sym
  test "$(wc -c < game.bin)" -eq 4096
} 2>&1 | tee "$project_dir/builds/build.log"
cp -- game.bin "$project_dir/builds/LEGO_Block_World.bin"
cp -- game.sym "$project_dir/builds/LEGO_Block_World.sym"
echo 'Built builds/LEGO_Block_World.bin (4096 bytes).'

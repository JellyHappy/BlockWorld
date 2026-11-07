# LEGO Minifigure: Block World Adventures

An unofficial Atari 2600 fan homebrew, built as a complete, compact six-room adventure. The year **1983 is fictional**; this is a modern homebrew prototype.

## Play now

Open `builds/LEGO_Block_World.bin` in an Atari 2600 emulator such as [Stella](https://stella-emu.github.io/). This is a real **4,096-byte NTSC 4K cartridge ROM**, not a desktop executable. No bank switching, cartridge RAM, or BIOS is required.

Press Fire on the title screen to start. The title reads BLOCK WORLD. The title score shows the chosen mode: 000001 = solo; 000002 = two-player relay.

| Control | Action |
| --- | --- |
| Joystick Left / Right | Walk |
| Fire | Jump; release before jumping again |
| Up | Build, rescue, or enter the portal |
| Reset switch | Return to title |
| Select switch, at title | Toggle solo / relay |

In Stella, the usual first-joystick defaults are arrow keys and Space for Fire; F1 is Reset and F2 is Select. Emulator key maps can be customized. Gamepad directions and Fire work when assigned to joystick port 1.

## How to win

1. Collect the low brick near your starting position.
2. Jump right onto the raised platform to collect the next brick. Continue right to the third brick near the platform's edge. Only the current collectible is shown.
3. Press Up after all three bricks are collected. A permanent bridge fills the central pit.
4. Cross the bridge. Jump onto the patrol bot from above. Side contact costs a life. In the final fortress, the Brick Master takes **three stomps**. Stomping automatically bounces you upward.
5. The defeated enemy reveals a friend. Stand beside the friend on the ground and press Up to rescue them.
6. Walk to the far-right vertical portal marker and press Up. The bridge and rescue must both be complete.
7. Finish all six worlds to recover the Golden Building Brick and see **YOU WIN**. Release and press Fire to return to the title.

Top-left blocks count the current world (one through six); the top-right bar shows remaining lives. You have three lives for the campaign. Collected pieces, defeated enemies, and the built bridge survive a lost life in the current world. Falling in the pit always costs a life. On game over, a red cross appears; Fire restarts at the title.

Relay mode is **shared-controller, shared-score, shared-lives** cooperative play: pass joystick 1 to the other player after a death. A score-color change marks the handoff. There are no independent player inventories, second-controller input, or simultaneous multiplayer.

## Worlds

| # | World | Palette | Raised ledge, x range | Enemy HP |
| --- | --- | --- | --- | --- |
| 1 | LEGO City | Blue / gray | 36–60 | 1 |
| 2 | Blocky Forest | Green / green | 40–64 | 1 |
| 3 | Roblox Obstacle Course | Blue / cyan | 32–56 | 1 |
| 4 | Brick Desert | Sand / orange | 44–68 | 1 |
| 5 | Block Castle | Purple / stone | 36–60 | 1 |
| 6 | Brick Master's Fortress | Dark / red | 40–64 | 3 |

Each world is one small room using the same platform/build/rescue loop. Palettes and ledge placement vary; the final enemy has extra health. Freeform construction, scrolling maps, treasure systems, climbing, and cinematic story scenes are outside this 4K version.

## Source layout

**Compile only `src/main.bas`.** It contains the entire game, all sprites, and compact world tables. The other `.bas` files are extracted, commented reference fragments; they are not separate compiler inputs and must not be included again.

`assets/` contains readable sprite and map definitions. `docs/` contains controls, design, validation results, and emulator captures. `tools/` contains a native build script and a headless ROM verification script. `builds/` contains the playable ROM, debugger symbols, build log, and checksum.

## 8bitworkshop import

Open [8bitworkshop](https://8bitworkshop.com), choose Atari 2600 / batari Basic, and create a source using the **batari Basic tool**, not the 6502 assembler. Paste the complete contents of `src/main.bas`. Some versions identify this tool by the `.bataribasic` extension; if needed, name the editor file `main.bataribasic`. Do not add the reference fragments to the compilation. The source has no external game includes or assets.

The hosted site returned HTTP 403 in the development browser, so this delivery was **compiled and tested locally**, rather than inside its live editor. Compatibility with that site's currently deployed compiler was not verified. Native build instructions below are the verified route.

## Rebuild locally

Install [batari Basic](https://github.com/batari-Basic/batari-Basic) and [DASM](https://github.com/dasm-assembler/dasm). On Windows, the normal batari Basic command is `2600bas src\main.bas`; copy its resulting `.bin` into `builds` if desired.

On Linux/macOS with native compiler executables:

```bash
BB_HOME=/absolute/path/to/batari-Basic DASM=/absolute/path/to/dasm bash tools/build.sh
```

The script compiles in a temporary directory and writes the ROM, symbol file, and log to `builds/`. It fails on compilation/assembly errors or a ROM size other than 4,096 bytes.

Verified toolchain: batari Basic 1.9 (`efd6dcd319c31a5e37afb00d47c981105998d924`), DASM 2.20.14.1. Runtime validation uses Javatari 0.91 as bundled by 8bitworkshop (`fd16951ea21379d6ed37845d034ee2ce14d62bb6`). See `docs/TEST_REPORT.md` for the exact scope and test command.

## Unofficial fan project

Not sponsored, endorsed, or licensed by LEGO, Roblox, or Atari. Names and trademarks belong to their respective owners. The included license covers original code/assets only; it grants no rights to those brands. Do not describe this project as an official 1983 release.

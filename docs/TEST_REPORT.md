# Validation report

## Build

- batari Basic 1.9, commit `efd6dcd319c31a5e37afb00d47c981105998d924`.
- DASM 2.20.14.1. Native build script completed successfully.
- 4,096-byte standard NTSC 4K ROM, with 1,028 bytes of ROM space left reported by the assembler.
- ROM SHA-256: `b643c864afe9a50d96cc03495f45f562d1e789407a7ca33ecdf85323cda7607b`.

## Runtime verification

Javatari 0.91 from 8bitworkshop commit `fd16951ea21379d6ed37845d034ee2ce14d62bb6`, run headlessly with its actual 6502/TIA/RIOT emulation. The harness feeds joystick/switch events, reads debugger symbols for assertions, and captures rendered TIA pixel rows. It does not teleport the hero, set game variables, or patch the cartridge.

Passed:

- Title, mode selection, Select debounce, Fire to start, and Reset.
- Held Fire does not continuously retrigger jumps.
- All three bricks, the ledge jump, and bridge construction in every world.
- All five patrol bots and three hits on the final boss.
- Enemy side contact removes a life and preserves the built bridge and brick count.
- Rescue in every world and portal gating before rescue.
- All six worlds completed using joystick input, without losing a life.
- Victory state and final score display of 010400.
- Pit falls, three-life game over, and Fire restart.
- Relay selection, turn alternation, and shared lives.
- All **2,384 measured campaign frames had 262 scanlines**, including world transitions and victory. Power-up initialization before the campaign measurement is excluded.
- Rendered title, gameplay, bridge, desert, fortress, game-over, and victory captures inspected. Captures are actual emulator output; PNGs crop the 68-clock horizontal blanking area and scale pixels to 640x480.

Raw assertion output is in `verification.log`. Emulator power-up phase can shift exact input/frame counts slightly between runs. The test asserts outcomes rather than exact per-world durations.

## Repeat the runtime test

Obtain the 8bitworkshop repository separately. No emulator is bundled. With Node.js installed:

```bash
node tools/verify.cjs /absolute/path/to/8bitworkshop/javatari/javatari.js
```

Use the legacy `javatari/javatari.js` bundle at the pinned commit, not the different `javatari.js` submodule path. The harness uses the ROM and matching symbols from `builds/` and writes JSON pixel captures under `builds/test-captures/`.

## Limits of verification

The live 8bitworkshop website returned HTTP 403, so compilation and gameplay were verified locally, not in its hosted editor. Native source import instructions are supplied, but its deployed compiler version was not tested. No physical Atari console, PAL mode, browser keyboard mapping, or external gamepad was tested. Scanline checks cover the stated scenarios, rather than an exhaustive proof of every input sequence.

# Game design and hardware notes

## Story

A cheerful yellow minifigure follows a portal from LEGO City into a magical block universe. The Brick Master has stolen the Golden Building Brick. Recover three construction pieces in each room, build a bridge, defeat the guardian, rescue a friend, and travel through the next portal. The story is conveyed here; the ROM uses symbolic title, play, game-over, and victory screens.

## Implemented scope

Six palette/ledge variants of one compact room; signed integer jump physics; one-way raised platforms; floor and pit collisions; three sequential collectible bricks; one bridge per room; one patrolling enemy; rescue interaction; gated world exit; three-hit final boss; score; three shared lives; sound; walking pose animation; title mode selection; shared-controller alternating relay; game-over and victory.

| Event | Score |
| --- | ---: |
| Collect construction brick | 100 |
| Build bridge | 200 |
| Stomp enemy / boss hit | 300 |
| Rescue friend | 500 |
| Recover Golden Building Brick | 2,000 |

A complete no-death run earns 10,400 points. No high-score saving is implemented.

## Hardware budget

- NTSC Atari 2600, stock 6507/TIA/RIOT, 128-byte system RAM, 4K ROM.
- Uses the standard batari Basic two-scanline kernel and six-digit score.
- Player 1 is the hero, using a per-row color table for blue legs, red torso, and yellow head. This kernel option reserves the missile 1 variables for the color-table pointer. The game deliberately uses no missile 1 graphics or writes.
- Player 0 is reused as the patrol bot / Brick Master / rescued friend. Two walking foot poses and the bot's changing reflection supply simple animation.
- The TIA ball is the collectible and, at victory, the Golden Building Brick. Ball and playfield share color; construction pieces follow each world's terrain palette. Independent multicolor brick sprites are not implemented.
- Playfield: 32 columns, 12 rows; 4 horizontal color clocks per column, 8 logical vertical units per row. Each logical vertical unit is two scanlines. The score is drawn separately beneath the room.
- Variables `a`–`z` hold world state. The kernel owns sprite, playfield, score, and scratch memory. Tables occupy ROM; no cartridge RAM is needed.
- Jump velocity is an unsigned byte holding a signed two's-complement value. It starts at 252 (-4), advances every four simulation ticks, and caps at +6. Landing resets velocity to zero.
- Platform collision is numerical. The raised ledge is one-way: you can jump through its underside and land on top while descending. Decorative solid-wall collisions and ladders are not present.
- A bridge is a persistent playfield horizontal line, covering the pit. Three pieces authorize building; the counter stays at three to mean the room's materials were collected. Building adds one fixed bridge rather than a block editor.
- Enemy hits have a short grace period. Pit falls still cause death during that grace period. Dying respawns the hero at the left edge and preserves current-room progress.
- World loading is spread across several rendered frames so the playfield plotting work stays within the frame budget. The campaign test recorded 262 scanlines for all 2,384 measured campaign frames, including world loads and victory.

## Relay mode

Select toggles solo/relay on the title screen, with switch debouncing. Relay uses port 1 for both people. A death flips the turn flag and score color; players pass the controller. Score, campaign progress, and the pool of three lives are shared. No independent second player save state exists.

## Extension points

Change the `sky`, `land`, and `ledgeleft` tables for world variants. Collision and drawing must be edited together if adding platforms. Keep missile 1 unused while `player1colors` is enabled. Additional maps, freeform building, enemy types, and separate player progress would require further design and testing, possibly a larger cartridge layout.

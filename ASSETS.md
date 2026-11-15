# Isle of Dead: asset list

Every picture in the project, where it came from, and what the game uses it for.
Nothing here was drawn for this project. Each file is a straight copy from one of
the packs below, except `pickups/vodka.png` (see its note).

## Source packs

| Pack | Author | Location on this computer |
|---|---|---|
| FREE Character 16-bit Thug Outlined | not named inside the zip | `D:\DATA\game dev\FREE Character 16-bit Thug Outlined.zip` |
| FREE Character HD Survivor W Bike | not named inside the zip | `D:\DATA\game dev\FREE Character HD Survivor W Bike.zip` |
| World Build - Environment Pack 0.4 | Anokolisa (see the pack's `Terms.txt`) | `D:\DATA\game dev\World Build - Environment Pack - 0.4.zip` |

The World Build terms say credit is not required but appreciated, the art may be
altered, and it may be used in commercial projects but not resold as art.

## Characters: `characters/thug/`

All from the Thug pack, same file names. Each sheet is 512x512: 8 rows (one per
facing direction) of 8 frames, 64x64 each.

| File | Used for |
|---|---|
| `Idle.png` | Player standing still |
| `Run.png` | Player running; runner zombies |
| `Attack1.png` | Player shooting while standing |
| `RunAttack.png` | Player shooting while running |
| `Die.png` | Player and zombie death |
| `Walk.png` | Walker and brute zombies |
| `Attack2.png` | Zombie bite |

Zombies use the same Thug pictures with a colour tint set in code
(green walker, yellow runner, blue brute).

## Environment: `world_build/`

All from the World Build pack, folder `Assets/`.

| File | Original path in the pack | Used for |
|---|---|---|
| `Tiles.png` | `Environment/Tiles/Tiles.png` | Grass, cliffs, pond edges |
| `Tree_01.png` | `Environment/Trees/Tree_01.png` | Trees, stumps, dead trees |
| `Tree_02.png` | `Environment/Trees/Tree_02.png` | Trees |
| `Tree_03.png` | `Environment/Trees/Tree_03.png` | Pine trees |
| `Props_Forest.png` | `Environment/Props/Props_Forest.png` | Rocks, bushes, flowers |
| `Structure_White.png` | `Buildings/White/Structure.png` | Ruins |

`world_build/tiles.tres` is not a picture. It is a Godot TileSet file that tells
Godot to cut `Tiles.png` into 32x32 squares.

## Pickup: `pickups/vodka.png`

The vodka bottle picture supplied for this project. The only change made to it:
the white background around the bottle was made transparent and the picture was
cropped to the bottle (16x47 pixels). The bottle itself was not redrawn.

## Other

| File | Source | Used for |
|---|---|---|
| `icon.svg` | Comes with every new Godot project | The bullet, and the project icon |

## In the project but not used by the game

| File | Note |
|---|---|
| `characters/survivor/*.png` (5 files) | Copied from the Survivor pack when the Survivor was briefly the player. Safe to delete. |
| `characters/thug/TakeDamage.png` | Was the zombie flinch. Safe to delete. |
| `world_build/Crops.png`, `Structure_Wood.png`, `House_Props.png` | Were crop fields, a second ruin colour, and furniture. Safe to delete. |
| `Walk.png`, `Attack1.png` (project root) | The first Thug sheets added at the start. The game now loads the copies in `characters/thug/`. Safe to delete. |

## Things that look like art but are only colour

- Water is the background colour showing through holes in the grass tiles.
- Night is a blue tint over the whole island, removed at sunrise.
- The revive minigame bar is made of plain coloured rectangles.

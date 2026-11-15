# Isle of Dead: how the code works

The game is one open island. Zombies come in waves that get harder. If you die,
a timing minigame gives you a chance to come back. Clear wave 10 to see sunrise.

## The world scene

The game starts in `world.tscn`. Each node has one job:

| Node | Script | Job |
|---|---|---|
| `Island` | `island.gd` | Paints the ground and ponds, keeps everyone out of the sea |
| `Scenery` | `scenery.gd` | Places trees, rocks, bushes, flowers and ruins |
| `player` | `player.gd` | The character you control |
| `Night` | (none) | A blue tint over the island |
| `Waves` | `waves.gd` | Sends the zombie waves |
| `HUD` | `hud.gd` | The text on screen |
| `Revive` | `revive.gd` | The comeback minigame |

Zombies, bullets and bottles are their own scenes (`zombie.tscn`, `bullet.tscn`,
`pickup.tscn`). Code makes copies of them when needed (`instantiate()`).

## Ideas used everywhere

- `_ready()` runs once when a node appears.
- `_process(delta)` and `_physics_process(delta)` run every frame. `delta` is the
  time since the last frame, so `speed * delta` means "this far per second".
- A **group** is a name tag. `get_first_node_in_group("player")` finds the player.
- **Collision layers** decide what touches what: 1 = world (rocks, trunks, ruins),
  2 = player, 3 = zombie feet, 4 = zombie hit boxes.
- A character's position is at its **feet**, so whoever is lower on screen is
  drawn on top (`y_sort_enabled`).
- Every character sheet is 8 rows (directions) of 8 frames, so
  `frame = row * 8 + column`.

## bullet.gd

Flies along `direction`, counts down `life`, then removes itself. It is an
`Area2D`: touching a zombie's hit box calls the zombie's `hit()`, touching
anything solid just removes the bullet.

## pickup.gd

The vodka bottle. Floats up and down with `sin()`, blinks near the end, vanishes
after 25 seconds. When the player touches it, it calls `player.drink()`.

## player.gd

Each frame, in order:

1. If dead, show the death frames and stop.
2. Vodka power: while `power_time` is above zero, `boost` is 1.4.
3. Move with WASD (`Input.get_vector`). Slower in water.
4. Face the mouse: the angle is cut into 8 slices, the slice is the sheet row.
5. Shoot while the button is held, one bullet each time `fire_wait` hits zero.
6. Pick the animation: idle, run, shoot, or run-and-shoot.

`take_damage()` is called by zombies. `drink()` is called by a bottle.
`revive()` is called by the minigame: back to 50 health, and every zombie within
400 pixels dies so you are not bitten again straight away.

## zombie.gd

`kind` is `"walker"`, `"runner"` or `"brute"`. `_ready()` sets the numbers and
tint for that kind, then adds `extra_speed`, which grows every wave.

Each frame, in order:

1. If dying, play the fall, lie there 6 seconds, then remove.
2. If biting, finish the bite animation.
3. If close to the player, bite: `player.take_damage(damage)`.
4. Walk straight toward the player.
5. If stuck on something (barely moved this frame), step sideways for 0.6
   seconds. Each zombie always steps the same way (`side`), so it works its way
   around the obstacle.
6. Push away from any zombie closer than 40 pixels so crowds spread out.

`hit()` takes 1 health. `die()` removes it from the `zombies` group, switches
off its collisions, and sometimes leaves a bottle.

## waves.gd

- `start_wave()` adds 1 to `wave` and spawns `4 + wave * 2` zombies.
- From wave 3, every fourth zombie is a runner. Every third wave has brutes.
- Ammo given is 1.5 bullets for every hit the wave needs.
- `spawn_zombie()` picks a spot 900 pixels from the player in a random
  direction, kept inside the island.
- The next wave comes after 30 seconds, or 3 seconds after the last zombie dies.
- After wave 10 is cleared, `won` becomes true.

## revive.gd

The comeback minigame. A white slider moves left and right across a dark bar.

- When the player dies, `start()` shows the bar.
- Pressing shoot (click or Space) while the middle of the slider is inside the
  green block is a hit. The green block moves and the slider gets 1.4 times faster.
- 3 hits calls `player.revive()`.
- A press outside the green block sets `failed`, and the game is over.
- Each revive makes the next minigame start faster (`revives * 120`).
- `wait` ignores presses for the first 0.8 seconds, so a click you were already
  making when you died does not count.

## island.gd

- `paint_island()` fills the grid from `Tiles.png`. The sheet has a small
  ready-made island; the code keeps its corners and repeats its middle tiles.
- `paint_pond()` stamps a ring of grass with a hole in it. The background colour
  shows through the hole as water.
- `in_water(spot)` treats each pond as an oval and says if a point is inside.
- `build_walls()` puts four invisible walls around the shore.

## scenery.gd

- `kinds` is a list: which picture, which rectangle of it, how wide the solid
  part is, and how many to place.
- `find_spot()` picks random places and rejects ones in water, near the start,
  near a ruin, or too close to something already placed.
- `add_prop()` makes a picture with a small solid box at its base.
- `add_flat()` makes a picture lying on the ground.
- `add_ruin()` places house foundations with one solid box over them.
- `seed(7)` makes the layout the same every game.

## hud.gd

Writes health, ammo, wave and zombie count every frame. Shows GAME OVER when the
minigame is failed, or the sunrise text when the last wave is cleared. R restarts.

## Where to change things

| To change | Edit |
|---|---|
| Player speed, health, fire rate | top of `player.gd` |
| Zombie numbers per kind | `_ready()` in `zombie.gd` |
| Wave size, ammo, number of waves | `waves.gd` |
| Minigame speed and number of hits | `revive.gd` |
| Island size and ponds | top of `island.gd` |
| How many trees and rocks | `kinds` in `scenery.gd` |

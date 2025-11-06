# ReinDungeonTools

A route planning addon for classic dungeons.

<img width="1967" height="1119" alt="image" src="https://github.com/user-attachments/assets/6af3655d-8ab2-4632-be7a-5a19c95542d4" />

## Features

- **Pull Planning**: Organize packs into pulls to find optimal route
- **Full Scale Map**: Custom made maps to fit multi-floor dungeon into a single view
- **Route Import/Export**: Share routes via encoded strings
- **Party Sharing**: Send routes to party members in-game (WIP)

## Installation

1. Download the latest release
2. Extract to `{path_to_wow}/Interface/AddOns/`
3. Restart WoW

## Getting Started

### Basic Usage

1. Open the planner: `/rdt` or click the minimap button
2. Select a dungeon from the dropdown menu
3. **Left-click** a pack to add it to the current pull
4. Click **New Pull** to start planning the next pull
5. Click **Reset All** to clear all pulls and start over

### Slash Commands

```
/rdt                    - Toggle main window
/rdt help               - Show all commands
```

### Development Tools

For devs adding new dungeons/making changes:

```
/rdt debug              - Toggle debug mode
/rdt coords             - Toggle coordinate picker (click map to get coordinates)
/rdt packcoords         - List all pack coordinates
/rdt validate           - Validate all dungeon data
/rdt list               - List registered dungeons
/rdt mobs               - List registered mobs
```

#### Tiled maps

Default layout is 3x2 - 512px tiles. 1536x1024 source image.

Tiles are arranged left-to-right, top-to-bottom in the grid.
```
For a 3x2 grid: [1][2][3]
                [4][5][6]
```

## Roadmap

- [x] Import/Export routes via encoded strings
- [x] Minimap button
- [x] Multi-language support
- [x] Pull border indication
- [x] Basic pack information (mob names, forces)
- [x] In-game coordinate picker for development
- [x] Multiple routes per dungeon
- [x] Replace sample icons with mob portraits
- [x] Make icons/portraits round
- [x] Add Entrance/Floor/Buffs indicators
- [ ] Complete dungeon layouts
- [ ] Detailed pack information (abilities, patrol paths)
- [ ] Route sharing in chat
- [ ] Undo/Redo functionality
- [ ] Dungeon timer integration
- [ ] Statistics tracking

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

All rights reserved.

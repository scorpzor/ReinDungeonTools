# ReinDungeonTools

A route planning addon for classic dungeons.

## Features

- **Interactive Map**: Visual dungeon maps with enemy pack positioning
- **Pull Planning**: Organize packs into numbered pulls for optimal routing
- **Route Import/Export**: Share routes via encoded strings
- **Party Sharing**: Send routes to party members in-game (WIP)
- **Minimap Button**: Quick access to the planner
- **Multi-Dungeon Support**: Modular dungeon system for easy expansion

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
/rdt debug              - Toggle debug mode
```

### Development Tools

For devs adding new dungeons/making changes:

```
/rdt coords             - Toggle coordinate picker (click map to get coordinates)
/rdt mapinfo            - Show current map dimensions
/rdt packcoords         - List all pack coordinates
/rdt validate           - Validate all dungeon data
/rdt list               - List registered dungeons
/rdt mobs               - List registered mobs
```

## Roadmap

- [x] Import/Export routes via encoded strings
- [x] Minimap button for quick access
- [x] Multi-language localization support
- [x] Pull border indication
- [x] Basic pack information (mob names, forces)
- [x] In-game coordinate picker for development
- [x] Multiple routes per dungeon
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
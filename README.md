# Interstellar Contract Services

A turn-based tactical prototype inspired by XCOM and Darkest Dungeon, with a planned meta-layer focused on mercenary company management in a post-collapse sci-fi setting.

## Premise

Run a mercenary organization, complete tactical contracts, and (eventually) return to HQ to manage roster, finances, facilities, and long-term campaign pressure.

---

## Current State: _Prototype_

This project is currently focused on **Phase 1 tactical combat foundations**:

- Grid-based tile map and pathfinding
- Unit selection and turn flow (player/enemy phases)
- AP-based movement and attacks
- Basic enemy AI target selection + movement + attack attempt
- Hit chance with weapon accuracy, defense, cover, and range penalty
- Basic line-of-sight checks and cover data on tiles

---

## Implemented Systems

### Core architecture
The game is structured around modular controllers responsible for input, turn flow, AI decision-making, and combat resolution. This separation allows systems to evolve independently as mechanics expand.

### Tactical map + grid logic
- Tile-based map with metadata for walkability, cover, and line-of-sight blocking
- A* pathfinding with dynamic unit obstruction
- Reachable tile generation and path visualization

### Unit model
- Health and action point lifecycle system
- Movement along computed paths with tweened transitions
- Combat resolution including hit chance, defense, and range modifiers
- Event-driven unit death and cleanup

### Turn system
- Phase-based turn loop (player/enemy)
- Input-locked turn states
- Enemy action sequencing per phase

### Data-driven resources
- Unit definitions via `UnitResource`
- Weapon behavior via `WeaponResource`
- Mission structure via `ContractResource`

---

## Controls (Current)

- **Left Click**: Select units / confirm tactical action
- **Esc**: Deselect active unit
- **Space**: End player turn


---

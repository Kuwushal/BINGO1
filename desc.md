Bingo — Lua/LÖVE2D Project

Bingo is a 2D Bingo game being developed with Lua and the LÖVE framework. The project is intended to be both a practical way to learn Lua and a complete, polished game that can eventually be published on itch.io and showcased as a portfolio project.

The initial version will focus entirely on an offline single-player experience, where the player competes against the computer. Multiplayer will not be implemented during the initial development so that the focus remains on learning Lua, understanding LÖVE's game-development workflow, and building a solid game architecture. Local/friendly multiplayer and online multiplayer can be considered as future versions once the core game is complete.

Core Gameplay

The player will receive a randomly generated Bingo board containing numbers arranged in a grid. The game will continuously call random numbers, and the player will mark the corresponding number on their board when it is called.

The computer will have its own board and will automatically mark numbers as they are called. The game will keep track of both boards and determine when either the player or computer completes the required winning pattern.

The initial game will include:

Random Bingo board generation
Random number calling
Player number selection/marking
Automatic computer number marking
Player and computer boards
Detection of completed rows
Detection of completed columns
Detection of diagonal patterns
Win/loss/draw detection
Game restart functionality
Basic game-state management
User Interface

The game will use LÖVE's graphical capabilities to create a proper 2D interface rather than a terminal-based game.

The interface will eventually include:

Bingo board/grid
Player and computer sections
Currently called number
Visual indication of marked numbers
Game status
Winner announcement
New game/restart button
Simple animations
Sound effects
Polished typography and visual design

The UI will initially remain simple so that functionality can be completed before spending time on visual polish.

Development Approach

The project will be developed incrementally rather than trying to build everything at once.

Phase 1 — Lua fundamentals

Use the project to practice:

Variables
Conditions
Loops
Functions
Tables
Modules
Basic file handling

Phase 2 — LÖVE fundamentals

Learn:

Game window configuration
Drawing shapes and text
Mouse input
Keyboard input
Game loops
Coordinate systems
Basic animation
Audio

Phase 3 — Core Bingo

Implement:

Board generation
Number generation
Number calling
Marking
Computer logic
Win detection
Game states

Phase 4 — UI and polish

Improve:

Layout
Typography
Visual feedback
Animations
Sound effects
Menus
Restart flow

Phase 5 — Release

Create downloadable builds for supported platforms and prepare the game for publication on itch.io.

Future Versions

Multiplayer will intentionally be left out of the first version.

Once the offline game is stable, possible future versions could introduce:

Local/Friendly Multiplayer

Two players could play on the same computer, potentially using different input controls.

Online Multiplayer

A later version could introduce:

Game rooms
Room codes
Player matchmaking
Synchronized Bingo boards
Real-time number calling
Server-side game state

These features are future goals, not part of the initial project.

Final Goal

The goal isn't simply to make a small Bingo game. The project is intended to become a complete, playable Lua/LÖVE application that demonstrates the ability to take a project from an initial idea through development, architecture, UI design, testing, packaging, and publication.

The finished first version should be something that can be:

played locally → packaged as a downloadable game → published on itch.io → documented on GitHub → showcased in a portfolio.

The project will therefore serve two purposes: learning Lua/LÖVE through an actual project and producing a finished piece of software rather than a collection of small tutorials
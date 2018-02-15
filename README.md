# StealthAction
__WORK IN PROGRESS__

---

## Description
This is a 2D game written in Ruby using the gem [Gosu](https://www.libgosu.org/index.html).  
It is very early in development and is currently set on hold, due to lack of time.  
In case you still want to check it out, see the __Installation__ section below.  
  
The original idea of this game was to create a rogue-like stealth/action game,  
with the gimmick of being able to switch between 2D and 2.5D perspectives.  
I don't know if this idea will be continued, but we do want to come back to this project  
and make something out of it.  
  
The current state, although a bit messy at parts, is a pretty solid  
2D, top-down game framework (_in my opinion_).  
I will improve this README once we continue with development on this project  
and hopefully have a section explaining the code structure a bit, so anybody  
who is interested can fool around with this project.  
  
The project consists of two main parts:  
* The actual game, `./StealthAction.rb` (source: `./src/**`), and
* a web-based level editor, `./level-editor/index.html` (source: `./level-editor/**`)

  
---
  

## The Game
### Installation
#### Dependencies
First of all, you need to have `ruby` (and optionally `ruby-bundler`) installed;  
check your distro's repositories for those packages.  
  
Then you need to have the ruby gem `gosu` installed;  
Gosu has some dependency requirements itself, check [Gosu's homepage](https://www.libgosu.org/ruby.html)  
for dependency installation instructions, should be pretty straight-forward copy/pasting  
of package names to your distro's package manager / Homebrew on MacOS.  
[List of a variety of Linux+GNU distributions' dependencies.](https://github.com/gosu/gosu/wiki/Getting-Started-on-Linux)  
  
Once you have installed Gosu's dependencies you can either manually install the Gosu gem with:  
```
$ gem install gosu
```
or if you have `ruby-bundler` installed just execute the following in the root directory of this repo:  
```
$ bundle install
```

#### Installing and Running the Application
Download the repository and change directory into it by running:
```
$ git clone https://github.com/Noah2610/StealthAction.git; cd ./StealthAction/
```
If the above dependency installation instructions have been completed successfully,  
you should have no issues when running:  
```
$ ./StealthAction.rb
```
in the project root, to start the game.  

  

### Command-Line Usage
#### Synopsis
`$ ./StealthAction.rb [LEVEL-NAME [ROOM-NAME]]`
#### Arguments
* _LEVEL-NAME_  
  Specify which level to load first upon starting the game.  
  Level names are the directory names in `./src/levels/`.  
  If this is the only passed option, it will randomly choose a room  
  from the level's `rooms/` directory (`./src/levels/LEVEL-NAME/rooms/*.json`).  
* _ROOM-NAME_  
  This argument is only applicable when using _LEVEL-NAME_.  
  Room names are JSON files located inside a level's `rooms/` directory  
  (`./src/levels/LEVEL-NAME/rooms/ROOM-NAME.json`).  
  With both arguments you can directly specify which room to load first.  

  

### In-Game / Gameplay
You can't really do a lot in the game currently;  
Here's a list of some features it has:  
* Levels and Rooms _(load room data from JSON files)_
* Instances _(objects in rooms: Walls, Doors, etc.)_
* Entities _(Player, Enemies)_
* Velocity based movement _(could be a racing game with the correct settings)_
* Collision Detection
* Pathfinding
* Image loading
* Song/Music Controller

#### Controls
|  Key(s)                                     |  Action              |
|:-------------------------------------------:|:-------------------- |
|  __W__,__A__,__S__,__D__ or __Arrow Keys__  |  Player Movement     |
|  hold __Shift__                             |  Slower Movement     |
|  __H__,__J__,__K__,__L__                    |  Move Camera         |
|  __Tab__ or __Enter__                       |  Next Room (Random)  |
|  __Q__                                      |  Quit Game           |

  
---
  

## The Level Editor
### Usage
No installation necessary for the level-editor.  
Just open `./level-editor/index.html` in your browser of choice.  
  
Best play around with the editor yourself to figure out how it works.  
Shouldn't be too complicated.  
  
It also supports _almost_ full, vim-like keyboard control.  
The default keybindings are saved in the file `./level-editor/keybindings.json`  
and an explanation of the current configuration can be seen  
by opening `./level-editor/keybindings.html` in your browser. `index.html` also links to that page.  
You are free to edit `./level-editor/keybindings.json` if you want to change the keybindings.  
  
> By the way, the name _level-editor_ is kind of incorrect according to the game's terminology;  
> it should be called _room-editor_ because you actually create and edit _rooms_,  
> not _levels_ by the game's naming conventions.  
  
You can load a room JSON file (located under `./src/levels/LEVEL-NAME/rooms/ROOM-NAME.json`),  
by hitting the _Browse_ button unter _Load Level_ near the top of the panel on the right,  
and it should properly load it into the page.  
  
> __CAUTION:__ When loading a room, it will reset and clear  
> any blocks you currently have placed in the editor, without warning.
  
When you are happy with a room layout/design, you can save and export it,  
by hitting the _Save Level_ button at the bottom of the panel, optionally  
passing a room-name in the input field next to the button before clicking on it.  
  
To use your newly created level in the game, just move the downloaded file  
into any `rooms` directory of any level (`./src/levels/LEVEL-NAME/rooms/my-room.json`).  
Then to load that level in the game, use the `StealthAction.rb`'s CLI,  
as described in the above section __The Game__ -> __Command-Line Usage__.

  
---
  

## Credits
|  Person                                        |  Role(s)               |
|:----------------------------------------------:|:---------------------- |
|  [__Emu__](https://github.com/hoichael)        |  Concept               |
|  [__Moe__](https://github.com/theniggeth)      |  Artwork               |
|  [__Noah__ (me)](https://github.com/Noah2610)  |  Programming, Concept  |
  
Emu and I originally came up with the idea;  
Moe joined later on and did some pixel-art and music for the game.  

  
---
  

## Afterword
I very much enjoyed working on this project and hope to return to it soon.  
I don't think we will be continuing with the original idea for this game  
but rather use this code-base as a game framework and create some fun, simple game(s) with it (_hopefully_).  
  
What I don't want is for this project to be added to the list of unfinished projects.
  
> If you've made it 'til here,  
> Thank you very much for your interest in this personal project of ours. __:)__  
> You are free to use this code as you please.  
> _(It doesn't have a liscense, and I don't want to get into that now.)_
  
__Thanks for reading!__  
__Have a nice day!__


# Finch

A cute little task manager for your command line.

Add a new task. 
```
> finch add "ship it!"
 ◦ 3. ship it!
```

List all your tasks. 
These are stored in a `.todo` file as JSON, 
so tasks can be kept relevant to a single project.
```
> finch ls
 ◦ 1. refactor code
 ◦ 2. request code review
 ◦ 3. ship it!
```

Get things done!
```
 > finch do 1
 ✓ 1. refactor code
 ◦ 2. request code review
 ◦ 3. ship it!
```

Here are all the operations that Finch supports.
Usage help is also available for each command.

```
> finch help
Available commands:

   add    Create a new task
   do     Complete tasks by ID
   edit   Change the title of a task.
   help   Display general or command-specific help
   ls     List outstanding tasks
   rm     Remove tasks by ID
   swap   Swap the IDs of two tasks.
   undo   Un-complete tasks by ID
```

There are some commands to help with examining or modifying the `.todo` file directly.

```
> finch file help
Available commands:

   help    Display general or command-specific help
   path    Print path to task storage file
   read    Read task storage file
   write   Write stdin to task storage file
```

## Installation
The easiest way to install is with [Mint](https://github.com/yonaskolb/mint) 🌱
```
> mint install mklbtz/finch
```

Or you can manually clone the repo and build it with SwiftPM.
```
git clone https://github.com/mklbtz/finch
cd finch
swift build
cp .build/debug/finch /usr/local/bin/
```

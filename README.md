# DTree
A Vim plugin to show file tree, and it's easy to open files

## Usage
use command 'DTreeToggle' to open or close dtree window

## Update

### 2017.04.26
- update '+' and '-' to show the directory's status
- fix bug that when use 'enter' to open file, may be open it in the '__DTree__' window

### 2017.04.24
- fix bug that when open file in a new buffer, it will set nomodifiable flag

### 2017.04.24
- fix bug that when close the vertical window, dtree window will resize to half of screen

### 2017.04.19
- fix the attribute of dtree window
- add command 'DTreeToggle' to open or close dtree window

### 2017.04.18
- add syntax file

### 2017.04.16
- add function to open normal file
- set DTree window's filetype and add ftplugin to add keymap

### 2017.04.14
- add functions to open or close file tree window

### 2017.04.07
- add some functions
- separate logic and display
- now can open and close directory by using OpenDir() and CloseDir()

## TODO
~~add syntax plugin~~

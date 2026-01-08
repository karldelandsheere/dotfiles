# Todo List

A simple todo list manager plugin for Noctalia Shell with multiple interfaces and IPC support.

## Features

- **Bar Widget**: Shows todo count in the bar
- **Panel**: Full todo management interface with add, complete, and delete functionality
- **Desktop Widget**: View and manage todos directly on your desktop
- **Settings**: Configure display preferences
- **IPC Support**: Control todos programmatically via IPC commands

## Usage

Add the bar widget to your bar, or add the desktop widget to your desktop. Click to open the panel for full management.

### Panel Controls

- Add new todos using the text input
- Toggle completion status with the checkbox
- Delete todos with the X button
- Clear all completed todos with the "Clear Completed" button

### IPC Commands

Control the todo list from external scripts using Quickshell IPC:

```bash
# Add a new todo
qs -c noctalia-shell ipc call plugin:todo addTodo "Buy groceries"

# Toggle a todo's completion status (by ID)
qs -c noctalia-shell ipc call plugin:todo toggleTodo 1234567890

# Remove a specific todo (by ID)
qs -c noctalia-shell ipc call plugin:todo removeTodo 1234567890

# Clear all completed todos
qs -c noctalia-shell ipc call plugin:todo clearCompleted

# Toggle the panel
qs -c noctalia-shell ipc call plugin:todo togglePanel
```

## Configuration

- **Show Completed**: Toggle visibility of completed todos
- **Show Background**: Toggle desktop widget background visibility

## Requirements

- Noctalia 3.7.1 or later

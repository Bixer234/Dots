# Waybar Todo Lists 📝

A lightweight, customizable todo list manager integrated with Waybar. Manage your tasks directly from your system bar with a terminal-based UI and click-action support.

## Features ✨

- **Waybar Integration**: Display your current task directly in your Waybar status bar
- **Rofi/Terminal UI**: Interactive terminal or rofi interface for managing tasks
- **Priority System**: Organize tasks by priority numbers
- **Task Status Tracking**: Mark tasks as pending or completed
- **Auto-Delete**: Automatically delete tasks on a scheduled time
- **Configurable Actions**: Customize middle-click behavior
- **Real-time Updates**: Instant feedback in the Waybar module
- **Tooltip Display**: View all tasks in the Waybar tooltip
- **Conflict Resolution**: Smart priority handling when adding tasks

## Preview 

**Showing all tooltip, rofi ui and terminal ui**

**Main APP UI**


https://github.com/user-attachments/assets/582d1342-164d-4cb3-9672-490800061148


![img](/preview/img2.png)

**Settings UI**

![img](/preview/img6.png)

**To get my waybar config with all of my cool scripts** [modern-labwc](https://github.com/Harsh-bin/modern-labwc/)

## Installation 

1. Clone the repository:
```bash
git clone https://github.com/Harsh-bin/waybar-todo-lists.git
```

2. Copy the scripts to your Waybar config directory:
```bash
mkdir -p ~/.config/waybar/scripts/todo
cp -r waybar-todo-lists/* ~/.config/waybar/scripts/todo/
chmod +x ~/.config/waybar/scripts/todo/*.sh
```

> [!CAUTION]
> The bash script is configured to use `$HOME/.config/waybar/scripts/todo` (as the TODO_DIR variable). So, you can use the suggested installation step or modify it as needed. <br></br>

3. Add the module to your Waybar configuration: 
```jsonc
{
      "custom/todo":
      {
          "format": "\u00a0{}",
          "exec": "~/.config/waybar/scripts/todo/todo.sh",
          "on-double-click": "~/.config/waybar/scripts/todo/todo.sh --mark-done",

          /// To use tui on right click use something like this
         ///  "on-click-right": "foot ~/.config/waybar/scripts/todo/todo.sh --show-tui",

          "on-click-right": "killall rofi || bash ~/.config/waybar/scripts/todo/todo.sh --show-rofi",
          "on-click-middle": "~/.config/waybar/scripts/todo/todo.sh --middle-click",
          "return-type": "json",
          "interval": 5,
          "tooltip": true
      },
}
```

**You can use this css class property `.pending` to change waybar view when there is pending task**

example if you add module as `"custom/todo":`

```
/* Pending Tasks */
#custom-todo.pending {
    background-color: #FF0000;
    color: #00000;
}
```

NOTE: if you change name of module such as `"custom/tasks":` then css class will become

```
/* todo is chaged to tasks */ 
#custom-tasks.pending {
    background-color: #FF0000;
    color: #00000;
}
```

## Usage if you use my `configuration`.

- **Right Click**: Open the interactive 
- **Middle Click**: Delete all task or Delete all completed task (configurable)
- **Double Click**: Mark task complete

#### Settings Menu:
- **Delete ALL tasks now**: Permanently remove all tasks
- **Delete COMPLETED tasks now**: Remove only completed tasks
- **Set daily auto-delete time**: Configure automatic deletion at a specific time
- **Configure middle-click action**: Set what happens on middle-click

## Author ✍️

Created by [Harsh-bin](https://github.com/Harsh-bin)

---

**Enjoy your todo list! 🎉**

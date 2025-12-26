# Roblox-Auto-Rejoiner
Automatically rejoin your Roblox private server when the game closes. Perfect for maintaining long AFK sessions, farming, or staying connected to your favorite servers without manual intervention.

## Features
1. Automatic private server reconnection
2. Smart cooldown system to prevent rapid relaunching
3. Pause and resume functionality
4. Lightweight background monitoring
5. Safe process detection using official Node.js libraries

## Requirements
Windows operating system
Node.js installed on your system

## Installation
1. Download the installer script
2. Run the .bat file
3. The installer will automatically:
   - Create a `RobloxWatcher` folder
   - Install required dependencies
   - Generate the watcher application
  
## Usage
1. Double-click `run.bat` in the RobloxWatcher folder
2. Select option `[1]` to start the watcher
3. Paste your Roblox private server link when prompted
4. The watcher will now monitor Roblox and automatically rejoin if it closes

### Controls
- **Ctrl + C** - Pause the watcher
  - Press **Y** to stop completely
  - Press **N** to resume watching the same server
- **Close terminal** - Stop the watcher entirely

## How It Works
The watcher runs in the background and checks every few seconds if `RobloxPlayerBeta.exe` is running. When it detects Roblox has closed, it automatically launches your private server link. A built-in cooldown prevents rapid relaunching and ensures stable operation.

## Safety & Privacy
- No data collection or external connections
- Only monitors local processes on your machine
- Open source - review the code yourself
- Uses official `ps-list` package for process detection

## Troubleshooting
**"Node.js is not installed"**
- Download and install Node.js from [nodejs.org](https://nodejs.org/)

**Watcher doesn't detect Roblox**
- Make sure Roblox is actually running
- Verify the process name is `RobloxPlayerBeta.exe`

**Link doesn't work**
- Ensure your link starts with `https://`
- Use a valid Roblox private server link

## License
This project is provided as-is for educational and personal use. Use responsibly and in accordance with Roblox's Terms of Service.

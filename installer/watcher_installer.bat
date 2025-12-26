@echo off
setlocal enabledelayedexpansion

where node >nul 2>&1
if errorlevel 1 (
    echo Node.js is not installed.
    pause
    exit /b 1
)

set "SCRIPTDIR=%~dp0"
set "BASE=%SCRIPTDIR%roblox_watcher"

if not exist "%BASE%" mkdir "%BASE%"
cd /d "%BASE%"

(
echo {
echo   "name": "robloxwatcher",
echo   "version": "1.0.0",
echo   "type": "module",
echo   "dependencies": {
echo     "ps-list": "^8.0.0"
echo   }
echo }
) > package.json

call npm install --silent

setlocal disabledelayedexpansion
chcp 65001 >nul

(
echo import { exec } from 'child_process'
echo import readline from 'readline'
echo import psList from 'ps-list'
echo.
echo const config = {
echo   targetProcess: 'RobloxPlayerBeta.exe',
echo   checkInterval: 6942,
echo   cooldownTime: 16942
echo }
echo.
echo let state = {
echo   lastLaunch: 0,
echo   launchInProgress: false,
echo   serverLink: null,
echo   running: false,
echo   watcherInterval: null
echo }
echo.
echo const ask = q =^> new Promise(r =^> {
echo   const tempRl = readline.createInterface({
echo     input: process.stdin,
echo     output: process.stdout
echo   }^)
echo   tempRl.question(q, ans =^> {
echo     tempRl.close(^)
echo     r(ans^)
echo   }^)
echo }^)
echo.
echo const isRobloxRunning = async (^) =^> {
echo   try {
echo     const processes = await psList(^)
echo     return processes.some(p =^> p.name.toLowerCase(^) === config.targetProcess.toLowerCase(^)^)
echo   } catch {
echo     return false
echo   }
echo }
echo.
echo const cooldownReady = (^) =^> Date.now(^) - state.lastLaunch ^>= config.cooldownTime
echo.
echo const launchRoblox = (^) =^> {
echo   console.log('\nRoblox is not running.'^)
echo   console.log('Launching private server...\n'^)
echo.
echo   state.lastLaunch = Date.now(^)
echo   state.launchInProgress = true
echo.
echo   exec(`start "" "${state.serverLink}"`^)
echo.
echo   setTimeout((^) =^> {
echo     state.launchInProgress = false
echo   }, config.cooldownTime^)
echo }
echo.
echo const watcher = async (^) =^> {
echo   if ^(!state.running^) return
echo   if (await isRobloxRunning(^)^) return
echo   if (state.launchInProgress^) return
echo   if ^(!cooldownReady(^)^) return
echo.
echo   launchRoblox(^)
echo }
echo.
echo const handleCtrlC = async (^) =^> {
echo   console.log('\n\nWatcher paused.'^)
echo   state.running = false
echo.
echo   if (state.watcherInterval^) {
echo     clearInterval(state.watcherInterval^)
echo     state.watcherInterval = null
echo   }
echo.
echo   const stop = await ask('\nStop watcher? (Y/N^): '^)
echo.
echo   if (stop.toLowerCase(^) === 'y'^) {
echo     console.log('\nWatcher stopped.'^)
echo     process.exit(0^)
echo   } else {
echo     console.log('\nWatcher resumed.'^)
echo     console.log('Continuing to watch same private server.'^)
echo     console.log('Press Ctrl + C to pause again.\n'^)
echo     state.running = true
echo     state.watcherInterval = setInterval(watcher, config.checkInterval^)
echo   }
echo }
echo.
echo const showUsage = async (^) =^> {
echo   console.log('\nHow this works:'^)
echo   console.log('• The script checks if Roblox is running every few seconds'^)
echo   console.log('• If Roblox is closed, it automatically opens your private server'^)
echo   console.log('• A cooldown prevents rapid relaunching\n'^)
echo   console.log('How to stop:'^)
echo   console.log('• Press Ctrl + C in this terminal window'^)
echo   console.log('• Or close the terminal entirely\n'^)
echo   await ask('Press Enter to return to the menu...'^)
echo   return mainMenu(^)
echo }
echo.
echo const startWatcher = async (^) =^> {
echo   state.serverLink = await ask('\nPaste your Roblox private server link (https://...^):\n^> '^)
echo.
echo   if ^(!state.serverLink.startsWith('https://'^)^) {
echo     console.log('\nInvalid link detected.'^)
echo     console.log('Make sure the URL starts with https://'^)
echo     console.log('Exiting.'^)
echo     process.exit(1^)
echo   }
echo.
echo   state.running = true
echo.
echo   console.log('\nWatcher started.'^)
echo   console.log('Roblox will be relaunched automatically if it closes.'^)
echo   console.log('Press Ctrl + C to pause.\n'^)
echo.
echo   process.on('SIGINT', handleCtrlC^)
echo.
echo   state.watcherInterval = setInterval(watcher, config.checkInterval^)
echo }
echo.
echo const mainMenu = async (^) =^> {
echo   console.log('\nRoblox Watcher'^)
echo   console.log('This tool automatically rejoins a private server if Roblox closes.\n'^)
echo   console.log('[1] Start automatic private server rejoin'^)
echo   console.log('[2] View usage ^& how to stop\n'^)
echo.
echo   const choice = await ask('Select an option:\n^> '^)
echo.
echo   if (choice === '1'^) {
echo     await startWatcher(^)
echo   } else if (choice === '2'^) {
echo     await showUsage(^)
echo   } else {
echo     console.log('\nInvalid option.'^)
echo     return mainMenu(^)
echo   }
echo }
echo.
echo mainMenu(^)
) > watcher.js

(
echo @echo off
echo cd /d "%%%%~dp0"
echo node watcher.js
) > run.bat

cls
echo =====================================
echo RobloxWatcher installed successfully
echo =====================================
echo.
echo Folder: %BASE%
echo.
echo A "run.bat" file has been created.
echo Double-click run.bat to start the watcher.
echo.
pause
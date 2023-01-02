const { app, BrowserWindow, ipcMain } = require('electron')
const { Menu, Tray } = require('electron')
const path = require('path')

function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 600,
    height: 400,
    show: false,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: true,
      contextIsolation: false
    },
    frame: false,
  })

  mainWindow.webContents.session.webRequest.onBeforeSendHeaders(
    (details, callback) => {
      callback({ requestHeaders: { Origin: '*', ...details.requestHeaders } });
    },
  );

  mainWindow.webContents.session.webRequest.onHeadersReceived((details, callback) => {
    callback({
      responseHeaders: {
        'Access-Control-Allow-Origin': ['*'],
        ...details.responseHeaders,
      },
    });
  });

  //if the app is already running, then focus on the window.
  const gotTheLock = app.requestSingleInstanceLock()
  if (!gotTheLock) {
    app.quit()
  } else {
    app.on('second-instance', (event, commandLine, workingDirectory) => {
      // Someone tried to run a second instance, we should focus our window.
      if (mainWindow) {
        if (mainWindow.isMinimized()) mainWindow.show()
        mainWindow.focus()
      }
    })
  }

  mainWindow.once('ready-to-show', () => {
    mainWindow.show();
  });

  //ipc communication receive.
  ipcMain.on('window-min', function () {
    mainWindow.minimize();
  })
  ipcMain.on('window-max', function () {
    if (mainWindow.isMaximized()) {
      mainWindow.restore();
    } else {
      mainWindow.maximize();
    }
  })
  ipcMain.on('window-close', function () {
    mainWindow.hide();
  })

  mainWindow.loadFile('index.html')

  // mainWindow.webContents.openDevTools({ mode: 'bottom' })

  tray.on("click", () => {
    mainWindow.show();
  })
}

app.whenReady().then(() => {
  createWindow()

  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow()
  })
})

app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit()
})

let tray = null
app.on('ready', () => {
  tray = new Tray(path.join(__dirname, 'img/icon/icon.ico'));
  const contextMenu = Menu.buildFromTemplate([
    { label: '退出', click: function () { app.quit() } }
  ])
  tray.setToolTip('铃声系统')
  tray.setContextMenu(contextMenu)
})
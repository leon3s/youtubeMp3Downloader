var BrowserWindow, app, mainWindow, ref;

ref = require('electron'), app = ref.app, BrowserWindow = ref.BrowserWindow;

mainWindow = null;

app.on('window-all-closed', function() {
  if (process.platform !== 'darwin') {
    return app.quit();
  }
});

app.on('ready', function() {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600
  });
  mainWindow.loadURL('file://' + __dirname + '/app.html');
  return mainWindow.on('closed', function() {
    return mainWindow = null;
  });
});

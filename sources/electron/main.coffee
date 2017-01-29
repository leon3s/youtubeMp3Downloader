{app, BrowserWindow} = require('electron')

mainWindow = null;

app.on 'window-all-closed', ->
  if process.platform isnt 'darwin'
    app.quit();

app.on 'ready', ->
  mainWindow = new BrowserWindow
		fullscreen: true
		skipTaskbar: true
		darkTheme: true
		menu: false


	mainWindow.setMenu null
  mainWindow.loadURL 'file://' + __dirname + '/app.html'
  mainWindow.on 'closed', ->
    mainWindow = null

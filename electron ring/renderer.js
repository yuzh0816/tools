/**
 * This file is loaded via the <script> tag in the index.html file and will
 * be executed in the renderer process for that window. No Node.js APIs are
 * available in this process because `nodeIntegration` is turned off and
 * `contextIsolation` is turned on. Use the contextBridge API in `preload.js`
 * to expose Node.js functionality from the main process.
 */

//ipc communication send.
var ipc = require('electron').ipcRenderer;

function minimizeWin() {
    ipc.send('window-min') // 通知主进程进行窗口最小化操作
};
function maximizeWin() {
    ipc.send('window-max') // 通知主进程进行最大化或还原
};
function closeWin() {
    ipc.send('window-close') // 通知主进程关闭
};

var show = document.getElementById("showTime");
setInterval(function () {
    var time = new Date();
    //获取时间的小时和分钟和秒数，小于10的在前面补0
    var h = time.getHours() < 10 ? "0" + time.getHours() : time.getHours();
    var m = time.getMinutes() < 10 ? "0" + time.getMinutes() : time.getMinutes();
    var s = time.getSeconds() < 10 ? "0" + time.getSeconds() : time.getSeconds();
    var t = h + ":" + m + ":" + s;
    showTime.innerHTML = t;
}, 100);


let { shell } = require('electron')
let site = document.querySelector("#site");
site.onclick = function (e) {
    e.preventDefault();
    let href = this.getAttribute('href');
    shell.openExternal(href);
}
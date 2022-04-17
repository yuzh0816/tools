@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
taskkill /f /t /im GATESRV.exe
taskkill /f /t /im StudentMain.exe
echo "已关闭学生终端"
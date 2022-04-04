@echo off
chcp 65001
%1 %2
ver|find "5.">nul&&goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin
schtasks /create /xml "C:/RING/tasks/OnClass.xml" /tn "\TASK-RING\OnClass" /RU "%USERNAME%"
schtasks /create /xml "C:/RING/tasks/OffClass.xml" /tn "\TASK-RING\OffClass" /RU "%USERNAME%"
echo 计划任务已设定。
pause
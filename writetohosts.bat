@echo off
set /p ip=请输入ip地址 
set /p host=请输入域名 
ECHO ^ip host>>%WINDIR%\system32\drivers\etc\hosts
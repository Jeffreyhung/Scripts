@echo off
FOR /F %%i IN (D:\Automation\word_list.txt) DO START /B microsoft-edge:"https://www.bing.com/search?q="%%i
rem taskkill /F /IM MicrosoftEdge.exe /T
EXIT
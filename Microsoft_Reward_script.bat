REM This script will perform some searches using Edge, it will take take the keyword from the word_list and search it using Bing
REM It is used to get some points for Microsoft Reward for the "PC Search" reward

@echo off
FOR /F %%i IN (word_list.txt) DO START /B microsoft-edge:"https://www.bing.com/search?q="%%i
rem taskkill /F /IM MicrosoftEdge.exe /T
EXIT

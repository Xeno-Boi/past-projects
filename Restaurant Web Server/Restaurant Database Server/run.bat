@echo off
cd code

echo installing dependencies
echo.
call npm install
echo.
echo fixing errors if needed
echo.
call npm audit fix
echo.



:q
echo Reset Database? [Y/N] (choose Y when loading for the first time)
set /p input=
if /i "%input%"=="Y" goto yes
if /i "%input%"=="N" goto no
goto q

:yes
echo.
echo reseting database
node database-initializer.js
echo reset finished
echo.
goto endq

:no
goto endq

:endq

echo.
echo starting server
echo press "CTRL C" to terminate
echo.
call node server.js
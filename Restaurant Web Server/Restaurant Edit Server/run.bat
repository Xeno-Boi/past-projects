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

echo starting server
echo press "CTRL C" to terminate
echo.
call node server.js
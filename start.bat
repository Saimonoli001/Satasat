@echo off
echo =========================================
echo    Starting Satasat Local Environment
echo =========================================

REM Check if java is in PATH
java -version >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Java is not recognized in your system PATH.
    echo Trying to use a local JDK if available...
    
    REM Add common local IDE JDKs here if needed, or prompt the user.
    IF EXIST "C:\Program Files\JetBrains\IntelliJ IDEA 2025.3.2\jbr" (
        set "JAVA_HOME=C:\Program Files\JetBrains\IntelliJ IDEA 2025.3.2\jbr"
        echo [INFO] Found IntelliJ JDK. Using that.
    ) ELSE (
        echo [ERROR] Please install Java JDK 17 and make sure it is added to your PATH!
        pause
        exit /b 1
    )
) ELSE (
    echo [INFO] Java is detected on this system.
)

echo.
echo [INFO] Downloading dependencies and starting the local server...
echo [INFO] This might take a minute on the first run.
echo.

call mvnw.cmd clean jetty:run

echo.
pause

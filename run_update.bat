@echo off
chcp 65001 >nul
setlocal

set "REPO=E:\repos"

cd /d "%REPO%" || (echo НЕ НАШЕЛ REPO: %REPO% & pause & exit /b 1)

echo ===== START %DATE% %TIME% =====
echo Repo: %CD%
echo.

echo === UPDATE DATA ===
py tools\update_sirus_ladder.py
if errorlevel 1 (
  echo ERROR: update_sirus_ladder.py failed
  pause
  exit /b 1
)

echo.
echo === GIT ADD ===
git add -A

echo === GIT CHECK ===
git diff --cached --quiet
if %errorlevel%==0 (
  echo No changes. Nothing to commit.
  pause
  exit /b 0
)

echo.
echo === GIT COMMIT ===
git commit -m "auto: update addon data"

echo.
echo === GIT PUSH ===
git push origin main
if errorlevel 1 (
  echo ERROR: git push failed
  pause
  exit /b 1
)

echo.
echo DONE: pushed to GitHub
pause
exit /b 0
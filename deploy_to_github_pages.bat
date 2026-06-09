@echo off
set "PROJECT_DIR=%cd%"
echo ============================================
echo THU MUC DU AN: %PROJECT_DIR%
echo ============================================
echo.

:: Kiem tra Git
git --version >nul 2>&1
if errorlevel 1 (
    echo [LOI] May cua ban chua cai dat Git hoac chua cau hinh PATH.
    echo Vui long tai va cai dat Git tai: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

:: Khoi tao Git neu chua co
if not exist "%PROJECT_DIR%\.git" (
    echo Khoi tao Git repository...
    git init
) else (
    echo Da co Git repository.
)

:: Tao file .gitignore
echo Dang tao file .gitignore...
echo client_secret.json > .gitignore
echo colorphoto_secret.txt >> .gitignore
echo *.py >> .gitignore
echo __pycache__/ >> .gitignore
echo *.pyc >> .gitignore
echo *.log >> .gitignore
echo node_modules/ >> .gitignore
echo .DS_Store >> .gitignore

:: Kiem tra file index.html
if not exist "%PROJECT_DIR%\index.html" (
    if exist "%PROJECT_DIR%\COLOR_PHOTO\_internal\index.html" (
        echo Di chuyen index.html tu _internal ra ngoai...
        move "%PROJECT_DIR%\COLOR_PHOTO\_internal\index.html" "%PROJECT_DIR%\index.html"
    ) else (
        echo [LOI] Khong tim thay index.html o thu muc goc.
        echo.
        pause
        exit /b 1
    )
)

:: Nhap URL repository tu GitHub
echo.
set /p REMOTE_URL="Nhap URL HTTPS cua repo GitHub (Vi du: https://github.com/ten-user/ten-repo.git): "
if "%REMOTE_URL%"=="" (
    echo [LOI] URL khong duoc de trong.
    pause
    exit /b 1
)

:: Cau hinh remote
git remote remove origin >nul 2>&1
git remote add origin %REMOTE_URL%

:: Commit file
echo.
echo Dang chuan bi file de day len GitHub...
git add .
git commit -m "Upload static files to GitHub Pages"

:: Push de de (Force Push) len GitHub de xoa loi README.md tu truoc
echo.
echo Dang day de code len GitHub (Force Push)...
git branch -M main
git push -f -u origin main
if errorlevel 1 (
    echo.
    echo [LOI] Khong the day code len GitHub.
    echo Vui long kiem tra tai khoan va nhap dung Personal Access Token (PAT) lam mat khau.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo [THANH CONG] Da day code len GitHub va ghi de file README!
echo.
echo Hay tai lai trang GitHub cua ban de kiem tra cac file.
echo ============================================================
echo.
pause

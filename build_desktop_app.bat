@echo off
title Dong goi COLOR PHOTO Desktop
chcp 65001 >nul 2>&1

echo ==============================================================
echo       DONG GOI THU MUC UNG DUNG COLOR PHOTO
echo ==============================================================
echo.

:: 1. Kiem tra Python
python --version >nul 2>&1
if %errorlevel% neq 0 goto :NO_PYTHON

echo [+] Da tim thay Python tren he thong.
echo.

:: 1b. Quet lay Client Secret tu COLOR PHOTO (Gia lap bao mat tu dong)
echo [+] Dang quet lay ma thong tin bao mat Google...
python extract_secret.py
echo.

:: 2. Cai dat thu vien can thiet
echo [+] Dang kiem tra va cai dat thu vien pywebview va pyinstaller...
pip install pywebview pyinstaller --quiet
if %errorlevel% neq 0 goto :INSTALL_ERROR
echo [+] Da cai dat day du cac thu vien can thiet.
echo.

:: 3. Dong goi ung dung o che do Thu muc
echo [+] Dang tien hanh dong goi ung dung o che do Thu muc...
echo Vui long cho trong giay lat...
echo.

python -m PyInstaller --clean --onedir --noconsole --add-data "index.html;." --add-data "viewer.html;." --add-data "colorphoto_secret.txt;." --name "COLOR_PHOTO" app.py
if %errorlevel% neq 0 goto :BUILD_ERROR

:: 4. Di chuyen thu muc ung dung ra ben ngoai
if not exist "dist\COLOR_PHOTO" goto :BUILD_ERROR

echo [+] Dang di chuyen thu muc ung dung ra thu muc main...
if exist "COLOR_PHOTO" rmdir /s /q "COLOR_PHOTO"
xcopy "dist\COLOR_PHOTO" "COLOR_PHOTO\" /E /I /Q /Y >nul

echo.
echo ==============================================================
echo [THANH CONG] Da tao thu muc ung dung "COLOR_PHOTO" hoan tat!
echo.
echo Cau truc thu muc bao gom:
echo  - COLOR_PHOTO\COLOR_PHOTO.exe (File chay chinh)
echo  - Cac file dll phu tro - vi du python310.dll, vcruntime140.dll...
echo  - Cac file .pyd - Ma may Python bien dich
@echo.
echo Ban hay vao thu muc COLOR_PHOTO va chay file COLOR_PHOTO.exe.
echo ==============================================================
goto :CLEANUP

:NO_PYTHON
echo [LOI] Khong tim thay Python tren may tinh cua ban!
echo Vui long tai va cai dat Python tu https://www.python.org/downloads/
echo Hay chac chan rang ban da chon o "Add Python to PATH" khi cai dat.
echo.
pause
exit /b

:INSTALL_ERROR
echo [LOI] Co loi xay ra trong qua trinh cai dat thu vien bang pip.
echo Vui long kiem tra ket noi mang va thu lai.
echo.
pause
exit /b

:BUILD_ERROR
echo [LOI] Quatrinh dong goi gap su co hoac khong tim thay thu muc dau ra!
pause
exit /b

:CLEANUP
echo.
echo [+] Dang don dep cac tep tin tam...
if exist "build" rmdir /s /q "build"
if exist "dist" rmdir /s /q "dist"
if exist "COLOR_PHOTO.spec" del /q "COLOR_PHOTO.spec"
echo [+] Hoan tat don dep.
echo.
pause

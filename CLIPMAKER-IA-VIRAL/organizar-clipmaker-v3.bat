@echo off
chcp 65001 >nul

REM CORRECAO: Força rodar na pasta onde o .bat está
cd /d "%~dp0"

REM Salva tudo num log
call :main > "log-organizar.txt" 2>&1
start notepad "log-organizar.txt"
pause
exit /b

:main
echo ============================================
echo  Reorganizando CLIPMAKER-IA-VIRAL...
echo ============================================
echo.
echo Pasta atual: %CD%
echo.

REM === 1. Mover .github para a raiz ===
echo [1/5] Movendo .github para a raiz...
if exist "NLW-OPERATOR-INICIANTE\.github" (
    xcopy "NLW-OPERATOR-INICIANTE\.github" ".github\" /E /I /Y
    echo      OK
) else (
    echo      AVISO: NLW-OPERATOR-INICIANTE\.github nao encontrado
)

REM === 2. Mover aulas para a raiz ===
echo.
echo [2/5] Movendo aulas para a raiz...
if exist "NLW-OPERATOR-INICIANTE\index_das_aulas" (
    xcopy "NLW-OPERATOR-INICIANTE\index_das_aulas" "aulas\" /E /I /Y
    echo      OK
) else (
    echo      AVISO: NLW-OPERATOR-INICIANTE\index_das_aulas nao encontrado
)

REM === 3. Renomear pasta de explicacao ===
echo.
echo [3/5] Renomeando pasta de explicacao...
for /d %%D in ("EXPLICA*") do (
    if exist "%%D\index.html" (
        echo      Encontrada: %%D
        xcopy "%%D" "explicacao\" /E /I /Y
        rd /s /q "%%D"
        echo      Renomeada para explicacao OK
    )
)

REM === 4. Verificar arquivos da raiz ===
echo.
echo [4/5] Verificando arquivos da raiz...
if not exist "index.html" (
    if exist "NLW-OPERATOR-INICIANTE\index.html" (
        copy "NLW-OPERATOR-INICIANTE\index.html" "index.html"
        echo      index.html copiado
    ) else (
        echo      AVISO: index.html nao encontrado
    )
) else (
    echo      index.html ja existe na raiz
)

REM === 5. Remover NLW-OPERATOR-INICIANTE ===
echo.
echo [5/5] Verificando NLW-OPERATOR-INICIANTE...
if exist "NLW-OPERATOR-INICIANTE" (
    echo      Pasta existe, removendo...
    rd /s /q "NLW-OPERATOR-INICIANTE"
    echo      OK
) else (
    echo      AVISO: Pasta nao encontrada
)

echo.
echo ============================================
echo  Fazendo commit no GitHub...
echo ============================================
git add .
git commit -m "refactor: reorganiza estrutura do projeto"
git push

echo.
echo ============================================
echo  TUDO PRONTO!
echo ============================================
exit /b

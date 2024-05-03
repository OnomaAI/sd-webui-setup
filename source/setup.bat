@echo off
cd /app/autobuild

REM clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
cd stable-diffusion-webui
REM switch branch to origin/dev
git checkout origin/master
REM match to commit https://github.com/AUTOMATIC1111/stable-diffusion-webui/commit/bef51aed032c0aaa5cfd80445bc4cf0d85b408b5
git reset --hard bef51aed032c0aaa5cfd80445bc4cf0d85b408b5

REM extend webui-user-args.txt to at the end of webui-user.sh
REM from ../webui-user-args.txt
type ..\webui-user-args.txt >> webui-user.sh 

REM clone required repositories to stable-diffusion-webui/extensions/

REM check if extensions folder exists
if not exist "extensions\" mkdir extensions
cd extensions

REM clone, read from extensions.txt
for /F "tokens=*" %%A in (..\..\extensions.txt) do (
    git clone %%A
)

cd ..

REM now at stable-diffusion-webui/
REM download models to stable-diffusion-webui/models/Stable-diffusion/
REM read from sd-models.txt 
REM <url> <optional_model_name>

for /F "tokens=1,2" %%A in (..\sd-models.txt) do (
    REM download model, save as <optional_model_name> if exists, else save as <url>
    if "%%B"=="" (
        curl -o models\Stable-diffusion\%%~nxA %%A
    ) else (
        curl -o models\Stable-diffusion\%%B %%A
    )
)

for /F "tokens=1,2" %%A in (..\lora.txt) do (
    REM download model, save as <optional_model_name> if exists, else save as <url>
    if "%%B"=="" (
        curl -o models\Lora\%%~nxA %%A
    ) else (
        curl -o models\Lora\%%B %%A
    )
)

for /F "tokens=1,2" %%A in (..\embeddings.txt) do (
    REM download model, save as <optional_model_name> if exists, else save as <url>
    if "%%B"=="" (
        curl -o embeddings\%%~nxA %%A
    ) else (
        curl -o embeddings\%%B %%A
    )
)

REM run webui.sh
REM .\webui.sh
REM then
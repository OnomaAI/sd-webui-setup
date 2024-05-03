# clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
cd /app/autobuild
READ_TOKEN=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
if [ -f .env ]; then
    export $(cat .env | xargs)
fi
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
cd stable-diffusion-webui
# switch branch to origin/dev
git checkout origin/master
# match to commit https://github.com/AUTOMATIC1111/stable-diffusion-webui/commit/bef51aed032c0aaa5cfd80445bc4cf0d85b408b5
git reset --hard bef51aed032c0aaa5cfd80445bc4cf0d85b408b5
# find python command to create venv
# from python3.11 to python3.10, else, use python3 
# set 'python_command' to available python version

python_command=python3.10
if ! command -v $python_command &> /dev/null
then
    python_command=python3
    echo "python3.10 not found, using python3"
fi

echo cwd: $(pwd)
export cwd=$(pwd)
# create venv
$python_command -m venv venv
# activate venv
source venv/bin/activate

# extend webui-user-args.txt to at the end of webui-user.sh
# from ../webui-user-args.txt
#cat ../webui-user-args.txt >> webui-user.sh 
cat $cwd/../webui-user-args.txt >> webui-user.sh
echo "" >> webui-user.sh
cat $cwd/../webui-user-python.txt >> webui-user.sh

# clone required repositories to stable-diffusion-webui/extensions/

# check if extensions folder exists
if [ ! -d "extensions" ]; then
    mkdir extensions
fi
cd extensions

# clone, read from extensions.txt
while read -r line; do
    git clone $line
done < $cwd/../extensions.txt


# finally
cd $cwd

# ensure that webui.sh is executable and exists
chmod +x webui.sh
if [ ! -f webui.sh ]; then
    echo "webui.sh not found"
    exit 1
fi

# now at stable-diffusion-webui/
# download models to stable-diffusion-webui/models/Stable-diffusion/
# read from sd-models.txt 
# <url> <optional_model_name>

while read -r line; do
    # split line into array
    IFS=' ' read -ra ADDR <<< "$line"
    # download model, save as <optional_model_name> if exists, else save as <url>
    if [ -z "${ADDR[1]}" ]; then
        wget -O models/Stable-diffusion/${ADDR[0]##*/} ${ADDR[0]}
    else
        wget -O models/Stable-diffusion/${ADDR[1]} ${ADDR[0]}
    fi
done < $cwd/../sd-models.txt

cd embeddings
git lfs clone https://onomaAI:$READ_TOKEN@huggingface.co/OnomaAI/tootoon-embedding/

mv tootoon-embedding/* .
rm -rf tootoon-embedding

cd $cwd # /app/autobuild/stable-diffusion-webui
cd models
mkdir Lora
cd Lora
git lfs clone https://onomaAI:$READ_TOKEN@huggingface.co/OnomaAI/tootoon-lora/

mv tootoon-lora/* .
rm -rf tootoon-lora

cd $cwd # /app/autobuild/stable-diffusion-webui

sed -i 's/can_run_as_root=0/can_run_as_root=1/' webui.sh
# run webui.sh
bash ./webui.sh -f # first run
# then
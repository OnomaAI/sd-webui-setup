# clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
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

# create venv
$python_command -m venv venv
# activate venv
source venv/bin/activate

# extend webui-user-args.txt to at the end of webui-user.sh
# from ../webui-user-args.txt
cat ../webui-user-args.txt >> webui-user.sh 

cat 'python_cmd="'$python_command'"' >> webui-user.sh

# clone required repositories to stable-diffusion-webui/extensions/

# check if extensions folder exists
if [ ! -d "extensions" ]; then
    mkdir extensions
fi
cd extensions

# clone, read from extensions.txt
while read -r line; do
    git clone $line
done < ../../extensions.txt


# finally
cd ..
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
done < ../sd-models.txt

while read -r line; do
    # split line into array
    IFS=' ' read -ra ADDR <<< "$line"
    # download model, save as <optional_model_name> if exists, else save as <url>
    if [ -z "${ADDR[1]}" ]; then
        wget -O models/Lora/${ADDR[0]##*/} ${ADDR[0]}
    else
        wget -O models/Lora/${ADDR[1]} ${ADDR[0]}
    fi
done < ../lora.txt

while read -r line; do
    # split line into array
    IFS=' ' read -ra ADDR <<< "$line"
    # download model, save as <optional_model_name> if exists, else save as <url>
    if [ -z "${ADDR[1]}" ]; then
        wget -O embeddings/${ADDR[0]##*/} ${ADDR[0]}
    else
        wget -O embeddings/${ADDR[1]} ${ADDR[0]}
    fi
done < ../embeddings.txt

# run webui.sh
# ./webui.sh
# then
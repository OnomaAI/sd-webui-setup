from huggingface_hub import HfApi
from dotenv import load_dotenv
import os

load_dotenv()
api = HfApi(token=os.getenv("UPLOAD_TOKEN"))

# /data0/DanbooruSQLite/danbooru2023-sqlite/all_bucket_included_refreshed_tag_0214.json
# print first 10 lines


if True:
    api.upload_folder(
        folder_path="../tootoon-webui/stable-diffusion-webui_test/extensions/sd-webui-controlnet/models",
        repo_id="OnomaAI/tootoon-controlnet",
        repo_type="model",
    )
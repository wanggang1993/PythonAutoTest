import requests


def download_file(ip, api, file_path, guardian_params):
    url = ip + api
    r = requests.get(url, stream=True, params=guardian_params)
    f = open(file_path, "wb")
    for chunk in r.iter_content(chunk_size=512):
        if chunk:
            f.write(chunk)

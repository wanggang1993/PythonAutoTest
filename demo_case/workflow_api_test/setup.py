#coding=utf-8

#1.get url
#2.get accesstoken
#3.replace variables.py

import requests
import json
import  argparse




def get_token(guardian_host):
    """
    获取token
    :param guardian_host:
    :return:
    """
    guardian_login_api = "https://" + guardian_host + ":8380/api/v1/login"
    guardian_token_api= "https://" + guardian_host + ":8380/api/v1/accessToken"
    guardian_session = requests.Session()
    # login
    data={
    "username": "admin",
    "password": "123"
    }
    header={
        "Content-Type": "application/json",
        "Accept": "application/json"
    }
    re=guardian_session.post(guardian_login_api,verify=False,data=json.dumps(data),headers=header)
    if  re.status_code==200:

        data={
        "name": "admin",
        "expiredTime": "0001-01-01T00:00:00"
        }

        re2=guardian_session.post(guardian_token_api,data=json.dumps(data), verify=False,headers=header)
        if  re2.status_code==200:
            dic=re2.json()
            guardian_access_token=dic['content']
        else:
            print("create token fail")
            guardian_access_token = -1


    else:
        print("guardian login  fail")
        guardian_access_token=-1
    return guardian_access_token




def  replace(file_path,old_str,new_str):
    """
    替换，将具体信息写入变量集
    :param file_path:
    :param old_str:
    :param new_str:
    :return:
    """
    f = open(file_path, 'r+')
    all_lines = f.readlines()
    f.seek(0)
    f.truncate()
    for line in all_lines:
        line = line.replace(old_str, new_str)
        f.write(line)
    f.close()




if __name__ =='__main__':
    parser=argparse.ArgumentParser()
    parser.add_argument("-wh", help="workflow_host", type=str)
    parser.add_argument("-gh", help="guardian host", type=str)

    args = parser.parse_args()
    workflow_host=args.wh
    inceptor_host=args.ih
    guardian_host=args.gh

    replace('variables.py', 'workflow_host', workflow_host)
    token=get_token(guardian_host)
    replace('variables.py','token_content',token)
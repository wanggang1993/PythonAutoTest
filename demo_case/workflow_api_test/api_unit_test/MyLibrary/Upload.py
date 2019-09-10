#coding=utf-8

import requests

class Upload(object):
    def upload_workgroup_py(self,ip,workspace_id,workgroup_name,filename,params):

        #cookies={'WORKFLOWSESSIONID':'1d71e033-fc8c-4652-935a-28b1c9122a73'}
        url = ip+"/api/v1/workgroups/upload-workgroup"
        f=open(filename,'r')
        content=f.read()
        payload = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"workspaceId\"\r\n\r\n%d\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"workgroupName\"\r\n\r\n%s\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%s\"\r\nContent-Type: application/json\r\n\r\n%s\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"%(workspace_id,workgroup_name,filename,content)
        #print(payload)
        headers = {
            'content-type': "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"
        }

        response = requests.request("POST", url, data=payload, headers=headers,params=params)

        #print(response.text)

        return {'status_code':response.status_code,'content':response.text}

    def upload_workflow_py(self, ip, workspace_id, workflow_name, filename,params):
        # cookies={'WORKFLOWSESSIONID':'1d71e033-fc8c-4652-935a-28b1c9122a73'}
        url = ip + "/api/v1/upload-workflow"
        f = open(filename, 'r')
        content = f.read()
        payload = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"workspaceId\"\r\n\r\n%d\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"workflowName\"\r\n\r\n%s\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%s\"\r\nContent-Type: application/json\r\n\r\n%s\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--" % (workspace_id, workflow_name, filename, content)
        # print(payload)
        headers = {
            'content-type': "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"
        }

        response = requests.request("POST", url, data=payload, headers=headers, params=params)

        # print(response.text)

        return {'status_code': response.status_code, 'content': response.text}

    def upload_jar(self, ip, filepath, filename, params):
        url = ip + "/api/v1/task/uploadFile"
        print(url)
        files = [('file', (filename, open(filepath, 'rb'), 'octet-stream'))]
        response = requests.request("POST", url, files=files, params=params)
        print(response.text)
        return {'status_code': response.status_code, 'content': response.text}

    def upload_file(self, ip, filePath, filename, params):
        url = ip + "/api/v1/sysconf/sms-config/uploadFile"
        files = [('file', (filename, open(filePath, 'rb')))]
        response = requests.request("POST", url, files=files, params=params)
        return {'status_code': response.status_code, 'content': response.text}

#cookies={'WORKFLOWSESSIONID':'1d71e033-fc8c-4652-935a-28b1c9122a73'}
#upload().upload_workgroup(cookies,121,'test_python1','../workgroup_api_test/workgroup_workgroup_sample.json')


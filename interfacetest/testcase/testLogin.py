import unittest
import requests
import json
requests.packages.urllib3.disable_warnings()

from interfacetest.common.configHttp import configHttp

server_ip = "172.26.5.33"
class MyTestCase(unittest.TestCase):
    def test_login(self):
        # header = {"Content-Type": "application/json;charset=UTF-8"}
        # data = {"name": "admin", "password": "123"}
        # confhttp = ConfigHttp.ConfigHttp()
        # confhttp.set_url('/catalog/api/v1/user/login')
        # confhttp.set_headers(header)
        # confhttp.set_data(data)
        # res=confhttp.post()
        # status_code=res.status_code
        catalog_login_api = "https://" + server_ip + ":28080/catalog/api/v1/user/login"
        catalog_session = requests.Session()
        # login
        data = {"name": "admin", "password": "123"}
        header = {"Content-Type": "application/json;charset=UTF-8"}
        res = catalog_session.post(catalog_login_api, verify=False, data=json.dumps(data), headers=header)
        self.assertEqual(res.status_code, 200)


if __name__ == '__main__':
    unittest.main()

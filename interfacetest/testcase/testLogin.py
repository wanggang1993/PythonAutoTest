import unittest
import requests
import json
import interfacetest.common.ConfigHttp
from interfacetest.common.ConfigHttp import ConfigHttp

requests.packages.urllib3.disable_warnings()
localConfigHttp = ConfigHttp()
server_ip = "172.26.5.33"


class MyTestCase(unittest.TestCase):
    def test_login(self):
        header = {"Content-Type": "application/json;charset=UTF-8"}
        data = {"name": "admin", "password": "123"}
        jsondata = json.dumps(data)
        localConfigHttp.set_url('/catalog/api/v1/user/login')
        localConfigHttp.set_headers(header)
        localConfigHttp.set_data(jsondata)
        res = localConfigHttp.post()
        self.assertEqual(200, res.status_code)


if __name__ == '__main__':
    unittest.main()

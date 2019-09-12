import os
import unittest
from interfacetest.common import HTMLTestRunner
from ReadConfig import ReadConfig
from interfacetest.common.ConfigHttp import ConfigHttp
from interfacetest.common.Log import MyLog as Log

# from interfacetest.common.common import logger

localConfigHttp = ConfigHttp()
log = Log.get_log()
logger = log.get_logger()


class RunAll:
    caselistFile = os.path.join(ReadConfig.proDir, "caseList")
    caseList = []

    def __init__(self):
        pass

    def set_case_list(self):

        fb = open(self.caselistFile)
        for value in fb.readlines():
            data = str(value)
            if data != '' and not data.startswith("#"):
                self.caseList.append(data.replace("\n", ""))
        fb.close()

    # def test(self):
    #
    #     for case in self.caseList:
    #         case_file = os.path.join(ReadConfig.proDir, "testcase")
    #         print(case_file)
    #         case_name = case.split("/")[-1]
    #         print case_name

    def set_case_suite(self):
        self.set_case_list()
        test_suite = unittest.TestSuite()
        suite_model = []

        for case in self.caseList:
            # print case
            case_file = os.path.join(ReadConfig.proDir, "testcase", "user")
            print(case_file)
            # case_name = case.split("/")[-1]
            print(case + ".py")
            discover = unittest.defaultTestLoader.discover(case_file, pattern='test*.py')
            print discover
            suite_model.append(discover)
            print suite_model

        if len(suite_model) > 0:
            for suite in suite_model:
                for test_name in suite:
                    test_suite.addTest(test_name)
        else:
            return None
        return test_suite

    def run(self):
        resultPath=os.path.join(ReadConfig.proDir, "result", "Myreport.html")
        try:
            suit = self.set_case_suite()
            print suit
            if suit is not None:
                logger.info("********TEST START********")
                fp = open(resultPath, 'wb')
                runner = HTMLTestRunner.HTMLTestRunner(stream=fp, title='Test Report', description='Test Description')
                runner.run(suit)
            else:
                logger.info("Have no case to test.")
        except Exception as ex:
            logger.error(str(ex))
        finally:
            logger.info("*********TEST END*********")
            # send test report by email
            if int(1) == 0:
                self.email.send_email()
            elif int(1) == 1:
                logger.info("Doesn't send report email to developer.")
            else:
                logger.info("Unknow state.")


if __name__ == '__main__':
    rc = RunAll()
    #   rc.set_case_list()
    rc.set_case_suite()
    rc.run()

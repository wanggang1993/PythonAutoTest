#coding=utf-8

import json
import os
import datetime
class  ReadAndWrite(object):
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    def write_in_file(self, filename , content):
        jsObj = json.dumps(content)
        f=open(filename,'w')
        f.write(jsObj)
        f.close()


    def read_from_file(self, filename):
        f=open(filename,'r')
        content=f.read()
        dict=json.loads(content)
        return dict


    def json_to_dic(self,content):
        #dic=json.loads(content)
        return type(content)

    def dic_to_json(self,dic):
        return json.dumps(dic)

    def combine_data(self,info_dic,pattern_dic):

        for key in  info_dic:
            pattern_dic[key]=info_dic[key]


        return json.dumps(pattern_dic)
    def combine_dic_data(self,info_dic,pattern_dic):

        for key in  info_dic:
            pattern_dic[key]=info_dic[key]


        return pattern_dic

    def type(self,some):
        return  type(some)

    def get_path(self):
        return os.getcwd()

    def date_to_cron(self,year=None, month=None, day=None, hour=None, minute=None, second=None, week=None):
        """
        将日期转换为Cron表达式,https://en.wikipedia.org/wiki/Cron
        # >>> date_to_cron()
        # '* * * * * *'
        # >>> date_to_cron(month=2,day=21,hour=10,minute=21)     #2月21号早上10:21分
        # '21 10 21 2 * *'
        # >>> date_to_cron(month=2,hour=10,minute=21,week=(0,3)) #2月每个星期天和星期三早上10:21分
        # '21 10 * 2 0,3 *'
        # >>> date_to_cron(month=2,hour=10,minute=21,day=[1,5])  #2月1号到5号早上10:21分
        # '21 10 1-5 2 * *'
        # >>> date_to_cron(month=2,hour=10,minute=[21,55],day=[1,5]) #2月1到5号早上10点21分到55分
        '21-55 10 1-5 2 * *'
        """
        date_arr = [second, minute, hour, day, month, week, year]
        for i, d in enumerate(date_arr):
            if i != 5:
                if not d:
                    date_arr[i] = '*'
                else:
                    if isinstance(d, tuple):
                        d = ','.join(str(x) for x in d)
                    elif isinstance(d, list):
                        d = '-'.join(str(x) for x in d)
                    date_arr[i] = str(d)
            if i == 5:
                if not d:
                    date_arr[i] = '?'
                else:
                    if isinstance(d, tuple):
                        d = ','.join(str(x) for x in d)
                    elif isinstance(d, list):
                        d = '-'.join(str(x) for x in d)
                    date_arr[i] = str(d)
        expr = ' '.join(date_arr)

        return expr

    def get_schedule_cron(self, wait_minute):
        print("prepare time")
        now_time = datetime.datetime.now()
        wait_time = datetime.timedelta(minutes=int(wait_minute))
        schedule_time = now_time + wait_time

        schedule_year = datetime.datetime.strftime(schedule_time, '%Y')
        schedule_month = datetime.datetime.strftime(schedule_time, '%m')
        schedule_day = datetime.datetime.strftime(schedule_time, '%d')
        schedule_hour = datetime.datetime.strftime(schedule_time, '%H')
        schedule_minute = datetime.datetime.strftime(schedule_time, '%M')
        schedule_second = datetime.datetime.strftime(schedule_time, '%S')
        schedule_print = datetime.datetime.strftime(schedule_time, '%Y-%m-%d %H:%M:%S')
        print(schedule_print)
        schedule_cron = self.date_to_cron (schedule_year, schedule_month, schedule_day, schedule_hour, schedule_minute, schedule_second)
        return schedule_cron

    def read_line(self, filename):
        with open(filename, 'r') as f:
            words = f.read()
            lists = words.split('\n')
        return lists

    # def content_to_dic(self, str):
    #     content= str.replace("\\", "")
    #     result= json.loads(content)
    #     return result

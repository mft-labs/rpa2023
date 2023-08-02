from robot.api.deco import keyword, library
from datetime import datetime
import os
import requests
from urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

@library
class HealthCheck:
    def __init__(self, logname):
        self.logname = self.add_datetime(logname)

    def get_date_time(self):
        now = datetime.now()
        date_time = now.strftime("%Y%m%d%H%M%S")
        return date_time

    def get_date_time2(self):
        now = datetime.now()
        date_time = now.strftime("%Y-%m-%d %H:%M:%S")
        return date_time

    def add_datetime(self, filename):
        pos = filename.find('.')
        if pos != -1:
            newfilename = filename[:pos] + '_' + self.get_date_time() + filename[pos:]
            return newfilename
        return filename + '_' + self.get_date_time()

    def prepare_data(self, text):
        print('Preparing data')
        lines = text.split('\n')
        header = lines[0]
        data = lines[1:]
        print(header)
        print(data)
        header_flds = header.split()
        return header, header_flds, data

    @keyword('Get Pod')
    def get_pod(self, text):
        header_raw, headers, data = self.prepare_data(text)
        f = open(self.logname, 'w')
        f1 = open(self.logname+".err", 'w')
        f2 = open(self.logname+'.rpt', 'w')
        f2.write(text)
        f2.close()
        f.write('{:50s} {:20s} {:20s}\n'.format(headers[0], headers[2], headers[3]))
        f1.write('{:50s} {:20s} {:20s}\n'.format(headers[0], headers[2], headers[3]))
        error_occurred = False
        for elem in data:
            item = elem.split()
            f.write('{:50s} {:20s} {:20s}'.format(item[0], item[2], item[3]))
            if item[2].find('CrashLoopBackOff') != -1 or item[2].find('Error') != -1:
                # f1.write('Error occurred for {:50s}'.format(item[0]))
                f1.write('{:50s} {:20s} {:20s}'.format(item[0], item[2], item[3]))
                f1.write('\n')
                error_occurred = True
            f.write('\n')
        f.close()
        f1.close()
        if error_occurred:
            errors = open(self.logname+".err",'r').read()
            raise Exception('Some or all pods having errors and may be retries to recover\n{}\n'.format(errors))
        return '\nProcess of GET POD Completed'

    def split_string(self, colpos, rec):
        list1 = rec.split()
        for i in range(len(colpos)):
            if rec[colpos[i]] == ' ':
                list1.insert(i, ' ')
        return list1

    def find_cols(self, header_raw):
        colpos = []
        colpos.append(0)
        for i in range(len(header_raw)):
            if i+2 < len(header_raw):
                if header_raw[i] == ' ' and header_raw[i+1] == ' ' :
                    if header_raw[i+2] != ' ':
                        colpos.append(i+2)
        return colpos

    @keyword('Get Route')
    def get_route(self, text):
        logfile2 = self.logname
        base = os.path.basename(self.logname)
        logfile = 'get_route_'+os.path.basename(self.logname)
        logfile = logfile2.replace(base, logfile)
        header_raw, headers, data = self.prepare_data(text)
        f = open(logfile,'w')
        colpos = self.find_cols(header_raw)
        f.write(str(colpos)+'\n')
        index = headers.index('PORT')
        errorlog = open(logfile+".err", 'w')

        f.write(str(headers)+'\n')
        error_occurred = False
        for rec in data:
            fields = self.split_string(colpos,rec)
            f.write(str(fields)+'\n')
            f.write('{}\n'.format(fields[index]))
            if fields[index] == 'https' or fields[index] == 'http':
                label = fields[0]
                if str(fields[2]).strip() == '':
                    continue
                if str(fields[0]).strip().find('test')!=-1:
                    continue
                url = fields[index].strip()+'://'+str(fields[1]).strip()+str(fields[2]).strip()
                try:
                    resp = requests.get(url, verify=False)
                    f.write('{:50s} {:75s} {}'.format(label, url, resp.status_code))
                    if resp.status_code != 200:
                        error_occurred = True
                        errorlog.write('{} Name: {} Url: {} not reachable, status code {}'.format(self.get_date_time2(),label,url, resp.status_code))
                        errorlog.write('\n')
                    else:
                        f.write('{} Name: {} Url: {} reachable, status code {}'.format(self.get_date_time2(),label,url, resp.status_code))
                except Exception as e:
                    errorlog.write('{} Name: {} Url: {} not reachable, Exception raised {}'.format(self.get_date_time2(),label,url,e))
                    errorlog.write('\n')
                    error_occurred = True
        errorlog.close()
        f.close()
        if error_occurred:
            errors = open(logfile+".err").read()
            raise Exception("Error occurred while connecting to end points\n{}".format(errors))
            #return "Error occurred while connecting to end points\n{}".format(errors)
        else:
            return ""










from robot.api.deco import keyword, library
from datetime import datetime


@library
class HealthCheck:
    def __init__(self, logname):
        self.logname = self.add_datetime(logname)

    def get_date_time(self):
        now = datetime.now()
        date_time = now.strftime("%Y%m%d%H%M%S")
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
        return header_flds, data

    @keyword('Get Pod')
    def get_pod(self, text):
        headers, data = self.prepare_data(text)
        f = open(self.logname, 'w')
        f1 = open(self.logname+".err", 'w')
        f2 = open(self.logname+'.rpt', 'w')
        f2.write(text)
        f2.close()
        f.write('{:50s} {:20s} {:20s}'.format(headers[0], headers[2], headers[3]))
        f.write('\n')
        for elem in data:
            item = elem.split()
            f.write('{:50s} {:20s} {:20s}'.format(item[0], item[2], item[3]))
            if item[2].find('CrashLoopBackOff') != -1 or item[2].find('Error') != -1:
                f1.write('Error occurred for {:50s}'.format(item[0]))
                f1.write('\n')
            f.write('\n')
        f.close()
        f1.close()
        return '\nProcess of GET POD Completed'




    @keyword('Get Pod')
    def get_route(self, text):
        headers, data = self.prepare_data(text)
        name = headers[0]




    @keyword('Process Data')
    def parse_data(self, details, headers, data):
        f = open(self.logname, 'w')
        f1 = open(self.logname+".err", 'w')
        f2 = open(self.logname+'.rpt', 'w')
        f2.write(details)
        f2.close()
        #f.write(str(headers))
        f.write('{:50s} {:20s} {:20s}'.format(headers[0], headers[2], headers[3]))
        f.write('\n')
        for elem in data:
            # f.write(str(elem))
            item = elem.split()
            f.write('{:50s} {:20s} {:20s}'.format(item[0], item[2], item[3]))
            if item[2].find('CrashLoopBackOff') != -1 or item[2].find('Error') != -1:
                f1.write('Error occurred for {:50s}'.format(item[0]))
                f1.write('\n')
            f.write('\n')
        f.close()
        f1.close()
        return '\nParsing of data completed'

from robot.api.deco import keyword, library
import smtplib
from io import StringIO
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText

from email import encoders
import os

@library
class EmailNotifier:
    def __init__(self, smtpserver, sender, username=None, password=None, starttls=False):
        self.smtpserver = smtpserver
        self.sender = sender
        self.starttls = starttls
        self.username = username
        self.password = password

    @keyword('Send Notification')
    def send_notification(self, to, subject, text):
        msg = MIMEMultipart()
        msg['From'] = self.sender
        msg['To'] = to
        msg['Subject'] = subject
        msg.attach(MIMEText(text))
        mailServer = smtplib.SMTP(self.smtpserver)
        mailServer.ehlo()
        if self.starttls:
            mailServer.starttls()
        mailServer.ehlo()
        if self.username!=None and self.password!=None:
            mailServer.login(self.username, self.password)
        mailServer.sendmail(self.sender, to, msg.as_string())
        mailServer.close()
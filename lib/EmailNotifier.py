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
    def __init__(self, smtpserver, sender,  username=None, password=None, starttls=False):
        self.smtpserver = smtpserver
        self.sender = sender
        self.starttls = starttls
        self.username = username
        self.password = password

    def attach_document(self, docname):
        part = None
        with open(docname, "rb") as attachment:
            part = MIMEBase("application", "octet-stream")
            part.set_payload(attachment.read())
        encoders.encode_base64(part)
        filename = os.path.basename(docname).split('/')[-1]
        part.add_header(
            "Content-Disposition",
            f"attachment; filename= {filename}",
        )
        return part

    @keyword('Send Notification')
    def send_notification(self, to, cc, bcc, subject, text, doc1=None, doc2=None, doc3=None):
        msg = MIMEMultipart()
        msg['From'] = self.sender
        msg['To'] = ", ".join(to)
        msg['CC'] = ", ".join(cc)
        msg['Subject'] = subject
        msg.attach(MIMEText(text))
        if doc1 != None:
            msg.attach(self.attach_document(doc1))
        if doc2 != None:
                    msg.attach(self.attach_document(doc2))
        if doc3 != None:
                    msg.attach(self.attach_document(doc3))
        mailServer = smtplib.SMTP(self.smtpserver)
        mailServer.ehlo()
        if self.starttls:
            mailServer.starttls()
        mailServer.ehlo()
        if self.username!=None and self.password!=None:
            mailServer.login(self.username, self.password)
        toaddrs = to + cc + bcc
        mailServer.sendmail(self.sender, toaddrs, msg.as_string())
        mailServer.close()
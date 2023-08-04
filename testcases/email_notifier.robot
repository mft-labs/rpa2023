*** Settings ***
Variables   ../variables/email_config.py
Library     ../lib/EmailNotifier.py     ${SMTP_SERVER}     ${DEFAULT_SENDER}

*** Test Cases ***
Send Email Notification
     ${Document}=       Set Variable        report.html
     ${SUBJECT}=        Set Variable        Email Notification from Automation Tests
     ${Content}=        Set Variable        This is automated email notification
     Send Notification     ${NOTIFY_TO_LIST}      ${NOTIFY_CC_LIST}   ${NOTIFY_BCC_LIST}     ${SUBJECT}      ${Content}   ${Document}
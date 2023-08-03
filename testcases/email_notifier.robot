*** Settings ***
Library     ../lib/EmailNotifier.py     localhost:25     test@localhost


*** Test Cases ***
Send Email Notification
     ${TO_EMAIL}=       Set Variable        reports@localhost
     ${SUBJECT}=        Set Variable        Email Notification from Automation Tests
     ${Content}=        Set Variable        This is automated email notification
     Send Notification     ${TO_EMAIL}     ${SUBJECT}      ${Content}
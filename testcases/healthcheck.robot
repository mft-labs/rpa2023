*** Settings ***
Library     OperatingSystem
Library     String
Library     ../lib/HealthCheck.py    ${LOGNAME}
Library     SSHLibrary
Library     Collections
Variables   ../variables/sftpconfig.py

*** Test Cases ***
Check Pods
    ${text}=    Run    oc get pod
    ${result}=  Get Pod    ${text}
    Log         ${text}
    Log         ${result}

Check Routes
    ${text}=    Run    oc get route
    ${result}=  Get Route    ${text}
    Log         ${text}
    Log         ${result}

Check Sftp Connection
    Open Connection    ${SFTP_HOST}    port=${SFTP_PORT}
    Login    ${SFTP_USERNAME}    ${SFTP_PASSWORD}

    Put File    ${LOCAL_DIRECTORY}/${REMOTE_FILENAME}    ${REMOTE_DIRECTORY}/${REMOTE_FILENAME}

    SSHLibrary.Get File    ${REMOTE_DIRECTORY}/${REMOTE_FILENAME}    ${LOCAL_DIRECTORY}/${REMOTE_FILENAME}_downloaded.txt

    # List files
    @{files}    SSHLibrary.List Directory    ${REMOTE_DIRECTORY}
    Log    ${files}

    Close Connection

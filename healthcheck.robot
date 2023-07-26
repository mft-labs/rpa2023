*** Settings ***
Library     OperatingSystem
Library     String
Library     ./HealthCheck.py    ${LOGNAME}
Library    SSHLibrary
Library    Collections

*** Variables ***
${SFTP_HOST}           sftp.example.com
${SFTP_PORT}           22
${SFTP_USERNAME}       
${SFTP_PASSWORD}       
${REMOTE_DIRECTORY}    
${LOCAL_DIRECTORY}     
${REMOTE_FILENAME}     file.txt

*** Test Cases ***
Get Pod
    ${text}=    Run    oc get pod
    ${result}=  Get Pod    ${text}
    Log         ${text}
    Log         ${result}

Get Route
    ${text}=    Run    oc get route
    ${result}=  Get Route    ${text}
    Log         ${text}
    Log         ${result}

SFTP Test
    Open Connection    ${SFTP_HOST}    port=${SFTP_PORT}
    Login    ${SFTP_USERNAME}    ${SFTP_PASSWORD}

    Put File    ${LOCAL_DIRECTORY}/${REMOTE_FILENAME}    ${REMOTE_DIRECTORY}/${REMOTE_FILENAME}

    Get File    ${REMOTE_DIRECTORY}/${REMOTE_FILENAME}    ${LOCAL_DIRECTORY}/${REMOTE_FILENAME}_downloaded.txt

    # List files
    ${files}    List Directory    ${REMOTE_DIRECTORY}
    Log    Files in Remote Directory:    ${files}

    Close Connection

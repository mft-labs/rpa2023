*** Settings ***
Library     OperatingSystem
Library     String
Library     ./lib/HealthCheck.py    ${LOGNAME}

*** Test Cases ***

Get Pod
    ${text}=        Run         oc get pod
    ${result}=      Get Pod     ${text}
    Log     ${text}
    Log     ${result}

Get Route
    ${text}=        Run             oc get route
    ${result}=      Get Route       ${text}
    Log             ${text}
    Log             ${result}


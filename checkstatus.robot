*** Settings ***
Library     OperatingSystem
Library     String
Library     ./HealthCheck.py     ${LOGNAME}

*** Test Cases ***

Get Pod
    ${text}=        Run     oc get pod
    ${result}=      Get Pod     ${text}
    Log To Console  ${result}
    Log     ${text}

Get Route
    ${text}=        Run     oc get route
    ${result}=      Get Route   ${text}
    Log To Console  ${result}
    Log     ${text}


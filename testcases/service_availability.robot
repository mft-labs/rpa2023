*** Settings ***
Library     OperatingSystem
Library     Process
Library     String
Variables   ../variables/oclogin.py
Variables   ../variables/serviceavailability.py

*** Test Cases ***
Login To Openshift
    ${output}=  Run     ${OC_LOGIN_CMD}
    Should Not Contain       ${output}      Login failed
    Log     ${output}

Check Service Availability
    ${ServiceStatus}=   Set Variable        All Services Working
    FOR     ${key}    IN    @{SERVICE_LIST.keys()}
            ${result}=     Run     ${SERVICE_LIST["${key}"]}
            ${rc}   ${status}      Run Keyword And Ignore Error     Should Contain      ${result}       Connected to
            ${ServiceStatus}=     Set Variable If      '${rc}' == 'FAIL'      Failed to Connect: ${key}    ${ServiceStatus}
            Log      ${result}
    END
    Should Contain      ${ServiceStatus}        All Services Working

Logout From Openshift
    ${output}=    Run    oc logout
    Log    ${output}
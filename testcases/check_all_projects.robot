*** Settings ***
Library     OperatingSystem
Library     Process
Library     String
Variables   ../variables/oclogin.py
Library     ../lib/HealthCheck.py    occheck.log

*** Test Cases ***
Login To Openshift
    ${output}=  Run     ${OC_LOGIN_CMD}
    Should Not Contain       ${output}      Login failed
    Log     ${output}

Check All Projects
    ${projectslist}=    Run     oc get projects
    @{lines}=       Split To Lines      ${projectslist}     1
    Log         Projects List ${lines}
    ${header}=      Get Line      ${projectslist}   0
    Log     ${header}
    ${RouteStatus}=         Set Variable    Success
    FOR     ${line}     IN      @{lines}
        Log To Console      ${line}
        @{fields}=  Split String    ${line}
        ${switch2project}=      Run     oc project ${fields}[0]
        Should Contain      ${switch2project}       on project "${fields}[0]"
        # Log To Console      ${switch2project}
        Log To Console      Checking routes in the project "${fields}[0]"
        ${routes}=      Run     oc get routes
        ${rc}   ${status}      Run Keyword And Ignore Error   Get Route   ${routes}
        Run Keyword If      '${rc}' == 'FAIL'       Log     The error is: ${status}
        ${RouteStatus}=     Set Variable If      '${rc}' == 'FAIL'      ${status}
    END
    Should Not Contain      ${RouteStatus}      Error occurred

Logout From Openshift
    ${output}=    Run    oc logout
    Log    ${output}

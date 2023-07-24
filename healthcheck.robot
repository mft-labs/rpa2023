*** Settings ***
Library     OperatingSystem
Library     String
Library     ./HealthCheck.py    ${LOGNAME}
Library     RequestsLibrary
Library     StringFormat

*** Test Cases ***

Get Pod
    ${text}=        Run         oc get pod
    ${result}=      Get Pod     ${text}
    Log To Console  ${result}
    Log     ${text}

Get Route
    ${text}=        Run                 oc get route
    #${result}=      Get Route       ${text}
    ${lines}=       Split To Lines      ${text}     1
    ${header}=      Get Line            ${text}     0
    @{headers}=     Split String        ${header}
    FOR     ${line}     IN      @{lines}
        @{flds}=        Split String    ${line}
        Log To Console      ${flds}
        IF  ${flds}[4] == 'https'
            IF ${flds}[2] != ''
                ${url}=     Format String       https://{0}/{1}      ${flds}[1]     ${flds}[2]
                ${response}=    GET     ${url}
                Status Should Be    200
            ELSE
                ${url}=     Format String       https://{0}     ${flds}[1]
                ${response}=    GET     ${url}
                Status Should Be    200
            END
        END
    END


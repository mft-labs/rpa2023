*** Settings ***
Library     OperatingSystem
Library     String
Library     ./ProcessLib.py     ${LOGNAME}

*** Test Cases ***

Check Containers
    ${output}=      Run     oc get pods
    @{lines}=       Split To Lines      ${output}   1
    ${headline}     Get Line            ${output}   0
    @{header}       Split String        ${headline}
    ${result}=      Process Data    ${output}   ${header}     ${lines}
    Log To Console  ${result}
    Log     ${output}


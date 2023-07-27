*** Settings ***
Library     OperatingSystem

Library    Process

Library  SeleniumLibrary
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections
Variables   ../variables/apiconfig.py

*** Test Cases ***

 
Get Data

    Create Session  currentsession  ${URL}  verify=true
    ${response}=    GET On Session  currentsession  ${PATH}
    Status Should Be  200  ${response}
    Log    ${response.json()}


Post Data
    
    Create Session  currentsession  ${URL}  verify=true
    ${body}=    Get File    ${POST_JSON_DATA}
    ${response}=    POST On Session  currentsession  ${PATH}  data=${body}  headers=${POST_HEADERS}
    Status Should Be  200  ${response}
    ${GENERATED_ID}=    Set Variable    ${response.json()['empid']}
    Set Global Variable  ${GENERATED_ID} 
    Log    ${response.json()}
    Log To Console    \nEntity Id -> ${GENERATED_ID}

Put Data

    Create Session  currentsession  ${URL}  verify=true
    ${body}=    Get File    ${PUT_JSON_DATA}
    ${response}=  Put On Session  currentsession  ${PATH}/${GENERATED_ID}  data=${body}  headers=${POST_HEADERS}
    Status Should Be  200  ${response} 
    Log    ${response.json()}

Delete Data
    Create Session  currentsession  ${URL}  verify=true
    ${response}=  Delete On Session  currentsession  ${PATH}/${GENERATED_ID}  headers=${POST_HEADERS}
    Status Should Be  200  ${response} 
    Should Contain    ${response.json()}    msg    
    Log    ${response.json()['msg']}
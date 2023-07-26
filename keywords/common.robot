*** Keywords ***

open the browser
    Open Browser        ${HOMEPAGE}     ${BROWSER}

search topic
    [Arguments]         ${topic}
    Input Text          name=q          ${topic}
    Press Keys          name=q          ENTER

capture image
    Capture Page Screenshot

close the browser
    Close Browser
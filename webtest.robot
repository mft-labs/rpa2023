*** Settings ***
Library     Selenium2Library
Variables   ./variables/browser.py
Resource    ./keywords/common.robot


*** comments ***

Testing with Headless Browser

capture image
    Take Screenshot     webtest2

*** Test Cases ***
Open Browser
    open the browser

Search on Google
    search topic    MFTLABS

Take the Screenshot
    capture image

Cleanup
    close the browser



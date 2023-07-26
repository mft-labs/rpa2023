*** Settings ***
Library     Selenium2Library
Variables   ./variables/browser.py
Resource    ./keywords/common.robot


*** comments ***

Test cases with using headless browser

*** Test Cases ***
Open Browser
    open the browser

Search on Google
    search topic    MFTLABS

Take the Screenshot
    capture image

Cleanup
    close the browser



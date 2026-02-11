*** Settings ***
Library           SeleniumLibrary
Suite Setup       Open Browser    ${URL}    ${BROWSER}
Suite Teardown    Close Browser
 
*** Variables ***
${URL}            https://reg.up.ac.th/app/main
${BROWSER}        Chrome
${INPUT_WORD}     ทดลองคำนวณเกรด
${EXPECTED_RESULT}    ไม่เสี่ยงรีไทร์
 
*** Test Cases ***
calculate GPA Successfully 

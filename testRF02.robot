*** Settings ***
Library         SeleniumLibrary

*** Variables ***
${URL}              https://reg.up.ac.th
${BROWSER}          chrome
${USER_EMAIL}       67022692@up.ac.th
${PASSWORD}         (7525XxX2012)

*** Test Cases ***
Login via Office 365
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    
    # 1. ปิดประกาศ/คุกกี้
    ${cookie}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath://button[contains(., 'ยอมรับ')]    timeout=5s
    IF    ${cookie}    Click Element    xpath://button[contains(., 'ยอมรับ')]    END
    
    # 2. เข้าสู่ระบบ
    Wait Until Element Is Visible    css:.js-show-header-dropdown    timeout=10s
    Click Element    css:.js-show-header-dropdown
    Wait Until Element Is Visible    css:.btn-grad    timeout=5s
    Execute Javascript    document.querySelector('.btn-grad').click()

    # 3. หน้า Microsoft: กรอก Email
    Wait Until Element Is Visible    id:i0116    timeout=15s
    Input Text      id:i0116    ${USER_EMAIL}
    Click Element   id:idSIButton9
    
    # 4. หน้า Microsoft: กรอก Password
    Wait Until Element Is Visible    id:i0118    timeout=10s
    Sleep           1s
    Input Password  id:i0118    ${PASSWORD}
    Click Element   id:idSIButton9

    # 5. รอการ Approve MFA ในมือถือ (ตามรูปที่คุณส่งมา)
    ${is_mfa}=    Run Keyword And Return Status    Wait Until Page Contains    Approve sign in request    timeout=10s
    IF    ${is_mfa}
        Log To Console    MFA detected! Please approve on your phone...
        Sleep    10s    # รอให้คุณกดเลขในมือถือ
    END

    # 6. จัดการหน้า "Stay signed in?" (ปุ่ม Yes)
    ${stay_in}=    Run Keyword And Return Status    Wait Until Page Contains Element    id:idSIButton9    timeout=15s
    IF    ${stay_in}
        Wait Until Element Is Visible    id:idSIButton9    timeout=5s
        Sleep    1s
        Execute Javascript    document.querySelector('#idSIButton9').click()
    END

    # 7. ตรวจสอบ Login สำเร็จ และ "แคปภาพหน้าจอ"
    Wait Until Location Contains    reg.up.ac.th    timeout=20s
    Wait Until Page Contains        ออกจากระบบ       timeout=15s
    
    # --- ส่วนที่เพิ่มใหม่: แคปภาพผลลัพธ์ ---
    Capture Page Screenshot    filename=login_success.png
    Log To Console    Screenshot saved as login_success.png
    # ---------------------------------

    [Teardown]    Close Browser
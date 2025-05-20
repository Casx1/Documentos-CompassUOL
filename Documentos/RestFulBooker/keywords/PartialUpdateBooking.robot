*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ./_base.robot
Resource    ./Auth.robot

*** Keywords ***
PATCH PartialUpdateBooking
    [Arguments]    ${booking_id}
    ${status}    ${token}=    Criando sessao e obtendo token
    ${payload}=    Create Dictionary
    ...    firstname=James
    ...    lastname=Brown
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Cookie=token=${token}
    Create Session    BookerAPI    ${BASE_URL}
    ${response}=    Patch On Session
    ...    BookerAPI
    ...    /booking/${booking_id}
    ...    headers=${headers}
    ...    json=${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Log    ${response.status_code}

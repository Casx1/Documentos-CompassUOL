*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../_base.robot

*** Keywords ***
PUT UpdateBooking
    [Documentation]    Updates an existing booking with complete information using PUT method
    [Arguments]    ${booking_id}
    ${status}    ${token}=    Criando sessao e obtendo token
    ${bookingdates}=    Create Dictionary    checkin=2018-01-01    checkout=2019-01-01
    ${payload}=    Create Dictionary
    ...    firstname=James
    ...    lastname=Brown
    ...    totalprice=111
    ...    depositpaid=${True}
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Breakfast
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Cookie=token=${token}
    Create Session    BookerAPI    ${BASE_URL}
    ${response}=    Put On Session
    ...    BookerAPI
    ...    /booking/${booking_id}
    ...    headers=${headers}
    ...    json=${payload}
    ${status_ok}=    Run Keyword And Return Status    Should Be Equal As Integers    ${response.status_code}    200
    Log    ${response.status_code}
    Log To Console    ${EMPTY}
    Run Keyword If    ${status_ok}    Log To Console    >>> Booking atualizado com sucesso. Status: ${response.status_code}
    ...    ELSE    Log To Console    \nFalha: Não foi possível atualizar o booking. Status code: ${response.status_code}

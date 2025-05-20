*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ./_base.robot

*** Keywords ***
GET GetBooking
    Criando sessao e obtendo token
    [Arguments]    ${booking_id}
    &{headers}=    Create Dictionary    Accept=application/json
    ${response}=    GET On Session    BookerAPI    /booking/${booking_id}    headers=${headers}
    IF    ${response.status_code} == 200
        Log To Console    >>> ${response.status_code}
    ELSE
        Log To Console    >>> Falha ao buscar booking. Status: ${response.status_code}
    END

    
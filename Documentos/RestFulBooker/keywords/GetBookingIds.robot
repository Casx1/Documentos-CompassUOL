*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ./_base.robot

*** Keywords ***
GET GetBookingIds
    Criando sessao e obtendo token
    ${response}=    GET On Session    BookerAPI    /booking
    IF    ${response.status_code}==200
        Log To Console    >>> ${response.status_code}
    ELSE
        Log To Console    >>> Falha ao buscar bookings
    END

*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ./_base.robot

*** Keywords ***
GET GetBooking
    Criando sessao e obtendo token
    ${response}=    GET On Session    BookerAPI    /booking/1
    IF    ${response.status_code}==200    
        Log To Console    >>> ${response.status_code}
    ELSE
        Log To Console    >>> Falha ao buscar booking.
        Log To Console    >>> ${response.status_code}
    END
    
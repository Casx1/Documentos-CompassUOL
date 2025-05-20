*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ./_base.robot

*** Keywords ***
PING PingHealtCheck
    Criando sessao e obtendo token
    ${response}=    GET On Session    BookerAPI    /ping
    Log To Console    >>> ${response.status_code}
*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../_base.robot

*** Keywords ***
PING PingHealtCheck
    Criando sessao e obtendo token
    ${response}=    GET On Session    BookerAPI    /ping
    Log To Console    ${EMPTY}
    Log To Console    >>> Ping obtido com sucesso. Status: ${response.status_code}
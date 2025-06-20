*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../_base.robot

*** Keywords ***
Printando retorno do token
     ${status}    ${token}=    Criando sessao e obtendo token
        IF    "${token}" != "null"
            Log To Console    ${EMPTY}
            Log To Console    >>> Token obtido com sucesso: ${token}
        ELSE
        Log To Console    >>> Falha no login.
            END
Printando retorno do status
    ${status}    ${token}=    Criando sessao e obtendo token
        IF    ${status} == 200
        Log To Console    ${EMPTY}
        Log To Console    >>> Login realizado com sucesso. Status: ${status}
        ELSE
        Log To Console    >>> Falha no login.
        END
    
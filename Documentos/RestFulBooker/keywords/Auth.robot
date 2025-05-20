*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ./_base.robot

*** Keywords ***
Printando retorno do token
     ${status}    ${token}=    Criando sessao e obtendo token
        IF    "${token}" != "null"
            Log To Console    >>> ${token}
        ELSE
        Log To Console    >>> Falha no login.
            END
Printando retorno do status
    ${status}    ${token}=    Criando sessao e obtendo token
        IF    ${status} == 200
        Log To Console    >>> ${status}
        ELSE
        Log To Console    >>> Falha no login.
        END
    
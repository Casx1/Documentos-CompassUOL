*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../_base.robot

*** Keywords ***
GET GetBooking
    [Documentation]    Busca informações de uma reserva específica pelo ID
    ...    Retorna o objeto da reserva em caso de sucesso ou ${None} em caso de falha
    [Arguments]    ${booking_id}

    # Validação do ID da reserva
    IF    "${booking_id}" == "${EMPTY}" or "${booking_id}" == "${None}"
        Log To Console    >>> Erro: ID da reserva não pode ser vazio
        RETURN    ${None}
    END

    # Configuração e execução da requisição
    Criando sessao e obtendo token
    &{headers}=    Create Dictionary    Accept=application/json
    ${response}=    GET On Session    BookerAPI    /booking/${booking_id}    headers=${headers}
    
    # Tratamento da resposta
    IF    ${response.status_code} == 200
        Log To Console    ${EMPTY}
        Log To Console    >>> Reserva encontrada com sucesso. Status: ${response.status_code}
        RETURN    ${response.json()}
    ELSE IF    ${response.status_code} == 404
        Log To Console    >>> Reserva não encontrada. Status: ${response.status_code}
        RETURN    ${None}
    ELSE
        Log To Console    >>> Falha ao buscar reserva. Status: ${response.status_code}
        RETURN    ${None}
    END
*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../_base.robot

*** Keywords ***
GET GetBookingIds
    [Documentation]    Obtém a lista de IDs de todas as reservas disponíveis no sistema.
    ...    
    ...    Realiza uma requisição GET para obter todos os IDs de reservas existentes.
    ...    Requer autenticação prévia através do endpoint /auth.
    ...    
    ...    Retornos possíveis:
    ...    - Lista de IDs de reservas (status 200)
    ...    - Lista vazia (status 404)
    ...    - Código de status HTTP (em caso de erro)
    [Tags]    booking    get    ids
    
    # Estabelece a sessão e autenticação
    ${auth_status}    ${auth_token}=    Criando sessao e obtendo token
    
    # Realiza a requisição GET para obter os IDs das reservas
    TRY
        ${response}=    GET On Session    BookerAPI    /booking
        ${status_code}=    Set Variable    ${response.status_code}
    EXCEPT    AS    ${error}
        Log To Console    >>> Erro na requisição: ${error}
        RETURN    500
    END
    
    # Valida o status code e processa a resposta
    IF    ${status_code} == 200
        ${booking_ids}=    Set Variable    ${response.json()}
        ${count}=    Get Length    ${booking_ids}
        Log To Console    ${EMPTY}
        Log To Console    >>> Reservas obtidas com sucesso. Status: ${status_code}
        RETURN    ${booking_ids}
    ELSE IF    ${status_code} == 404
        Log To Console    >>> Nenhuma reserva encontrada no sistema. Status: ${status_code}
        RETURN    ${EMPTY}
    ELSE
        Log To Console    >>> Falha ao buscar reservas. Status: ${status_code}. Verifique a disponibilidade do serviço.
        RETURN    ${status_code}
    END

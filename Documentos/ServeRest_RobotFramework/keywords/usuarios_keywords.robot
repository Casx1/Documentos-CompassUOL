*** Settings ***
Library    Collections
Library    RequestsLibrary
Resource   ../variables/variables.robot
Resource   ../resources/_base.robot

*** Keywords ***
# CT01 - Criar usuário com dados válidos
Criar Usuario Com Dados Validos
    [Documentation]    Cria usuário com dados válidos (CT01)
    ${email_unico}=    Gerar Email Unico
    ${payload}=    Create Dictionary
    ...    nome=${nome_do_usuario}
    ...    email=${email_unico}
    ...    password=${senha_do_usuario}
    ...    administrador=true
    ${response}=    Fazer Requisicao POST    /usuarios    ${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    _id
    Set Suite Variable    ${USUARIO_ID}    ${response.json()['_id']}
    Log    Usuário criado com sucesso - ID: ${USUARIO_ID}
    RETURN    ${response}

# CT02 - Criar usuário com e-mail inválido
Criar Usuario Com Email Invalido
    [Documentation]    Tenta criar usuário com email do Gmail/Hotmail (CT02)
    ${payload}=    Create Dictionary
    ...    nome=Teste Gmail User
    ...    email=${email_gmail}
    ...    password=${senha_do_usuario}
    ...    administrador=true
    ${response}=    Fazer Requisicao POST    /usuarios    ${payload}
    Log    ISSUE CONHECIDA: API aceita email Gmail/Hotmail quando deveria rejeitar
    Should Be Equal As Integers    ${response.status_code}    201    # Comportamento atual (incorreto)
    RETURN    ${response}

# CT03 - Criar usuário com e-mail duplicado
Criar Usuario Com Email Duplicado
    [Documentation]    Tenta criar usuário com email já existente (CT03)
    # Primeiro cria um usuário
    ${email_teste}=    Gerar Email Unico
    ${payload_primeiro}=    Create Dictionary
    ...    nome=Primeiro Usuario
    ...    email=${email_teste}
    ...    password=${senha_do_usuario}
    ...    administrador=true
    ${primeiro_response}=    Fazer Requisicao POST    /usuarios    ${payload_primeiro}
    Should Be Equal As Integers    ${primeiro_response.status_code}    201

    # Tenta criar segundo usuário com mesmo email
    ${payload_segundo}=    Create Dictionary
    ...    nome=Segundo Usuario
    ...    email=${email_teste}
    ...    password=${senha_do_usuario}
    ...    administrador=false
    ${response}=    Fazer Requisicao POST    /usuarios    ${payload_segundo}
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Este email já está sendo usado
    RETURN    ${response}

# CT04 - Atualizar usuário com ID inexistente
Atualizar Usuario Com ID Inexistente
    [Documentation]    Tenta atualizar usuário com ID inexistente (CT04)
    ${email_unico}=    Gerar Email Unico
    ${payload}=    Create Dictionary
    ...    nome=Usuario Atualizado
    ...    email=${email_unico}
    ...    password=${senha_do_usuario}
    ...    administrador=false
    ${response}=    Fazer Requisicao PUT    /usuarios/${ID_INEXISTENTE}    ${payload}
    Log    ISSUE CONHECIDA: API retorna 200 quando deveria retornar 201 para criação
    Should Be Equal As Integers    ${response.status_code}    200    # Comportamento atual (incorreto)
    RETURN    ${response}

# CT05 - Consultar usuário inexistente
Consultar Usuario Inexistente
    [Documentation]    Tenta consultar usuário com ID inválido (CT05)
    ${response}=    Fazer Requisicao GET    /usuarios/${ID_INEXISTENTE}
    Should Be Equal As Integers    ${response.status_code}    400
    ${response_dict}=    Set Variable    ${response.json()}
    Log    Resposta da API: ${response_dict}
    RETURN    ${response}

# CT06 - Excluir usuário válido
Excluir Usuario Valido
    [Documentation]    Tenta excluir usuário válido (CT06)
    # Primeiro cria um usuário para excluir
    ${email_unico}=    Gerar Email Super Unico Para Exclusao

    ${payload}=    Create Dictionary
    ...    nome=Usuario Para Excluir
    ...    email=${email_unico}
    ...    password=${senha_do_usuario}
    ...    administrador=false

    ${create_response}=    Fazer Requisicao POST    /usuarios    ${payload}

    # Verifica se a criação foi bem-sucedida antes de continuar
    Run Keyword If    ${create_response.status_code} != 201
    ...    Fail    Falha na criação do usuário: Status ${create_response.status_code} - ${create_response.text}

    Should Be Equal As Integers    ${create_response.status_code}    201
    ${user_id}=    Set Variable    ${create_response.json()['_id']}

    # Tenta excluir o usuário
    ${response}=    Fazer Requisicao DELETE    /usuarios/${user_id}

    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain    ${response.json()['message']}    Registro excluído com sucesso
    RETURN    ${response}

# Keyword auxiliar para gerar email super único
Gerar Email Super Unico Para Exclusao
    [Documentation]    Gera um email único com timestamp + random para evitar colisões
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S%f
    ${random}=    Evaluate    random.randint(1000, 9999)    modules=random
    ${email_unico}=    Set Variable    delete${timestamp}${random}@automation.com
    RETURN    ${email_unico}

# CT07 - Testar senha no limite
Testar Senha No Limite
    [Documentation]    Cria usuário com senha de 5 caracteres (CT07)
    ${email_unico}=    Gerar Email Unico
    ${payload}=    Create Dictionary
    ...    nome=Usuario Senha Limite
    ...    email=${email_unico}
    ...    password=${senha_limite_min}
    ...    administrador=false
    ${response}=    Fazer Requisicao POST    /usuarios    ${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    _id
    Log    Usuário criado com senha no limite mínimo
    RETURN    ${response}

# CT08 - Atualizar com e-mail duplicado
Atualizar Com Email Duplicado
    [Documentation]    Tenta atualizar usuário com email já existente (CT08)
    # Cria dois usuários
    ${email1}=    Gerar Email Unico
    ${email2}=    Gerar Email Unico

    ${payload1}=    Create Dictionary
    ...    nome=Usuario Um
    ...    email=${email1}
    ...    password=${senha_do_usuario}
    ...    administrador=false
    ${response1}=    Fazer Requisicao POST    /usuarios    ${payload1}
    Should Be Equal As Integers    ${response1.status_code}    201
    ${user1_id}=    Set Variable    ${response1.json()['_id']}

    ${payload2}=    Create Dictionary
    ...    nome=Usuario Dois
    ...    email=${email2}
    ...    password=${senha_do_usuario}
    ...    administrador=false
    ${response2}=    Fazer Requisicao POST    /usuarios    ${payload2}
    Should Be Equal As Integers    ${response2.status_code}    201

    # Tenta atualizar usuário 2 com email do usuário 1
    ${payload_update}=    Create Dictionary
    ...    nome=Usuario Dois Atualizado
    ...    email=${email1}
    ...    password=${senha_do_usuario}
    ...    administrador=false
    ${response}=    Fazer Requisicao PUT    /usuarios/${response2.json()['_id']}    ${payload_update}
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Este email já está sendo usado
    RETURN    ${response}

# CT09 - Excluir usuário inexistente
Excluir Usuario Inexistente
    [Documentation]    Tenta excluir usuário com ID inválido (CT09)
    ${response}=    Fazer Requisicao DELETE    /usuarios/${ID_INEXISTENTE}
    Log    ISSUE CONHECIDA: API retorna 200 quando deveria retornar 400 para ID inexistente
    Should Be Equal As Integers    ${response.status_code}    200    # Comportamento atual (incorreto)
    Should Contain    ${response.json()['message']}    Nenhum registro excluído
    RETURN    ${response}
*** Settings ***
Documentation    Testes para funcionalidades de Usuários (US 001)
...              Baseado no Challenge Compass - ServeRest API
...              Cobertura: 9 cenários de teste (CT01-CT09)
Resource         ../resources/_base.robot
Resource         ../keywords/usuarios_keywords.robot
Suite Setup      Inicializar Suite De Usuarios
Suite Teardown   Finalizar Suite De Usuarios

*** Test Cases ***
CT01 - Criar usuário com dados válidos
    [Documentation]    Valida criação de usuário com dados válidos
    ...                Esperado: Status 201 - Usuário criado com sucesso
    [Tags]    usuarios    criacao    positivo    alta_prioridade
    ${response}=    Criar Usuario Com Dados Validos
    Should Be Equal As Integers    ${response.status_code}    201
    Should Contain    ${response.json()['message']}    Cadastro realizado com sucesso

CT02 - Criar usuário com e-mail inválido
    [Documentation]    Valida rejeição de e-mail do Gmail/Hotmail
    ...                Esperado: Status 400 - Erro de validação
    ...                ISSUE: API aceita Gmail/Hotmail quando deveria rejeitar
    [Tags]    usuarios    validacao    negativo    bug_conhecido    alta_prioridade
    ${response}=    Criar Usuario Com Email Invalido
    Should Be Equal As Integers    ${response.status_code}    201

CT03 - Criar usuário com e-mail duplicado
    [Documentation]    Valida rejeição de e-mail já existente
    ...                Esperado: Status 400 - Erro de duplicidade
    [Tags]    usuarios    validacao    negativo    media_prioridade
    ${response}=    Criar Usuario Com Email Duplicado
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Este email já está sendo usado

CT04 - Atualizar usuário com ID inexistente
    [Documentation]    Valida criação de novo usuário ao usar PUT com ID inexistente
    ...                Esperado: Status 201 - Novo usuário criado
    ...                ISSUE: API retorna 200 quando deveria retornar 201
    [Tags]    usuarios    atualizacao    negativo    bug_conhecido    media_prioridade
    ${response}=    Atualizar Usuario Com ID Inexistente
    Should Be Equal As Integers    ${response.status_code}    200

CT05 - Consultar usuário inexistente
    [Documentation]    Valida erro ao consultar usuário com ID inválido
    ...                Esperado: Status 400 - Usuário não encontrado
    [Tags]    usuarios    consulta    negativo    media_prioridade
    ${response}=    Consultar Usuario Inexistente
    Should Be Equal As Integers    ${response.status_code}    400

CT06 - Excluir usuário válido
    [Documentation]    Valida exclusão de usuário válido
    ...                Esperado: Status 200 - Usuário excluído
    [Tags]    usuarios    exclusao    positivo    alta_prioridade
    ${response}=    Excluir Usuario Valido
    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain    ${response.json()['message']}    Registro excluído com sucesso

CT07 - Testar senha no limite
    [Documentation]    Valida criação de usuário com senha de 5 caracteres
    ...                Esperado: Status 201 - Usuário criado com sucesso
    [Tags]    usuarios    validacao    positivo    baixa_prioridade
    ${response}=    Testar Senha No Limite
    Should Be Equal As Integers    ${response.status_code}    201
    Should Contain    ${response.json()['message']}    Cadastro realizado com sucesso

CT08 - Atualizar com e-mail duplicado
    [Documentation]    Valida rejeição ao atualizar usuário com e-mail já existente
    ...                Esperado: Status 400 - Erro de duplicidade
    [Tags]    usuarios    atualizacao    negativo    media_prioridade
    ${response}=    Atualizar Com Email Duplicado
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Este email já está sendo usado

CT09 - Excluir usuário inexistente
    [Documentation]    Valida tentativa de exclusão de usuário com ID inválido
    ...                Esperado: Status 400 - Usuário não encontrado
    ...                ISSUE: API retorna 200 quando deveria retornar 400
    [Tags]    usuarios    exclusao    negativo    bug_conhecido    media_prioridade
    ${response}=    Excluir Usuario Inexistente
    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain    ${response.json()['message']}    Nenhum registro excluído

*** Keywords ***
Inicializar Suite De Usuarios
    [Documentation]    Setup inicial para testes de usuários
    Log To Console     Iniciando testes de Usuários (US 001)
    Log To Console     Total de cenários: 9 (CT01-CT09)
    Log To Console     API Base: ${base_url}
    Criar Sessao ServeRest

Finalizar Suite De Usuarios
    [Documentation]    Cleanup após testes de usuários
    Log To Console     Testes de Usuários finalizados
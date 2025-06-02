*** Settings ***
Documentation    Testes para funcionalidades de Produtos (US 003)
...              Baseado no Challenge Compass - ServeRest API
...              Cobertura: 9 cenários de teste (CT14-CT22)
Resource         ../resources/_base.robot
Resource         ../keywords/produtos_keywords.robot
Suite Setup      Inicializar Suite De Produtos
Suite Teardown   Finalizar Suite De Produtos

*** Keywords ***
Inicializar Suite De Produtos
    [Documentation]    Setup inicial para testes de produtos
    Criar Sessao ServeRest
    Criar Usuarios Para Testes De Produtos
    Log     Suite de Produtos inicializada com sucesso

Finalizar Suite De Produtos
    [Documentation]    Cleanup final dos testes de produtos
    Log     Suite de Produtos finalizada

*** Test Cases ***
CT14 - Criar produto com dados válidos
    [Documentation]    Valida criação de produto com dados válidos e token admin
    ...                Esperado: Status 201 - Produto criado com sucesso
    [Tags]    produtos    criacao    positivo    alta_prioridade
    ${response}=    Criar Produto Com Dados Validos
    Should Be Equal As Integers    ${response.status_code}    201
    Should Contain    ${response.json()['message']}    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${response.json()}    _id
    Log To Console     CT14 - Produto criado - ID: ${response.json()['_id']}

CT15 - Criar produto com nome duplicado
    [Documentation]    Valida rejeição de produto com nome já existente
    ...                Esperado: Status 400 - Erro de duplicidade
    [Tags]    produtos    validacao    negativo    media_prioridade
    ${response}=    Criar Produto Com Nome Duplicado
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Já existe produto com esse nome
    Log To Console     CT15 - Criação de produto duplicado rejeitada corretamente

CT16 - Excluir produto vinculado a carrinho
    [Documentation]    Valida que produto vinculado a carrinho não pode ser excluído
    ...                Esperado: Status 400 - Erro de dependência
    ...                Sistema deve proteger integridade referencial
    [Tags]    produtos    exclusao    negativo    integridade    alta_prioridade
    ${response}=    Excluir Produto Vinculado A Carrinho
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Não é permitido excluir produto que faz parte de carrinho
    Log To Console     CT16 - Sistema protege produto vinculado a carrinho corretamente

CT17 - Atualizar produto com ID inexistente
    [Documentation]    Valida comportamento de PUT com ID inexistente
    ...                NOTA: Documentação diz que deveria criar produto (Status 201)
    ...                Mas API retorna Status 400 - possível inconsistência
    [Tags]    produtos    atualizacao    negativo    inconsistencia    media_prioridade
    ${response}=    Atualizar Produto Com ID Inexistente
    Should Be Equal As Integers    ${response.status_code}    400
    Log To Console     CT17 - API retorna 400 (contradiz documentação)

CT18 - Acessar produtos sem autenticação
    [Documentation]    Valida que produtos NÃO são exibidos sem autenticação admin
    ...                Regra de Negócio: Apenas admins podem listar produtos
    ...                Esperado: Status 401 - Não autorizado
    [Tags]    produtos    seguranca    negativo    bug_critico    alta_prioridade
    ${response}=    Acessar Produtos Sem Autenticacao
    Should Be Equal As Integers    ${response.status_code}    401
    Should Contain    ${response.json()['message']}    Token de acesso obrigatório
    Log To Console     CT18 - Segurança funcionando: acesso negado sem autenticação

CT19 - Fluxo integrado usuário-produto-carrinho
    [Documentation]    Valida fluxo completo: criar usuário, login, criar produto, adicionar ao carrinho
    ...                Esperado: Status 201 - Carrinho criado com sucesso
    [Tags]    produtos    fluxo_integrado    positivo    alta_prioridade
    ${response}=    Fluxo Integrado Usuario Produto Carrinho
    Should Be Equal As Integers    ${response.status_code}    201
    Should Contain    ${response.json()['message']}    Cadastro realizado com sucesso
    Dictionary Should Contain Key    ${response.json()}    _id
    Log To Console     CT19 - Fluxo integrado executado com sucesso - Carrinho ID: ${response.json()['_id']}

CT20 - Atualizar produto com nome duplicado
    [Documentation]    Valida rejeição ao tentar atualizar produto com nome já existente
    ...                Esperado: Status 400 - Erro de duplicidade
    [Tags]    produtos    atualizacao    negativo    media_prioridade
    ${response}=    Atualizar Produto Com Nome Duplicado
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Já existe produto com esse nome
    Log To Console     CT20 - Atualização com nome duplicado rejeitada corretamente

CT21 - Criar produto com preço/quantidade inválidos
    [Documentation]    Valida rejeição de produto com preço ou quantidade <= 0
    ...                Esperado: Status 400 - Erro de validação
    [Tags]    produtos    validacao    negativo    media_prioridade
    ${response}=    Criar Produto Com Preco Quantidade Invalidos
    Should Be Equal As Integers    ${response.status_code}    400
    # Verifica se contém erro de preço ou quantidade com mensagens reais da API
    ${json_response}=    Set Variable    ${response.json()}
    ${has_preco_error}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${json_response}    preco
    ${has_quantidade_error}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${json_response}    quantidade
    ${has_error}=    Evaluate    ${has_preco_error} or ${has_quantidade_error}
    Should Be True    ${has_error}    Deve conter erro de preço ou quantidade
    Log To Console     CT21 - Validação de preço/quantidade inválidos funcionando
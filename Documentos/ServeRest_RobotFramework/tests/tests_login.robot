*** Settings ***
Documentation    Testes para funcionalidades de Login (US 002)
...              Baseado no Challenge Compass - ServeRest API
...              Cobertura: 4 cenários de teste (CT10-CT13)
Resource         ../resources/_base.robot
Resource         ../keywords/login_keywords.robot
Suite Setup      Inicializar Suite De Login
Suite Teardown   Finalizar Suite De Login

*** Test Cases ***
CT10 - Login com credenciais válidas
    [Documentation]    Valida login com e-mail e senha corretos
    ...                Esperado: Status 200 - Token gerado com sucesso
    [Tags]    login    autenticacao    positivo    alta_prioridade
    Realizar Login Com Credenciais Validas

CT11 - Login com senha inválida
    [Documentation]    Valida rejeição de login com senha incorreta
    ...                Esperado: Status 401 - Erro de autenticação
    [Tags]    login    autenticacao    negativo    alta_prioridade
    Tentar Login Com Senha Invalida

CT12 - Login com usuário não cadastrado
    [Documentation]    Valida rejeição de login com e-mail inexistente
    ...                Esperado: Status 401 - Erro de autenticação
    [Tags]    login    autenticacao    negativo    alta_prioridade
    Tentar Login Com Usuario Inexistente

CT13 - Acessar rota protegida com token expirado
    [Documentation]    Valida rejeição de acesso com token expirado/inválido
    ...                Esperado: Status 401 - Erro de token inválido
    [Tags]    login    autenticacao    token    negativo    alta_prioridade
    Tentar Acessar Rota Com Token Invalido

*** Keywords ***
Inicializar Suite De Login
    [Documentation]    Setup inicial para testes de login
    Log To Console     Iniciando testes de Login (US 002)
    Log To Console     Total de cenários: 4 (CT10-CT13)
    Log To Console     API Base: ${base_url}
    Criar Sessao ServeRest
    Criar Usuario Para Login

Finalizar Suite De Login
    [Documentation]    Cleanup após testes de login
    Log To Console     Testes de Login finalizados
*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    DateTime
Resource   ../variables/variables.robot
Resource   ../resources/_base.robot

*** Keywords ***
Realizar Login Com Credenciais Validas
    [Documentation]    Executa e valida login com credenciais válidas (CT10)
    ${response}=    Login Com Credenciais Validas
    Validar Login Bem Sucedido    ${response}
    Logar Token Obtido    ${response}

Tentar Login Com Senha Invalida
    [Documentation]    Executa e valida tentativa de login com senha inválida (CT11)
    ${response}=    Login Com Senha Invalida
    Validar Login Rejeitado    ${response}
    Log To Console    Login com senha inválida rejeitado corretamente

Tentar Login Com Usuario Inexistente
    [Documentation]    Executa e valida tentativa de login com usuário inexistente (CT12)
    ${response}=    Login Com Usuario Nao Cadastrado
    Validar Login Rejeitado    ${response}
    Log To Console    Login com usuário inexistente rejeitado corretamente

Tentar Acessar Rota Com Token Invalido
    [Documentation]    Executa e valida acesso com token inválido (CT13)
    ${response}=    Acessar Rota Protegida Com Token Expirado
    Validar Acesso Negado Por Token    ${response}
    Log To Console    Acesso com token expirado rejeitado corretamente

Validar Login Bem Sucedido
    [Documentation]    Valida resposta de login bem-sucedido
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Contain    ${response.json()['message']}    Login realizado com sucesso
    Dictionary Should Contain Key    ${response.json()}    authorization
    Should Not Be Empty    ${response.json()['authorization']}

Validar Login Rejeitado
    [Documentation]    Valida resposta de login rejeitado
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    401
    Should Contain    ${response.json()['message']}    Email e/ou senha inválidos
    Dictionary Should Not Contain Key    ${response.json()}    authorization

Validar Acesso Negado Por Token
    [Documentation]    Valida resposta de acesso negado por token inválido
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    401
    Should Contain    ${response.json()['message']}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais

Logar Token Obtido
    [Documentation]    Extrai e loga parte do token obtido
    [Arguments]    ${response}
    ${authorization_header}=    Set Variable    ${response.json()['authorization']}
    ${token}=    Replace String    ${authorization_header}    Bearer${SPACE}    ${EMPTY}
    Log To Console    Token obtido: ${token[:20]}...

Criar Usuario Para Login
    [Documentation]    Cria um usuário válido para usar nos testes de login
    ${email_unico}=    Gerar Email Unico
    ${payload}=    Create Dictionary
    ...    nome=${nome_do_usuario}
    ...    email=${email_unico}
    ...    password=${senha_do_usuario}
    ...    administrador=true

    ${response}=    Fazer Requisicao POST    /usuarios    ${payload}
    Should Be Equal As Integers    ${response.status_code}    201

    ${json_response}=    Set Variable    ${response.json()}
    Set Suite Variable    ${EMAIL_TESTE_LOGIN}    ${email_unico}
    Set Suite Variable    ${SENHA_TESTE_LOGIN}    ${senha_do_usuario}
    Set Suite Variable    ${USER_ID_LOGIN}    ${json_response['_id']}

    Log    Usuário criado para testes de login: ${email_unico}
    RETURN    ${response}

Login Com Credenciais Validas
    [Documentation]    Realiza login com credenciais válidas
    ${payload}=    Create Dictionary
    ...    email=${EMAIL_TESTE_LOGIN}
    ...    password=${SENHA_TESTE_LOGIN}

    ${response}=    Fazer Requisicao POST    /login    ${payload}

    # Se login bem-sucedido, extrair e armazenar token
    IF    ${response.status_code} == 200
        ${json_response}=    Set Variable    ${response.json()}
        ${authorization_header}=    Set Variable    ${json_response['authorization']}
        ${token}=    Replace String    ${authorization_header}    Bearer${SPACE}    ${EMPTY}
        Set Suite Variable    ${TOKEN_VALIDO}    ${token}
        Set Suite Variable    ${AUTHORIZATION_HEADER}    ${authorization_header}
        Log    Login realizado com sucesso - Token extraído e armazenado
    END

    RETURN    ${response}

Login Com Senha Invalida
    [Documentation]    Tenta login com senha incorreta
    ${payload}=    Create Dictionary
    ...    email=${EMAIL_TESTE_LOGIN}
    ...    password=senha_incorreta_123

    ${response}=    Fazer Requisicao POST    /login    ${payload}
    RETURN    ${response}

Login Com Usuario Nao Cadastrado
    [Documentation]    Tenta login com email inexistente
    ${payload}=    Create Dictionary
    ...    email=${email_inexistente}
    ...    password=${senha_do_usuario}

    ${response}=    Fazer Requisicao POST    /login    ${payload}
    RETURN    ${response}

Acessar Rota Protegida Com Token Expirado
    [Documentation]    Tenta acessar rota protegida com token inválido
    ${token_invalido}=    Set Variable    token_completamente_invalido_123
    ${headers}=    Criar Headers Com Token    ${token_invalido}

    # Tenta diferentes rotas protegidas até encontrar uma que retorne 401
    ${response}=    Tentar Acesso A Rotas Protegidas    ${headers}
    RETURN    ${response}

Tentar Acesso A Rotas Protegidas
    [Documentation]    Tenta acessar diferentes rotas protegidas com token inválido
    [Arguments]    ${headers}

    # Primeira tentativa: GET /usuarios
    ${response}=    Fazer Requisicao GET    /usuarios    ${headers}
    Log    Tentativa GET /usuarios - Status: ${response.status_code}

    IF    ${response.status_code} != 401
        # Segunda tentativa: POST /produtos
        ${payload_produto}=    Create Dictionary
        ...    nome=Produto Test Token
        ...    preco=100
        ...    descricao=Teste token
        ...    quantidade=10
        ${response}=    Fazer Requisicao POST    /produtos    ${payload_produto}    ${headers}
        Log    Tentativa POST /produtos - Status: ${response.status_code}
    END

    IF    ${response.status_code} != 401
        # Terceira tentativa: DELETE usuário
        ${response}=    Fazer Requisicao DELETE    /usuarios/${USER_ID_LOGIN}    ${headers}
        Log    Tentativa DELETE /usuarios - Status: ${response.status_code}
    END

    RETURN    ${response}

Extrair Token Da Resposta De Login
    [Documentation]    Extrai token da resposta de login (considera formato ServeRest)
    [Arguments]    ${response}
    ${json_response}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json_response}    authorization
    ${authorization_header}=    Set Variable    ${json_response['authorization']}
    ${token}=    Replace String    ${authorization_header}    Bearer${SPACE}    ${EMPTY}
    RETURN    ${token}

Fazer Login E Obter Token
    [Documentation]    Faz login e retorna apenas o token para uso em outros testes
    [Arguments]    ${email}    ${password}
    ${payload}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}

    ${response}=    Fazer Requisicao POST    /login    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    ${token}=    Extrair Token Da Resposta De Login    ${response}
    RETURN    ${token}

Fazer Login E Obter Authorization Header
    [Documentation]    Faz login e retorna o header Authorization completo
    [Arguments]    ${email}    ${password}
    ${payload}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}

    ${response}=    Fazer Requisicao POST    /login    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    ${authorization_header}=    Set Variable    ${response.json()['authorization']}
    RETURN    ${authorization_header}
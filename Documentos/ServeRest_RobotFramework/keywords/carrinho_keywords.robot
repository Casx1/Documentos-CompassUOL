*** Settings ***
Documentation    Keywords para testes de Carrinho
Resource         ../resources/_base.robot

*** Variables ***
${CARRINHO_ENDPOINT}    /carrinhos

*** Keywords ***
# ===============================
# SETUP PRINCIPAL
# ===============================

Criar Usuario E Produto Para Carrinho
    [Documentation]    Cria usuário e produto necessários para os testes

    # Criar e fazer login do admin
    Criar E Logar Usuario Admin

    # Criar produto
    Criar Produto Teste

    # Criar e fazer login do usuário regular
    Criar E Logar Usuario Regular

Criar E Logar Usuario Admin
    [Documentation]    Cria usuário admin e faz login

    # Gerar dados únicos
    ${email_admin}=    Gerar Email Unico
    Set Suite Variable    ${EMAIL_ADMIN}    ${email_admin}

    # Criar usuário admin
    ${dados_admin}=    Create Dictionary
    ...    nome=Admin User
    ...    email=${email_admin}
    ...    password=admin123
    ...    administrador=true

    ${response}=    Fazer Requisicao POST    /usuarios    ${dados_admin}

    # Verificar se usuário já existe
    IF    ${response.status_code} == 400
        ${dados_login}=    Create Dictionary
        ...    email=${email_admin}
        ...    password=admin123
        ${response_login}=    Fazer Requisicao POST    /login    ${dados_login}
        IF    ${response_login.status_code} != 200
            Fail    Falha no login do admin existente: ${response_login.text}
        END
    ELSE IF    ${response.status_code} == 201
        # Fazer login após criação
        ${dados_login}=    Create Dictionary
        ...    email=${email_admin}
        ...    password=admin123
        ${response_login}=    Fazer Requisicao POST    /login    ${dados_login}
        Should Be Equal As Numbers    ${response_login.status_code}    200
    ELSE
        Fail    Falha na criação do usuário admin: ${response.status_code} - ${response.text}
    END

    # Se chegou até aqui, o login foi bem sucedido
    ${token}=    Set Variable    ${response_login.json()['authorization']}
    Set Suite Variable    ${TOKEN_ADMIN}    ${token}

Criar E Logar Usuario Regular
    [Documentation]    Cria usuário regular e faz login

    # Gerar dados únicos
    ${email_regular}=    Gerar Email Unico
    Set Suite Variable    ${EMAIL_REGULAR}    ${email_regular}

    # Criar usuário regular
    ${dados_regular}=    Create Dictionary
    ...    nome=Regular User
    ...    email=${email_regular}
    ...    password=regular123
    ...    administrador=false

    ${response}=    Fazer Requisicao POST    /usuarios    ${dados_regular}

    # Verificar se usuário já existe
    IF    ${response.status_code} == 400
        ${dados_login}=    Create Dictionary
        ...    email=${email_regular}
        ...    password=regular123
        ${response_login}=    Fazer Requisicao POST    /login    ${dados_login}
        IF    ${response_login.status_code} != 200
            Fail    Falha no login do usuário regular existente: ${response_login.text}
        END
    ELSE IF    ${response.status_code} == 201
        ${user_data}=    Set Variable    ${response.json()}
        Set Suite Variable    ${USER_ID_REGULAR}    ${user_data['_id']}

        # Fazer login após criação
        ${dados_login}=    Create Dictionary
        ...    email=${email_regular}
        ...    password=regular123
        ${response_login}=    Fazer Requisicao POST    /login    ${dados_login}
        Should Be Equal As Numbers    ${response_login.status_code}    200
    ELSE
        Fail    Falha na criação do usuário regular: ${response.status_code} - ${response.text}
    END

    # Se chegou até aqui, o login foi bem sucedido
    ${token}=    Set Variable    ${response_login.json()['authorization']}
    Set Suite Variable    ${TOKEN_REGULAR}    ${token}

Criar Produto Teste
    [Documentation]    Cria produto para os testes

    ${nome_produto}=    Gerar Nome Produto Unico

    # Verificar se o token admin existe
    IF    '${TOKEN_ADMIN}' == '${EMPTY}' or '${TOKEN_ADMIN}' == ''
        Fail    Token do admin não foi definido
    END

    ${headers}=    Create Dictionary    Authorization=${TOKEN_ADMIN}

    ${dados_produto}=    Create Dictionary
    ...    nome=${nome_produto}
    ...    preco=100
    ...    descricao=Produto para teste
    ...    quantidade=50

    ${response}=    Fazer Requisicao POST    /produtos    ${dados_produto}    ${headers}

    IF    ${response.status_code} == 201
        ${produto_data}=    Set Variable    ${response.json()}
        Set Suite Variable    ${PRODUTO_ID}    ${produto_data['_id']}
    ELSE
        Fail    Falha na criação do produto: ${response.status_code} - ${response.text}
    END

# ===============================
# TESTES DE CARRINHO
# ===============================

Listar Todos Os Carrinhos Com Sucesso
    [Documentation]    Lista todos os carrinhos
    ${response}=    Fazer Requisicao GET    ${CARRINHO_ENDPOINT}
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.json()}    quantidade
    Should Contain    ${response.json()}    carrinhos

Criar Carrinho Com Produtos Validos
    [Documentation]    Cria carrinho com produtos válidos

    # Limpar carrinho existente
    Remover Carrinho Se Existir

    # Criar carrinho
    ${headers}=    Create Dictionary    Authorization=${TOKEN_REGULAR}
    ${produto_item}=    Create Dictionary
    ...    idProduto=${PRODUTO_ID}
    ...    quantidade=2

    ${produtos}=    Create List    ${produto_item}
    ${dados_carrinho}=    Create Dictionary    produtos=${produtos}

    ${response}=    Fazer Requisicao POST    ${CARRINHO_ENDPOINT}    ${dados_carrinho}    ${headers}

    Should Be Equal As Numbers    ${response.status_code}    201
    Should Contain    ${response.json()}    _id

    Set Suite Variable    ${CARRINHO_ID}    ${response.json()['_id']}

Tentar Criar Carrinho Sem Token
    [Documentation]    Tenta criar carrinho sem token

    ${produto_item}=    Create Dictionary
    ...    idProduto=${PRODUTO_ID}
    ...    quantidade=1

    ${produtos}=    Create List    ${produto_item}
    ${dados_carrinho}=    Create Dictionary    produtos=${produtos}

    ${response}=    Fazer Requisicao POST    ${CARRINHO_ENDPOINT}    ${dados_carrinho}
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Contain    ${response.json()['message']}    Token de acesso obrigatório

Tentar Criar Carrinho Com Produto Inexistente
    [Documentation]    Tenta criar carrinho com produto inexistente

    # Limpar carrinho existente
    Remover Carrinho Se Existir

    ${headers}=    Create Dictionary    Authorization=${TOKEN_REGULAR}
    ${produto_item}=    Create Dictionary
    ...    idProduto=999999999999999999999999
    ...    quantidade=1

    ${produtos}=    Create List    ${produto_item}
    ${dados_carrinho}=    Create Dictionary    produtos=${produtos}

    ${response}=    Fazer Requisicao POST    ${CARRINHO_ENDPOINT}    ${dados_carrinho}    ${headers}
    Should Be Equal As Numbers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Produto não encontrado

Concluir Compra Com Sucesso
    [Documentation]    Conclui compra do carrinho

    # Criar carrinho primeiro
    Criar Carrinho Com Produtos Validos

    ${headers}=    Create Dictionary    Authorization=${TOKEN_REGULAR}
    ${response}=    Fazer Requisicao DELETE    ${CARRINHO_ENDPOINT}/concluir-compra    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.json()['message']}    Registro excluído com sucesso

Cancelar Compra Com Sucesso
    [Documentation]    Cancela compra do carrinho

    # Criar carrinho primeiro
    Criar Carrinho Com Produtos Validos

    ${headers}=    Create Dictionary    Authorization=${TOKEN_REGULAR}
    ${response}=    Fazer Requisicao DELETE    ${CARRINHO_ENDPOINT}/cancelar-compra    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.json()['message']}    Registro excluído com sucesso

# ===============================
# AUXILIARES
# ===============================

Remover Carrinho Se Existir
    [Documentation]    Remove carrinho existente se houver

    ${headers}=    Create Dictionary    Authorization=${TOKEN_REGULAR}

    TRY
        Fazer Requisicao DELETE    ${CARRINHO_ENDPOINT}/cancelar-compra    headers=${headers}
    EXCEPT
        # Nenhum carrinho para remover
        No Operation
    END

Verificar Status Da API
    [Documentation]    Verifica se a API está funcionando
    ${response}=    Fazer Requisicao GET    /usuarios
    IF    ${response.status_code} != 200
        Fail    API não está respondendo corretamente: ${response.status_code}
    END
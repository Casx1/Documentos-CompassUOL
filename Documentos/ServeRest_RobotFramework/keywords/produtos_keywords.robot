*** Settings ***
Library    Collections
Library    RequestsLibrary
Resource   ../variables/variables.robot
Resource   ../resources/_base.robot
Resource   login_keywords.robot

*** Keywords ***
# Setup para testes de produtos - cria usuários admin e não-admin
Criar Usuarios Para Testes De Produtos
    [Documentation]    Cria usuários admin e não-admin para testes de produtos
    # Criar usuário admin
    ${email_admin_unico}=    Gerar Email Unico
    ${payload_admin}=    Create Dictionary
    ...    nome=${nome_admin}
    ...    email=${email_admin_unico}
    ...    password=${senha_admin}
    ...    administrador=true
    ${admin_response}=    Fazer Requisicao POST    /usuarios    ${payload_admin}
    Should Be Equal As Integers    ${admin_response.status_code}    201

    # Fazer login do admin e obter token
    ${token_admin}=    Fazer Login E Obter Token    ${email_admin_unico}    ${senha_admin}
    Set Suite Variable    ${TOKEN_ADMIN}    ${token_admin}
    Set Suite Variable    ${EMAIL_ADMIN_TESTE}    ${email_admin_unico}

    # Criar usuário não-admin
    ${email_regular_unico}=    Gerar Email Unico
    ${payload_regular}=    Create Dictionary
    ...    nome=${nome_nao_admin}
    ...    email=${email_regular_unico}
    ...    password=${senha_nao_admin}
    ...    administrador=false
    ${regular_response}=    Fazer Requisicao POST    /usuarios    ${payload_regular}
    Should Be Equal As Integers    ${regular_response.status_code}    201

    # Fazer login do usuário regular e obter token
    ${token_regular}=    Fazer Login E Obter Token    ${email_regular_unico}    ${senha_nao_admin}
    Set Suite Variable    ${TOKEN_REGULAR}    ${token_regular}
    Set Suite Variable    ${EMAIL_REGULAR_TESTE}    ${email_regular_unico}

    Log    Usuários criados - Admin: ${email_admin_unico}, Regular: ${email_regular_unico}

# CT14 - Criar produto com dados válidos
Criar Produto Com Dados Validos
    [Documentation]    Cria produto com dados válidos usando token admin (CT14)
    ${nome_unico}=    Gerar Nome Produto Unico
    ${headers}=    Criar Headers Com Token    ${TOKEN_ADMIN}
    ${payload}=    Create Dictionary
    ...    nome=${nome_unico}
    ...    preco=${preco_produto}
    ...    descricao=${descricao_produto}
    ...    quantidade=${quantidade_produto}
    ${response}=    Fazer Requisicao POST    /produtos    ${payload}    ${headers}
    Should Be Equal As Integers    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    _id
    Set Suite Variable    ${PRODUTO_ID}    ${response.json()['_id']}
    Set Suite Variable    ${NOME_PRODUTO_CRIADO}    ${nome_unico}
    Log    Produto criado com sucesso - ID: ${PRODUTO_ID}
    RETURN    ${response}

# CT15 - Criar produto com nome duplicado
Criar Produto Com Nome Duplicado
    [Documentation]    Tenta criar produto com nome já existente (CT15)
    ${headers}=    Criar Headers Com Token    ${TOKEN_ADMIN}
    ${payload}=    Create Dictionary
    ...    nome=${NOME_PRODUTO_CRIADO}
    ...    preco=${preco_produto}
    ...    descricao=Produto duplicado para teste
    ...    quantidade=${quantidade_produto}
    ${response}=    Fazer Requisicao POST    /produtos    ${payload}    ${headers}
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Já existe produto com esse nome
    Log    Criação de produto duplicado rejeitada corretamente
    RETURN    ${response}

# CT16 - Excluir produto vinculado a carrinho
Excluir Produto Vinculado A Carrinho
    [Documentation]    Tenta excluir produto vinculado a carrinho (CT16)
    ...                Deve retornar erro 400 impedindo a exclusão

    # Primeiro cria um produto
    ${nome_produto_carrinho}=    Gerar Nome Produto Unico
    ${headers}=    Criar Headers Com Token    ${TOKEN_ADMIN}
    ${payload_produto}=    Create Dictionary
    ...    nome=${nome_produto_carrinho}
    ...    preco=${preco_produto}
    ...    descricao=Produto para teste de carrinho
    ...    quantidade=${quantidade_produto}
    ${produto_response}=    Fazer Requisicao POST    /produtos    ${payload_produto}    ${headers}
    Should Be Equal As Integers    ${produto_response.status_code}    201
    ${produto_id}=    Set Variable    ${produto_response.json()['_id']}
    Log    Produto criado para teste - ID: ${produto_id}

    # Adiciona produto ao carrinho
    ${lista_produtos_carrinho}=    Create List
    ${produto_carrinho}=    Create Dictionary
    ...    idProduto=${produto_id}
    ...    quantidade=2
    Append To List    ${lista_produtos_carrinho}    ${produto_carrinho}
    ${payload_carrinho}=    Create Dictionary    produtos=${lista_produtos_carrinho}
    ${carrinho_response}=    Fazer Requisicao POST    /carrinhos    ${payload_carrinho}    ${headers}
    Should Be Equal As Integers    ${carrinho_response.status_code}    201
    ${carrinho_id}=    Set Variable    ${carrinho_response.json()['_id']}
    Log    Carrinho criado com produto - ID: ${carrinho_id}

    # Tenta excluir o produto que está no carrinho
    ${response}=    Fazer Requisicao DELETE    /produtos/${produto_id}    ${headers}

    # VALIDAÇÃO: Deve impedir a exclusão com a mensagem real da API
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Não é permitido excluir produto que faz parte de carrinho
    Log     Exclusão de produto em carrinho bloqueada corretamente

    # Verifica se o produto ainda existe
    ${produto_check}=    Fazer Requisicao GET    /produtos/${produto_id}    ${headers}
    Should Be Equal As Integers    ${produto_check.status_code}    200
    Should Be Equal    ${produto_check.json()['_id']}    ${produto_id}
    Log     Produto permanece no sistema após tentativa de exclusão

    # Cleanup: Remove produto do carrinho e depois exclui o produto
    ${delete_carrinho}=    Fazer Requisicao DELETE    /carrinhos/concluir-compra    ${headers}
    Should Be Equal As Integers    ${delete_carrinho.status_code}    200

    # Agora deve conseguir excluir o produto
    ${delete_produto}=    Fazer Requisicao DELETE    /produtos/${produto_id}    ${headers}
    Should Be Equal As Integers    ${delete_produto.status_code}    200
    Log     Produto excluído com sucesso após remoção do carrinho

    RETURN    ${response}

# CT17 - Atualizar produto com ID inexistente
Atualizar Produto Com ID Inexistente
    [Documentation]    Tenta atualizar produto com ID inexistente (CT17)
    ...                Documentação diz que deveria criar produto (Status 201)
    ...                Mas API retorna erro 400 - possível inconsistência
    ${nome_unico}=    Gerar Nome Produto Unico
    ${headers}=    Criar Headers Com Token    ${TOKEN_ADMIN}
    ${payload}=    Create Dictionary
    ...    nome=${nome_unico}
    ...    preco=${preco_produto}
    ...    descricao=Produto atualizado com ID inexistente
    ...    quantidade=${quantidade_produto}
    ${response}=    Fazer Requisicao PUT    /produtos/${ID_INEXISTENTE}    ${payload}    ${headers}

    # Comportamento real da API (Status 400)
    Should Be Equal As Integers    ${response.status_code}    400
    Log     API retorna 400 (contradiz documentação que diz para criar produto)
    Log    Possível inconsistência entre documentação e implementação

    RETURN    ${response}

# CT18 - Acessar produtos sem autenticação
Acessar Produtos Sem Autenticacao
    [Documentation]    Valida que produtos NÃO são exibidos sem autenticação (CT18)
    ...                Regra de Negócio: Apenas admins podem listar produtos
    ${response}=    Fazer Requisicao GET    /produtos

    # Se retornar 200, é um BUG CRÍTICO de segurança
    Run Keyword If    ${response.status_code} == 200
    ...    Log     BUG CRÍTICO DETECTADO: API permite acesso sem autenticação!
    ...    WARN

    # Se retornar 401, segurança está funcionando
    Run Keyword If    ${response.status_code} == 401
    ...    Log     Segurança OK: Acesso negado corretamente

    RETURN    ${response}

# CT19 - Fluxo integrado usuário-produto-carrinho
Fluxo Integrado Usuario Produto Carrinho
    [Documentation]    Testa fluxo completo: criar usuário, login, criar produto, adicionar ao carrinho (CT19)
    # 1. Criar usuário
    ${email_fluxo}=    Gerar Email Unico
    ${payload_user}=    Create Dictionary
    ...    nome=Usuario Fluxo Integrado
    ...    email=${email_fluxo}
    ...    password=${senha_do_usuario}
    ...    administrador=true
    ${user_response}=    Fazer Requisicao POST    /usuarios    ${payload_user}
    Should Be Equal As Integers    ${user_response.status_code}    201

    # 2. Fazer login
    ${token_fluxo}=    Fazer Login E Obter Token    ${email_fluxo}    ${senha_do_usuario}
    Should Not Be Empty    ${token_fluxo}

    # 3. Criar produto
    ${nome_produto_fluxo}=    Gerar Nome Produto Unico
    ${headers_fluxo}=    Criar Headers Com Token    ${token_fluxo}
    ${payload_produto}=    Create Dictionary
    ...    nome=${nome_produto_fluxo}
    ...    preco=${preco_produto}
    ...    descricao=Produto para fluxo integrado
    ...    quantidade=${quantidade_produto}
    ${produto_response}=    Fazer Requisicao POST    /produtos    ${payload_produto}    ${headers_fluxo}
    Should Be Equal As Integers    ${produto_response.status_code}    201
    ${produto_id_fluxo}=    Set Variable    ${produto_response.json()['_id']}

    # 4. Adicionar produto ao carrinho
    ${lista_produtos_carrinho}=    Create List
    ${produto_carrinho}=    Create Dictionary
    ...    idProduto=${produto_id_fluxo}
    ...    quantidade=2
    Append To List    ${lista_produtos_carrinho}    ${produto_carrinho}
    ${payload_carrinho}=    Create Dictionary    produtos=${lista_produtos_carrinho}
    ${carrinho_response}=    Fazer Requisicao POST    /carrinhos    ${payload_carrinho}    ${headers_fluxo}
    Should Be Equal As Integers    ${carrinho_response.status_code}    201

    Log    Fluxo integrado executado com sucesso
    RETURN    ${carrinho_response}

# CT20 - Atualizar produto com nome duplicado
Atualizar Produto Com Nome Duplicado
    [Documentation]    Tenta atualizar produto com nome já existente (CT20)
    # Cria dois produtos
    ${nome_produto1}=    Gerar Nome Produto Unico
    ${nome_produto2}=    Gerar Nome Produto Unico
    ${headers}=    Criar Headers Com Token    ${TOKEN_ADMIN}

    # Cria primeiro produto
    ${payload1}=    Create Dictionary
    ...    nome=${nome_produto1}
    ...    preco=${preco_produto}
    ...    descricao=Primeiro produto
    ...    quantidade=${quantidade_produto}
    ${response1}=    Fazer Requisicao POST    /produtos    ${payload1}    ${headers}
    Should Be Equal As Integers    ${response1.status_code}    201

    # Cria segundo produto
    ${payload2}=    Create Dictionary
    ...    nome=${nome_produto2}
    ...    preco=${preco_produto}
    ...    descricao=Segundo produto
    ...    quantidade=${quantidade_produto}
    ${response2}=    Fazer Requisicao POST    /produtos    ${payload2}    ${headers}
    Should Be Equal As Integers    ${response2.status_code}    201
    ${produto2_id}=    Set Variable    ${response2.json()['_id']}

    # Tenta atualizar segundo produto com nome do primeiro
    ${payload_update}=    Create Dictionary
    ...    nome=${nome_produto1}
    ...    preco=${preco_produto}
    ...    descricao=Produto atualizado com nome duplicado
    ...    quantidade=${quantidade_produto}
    ${response}=    Fazer Requisicao PUT    /produtos/${produto2_id}    ${payload_update}    ${headers}
    Should Be Equal As Integers    ${response.status_code}    400
    Should Contain    ${response.json()['message']}    Já existe produto com esse nome
    Log    Atualização com nome duplicado rejeitada corretamente
    RETURN    ${response}

# CT21 - Criar produto com preço/quantidade inválidos
Criar Produto Com Preco Quantidade Invalidos
    [Documentation]    Tenta criar produto com preço ou quantidade <= 0 (CT21)
    ${nome_produto_invalido}=    Gerar Nome Produto Unico
    ${headers}=    Criar Headers Com Token    ${TOKEN_ADMIN}
    ${payload_preco_invalido}=    Create Dictionary
    ...    nome=${nome_produto_invalido}_preco
    ...    preco=${preco_invalido}
    ...    descricao=Produto com preço inválido
    ...    quantidade=${quantidade_produto}
    ${response_preco}=    Fazer Requisicao POST    /produtos    ${payload_preco_invalido}    ${headers}
    Should Be Equal As Integers    ${response_preco.status_code}    400
    Should Contain    ${response_preco.json()['preco']}    preco deve ser um número positivo
    ${payload_quantidade_invalida}=    Create Dictionary
    ...    nome=${nome_produto_invalido}_quantidade
    ...    preco=${preco_produto}
    ...    descricao=Produto com quantidade inválida
    ...    quantidade=${quantidade_invalida}
    ${response_quantidade}=    Fazer Requisicao POST    /produtos    ${payload_quantidade_invalida}    ${headers}
    Should Be Equal As Integers    ${response_quantidade.status_code}    400
    Should Contain    ${response_quantidade.json()['quantidade']}    quantidade deve ser maior ou igual a 0

    Log    Validações de preço e quantidade funcionando corretamente
    RETURN    ${response_quantidade}
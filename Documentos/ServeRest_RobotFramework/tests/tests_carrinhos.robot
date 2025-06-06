*** Settings ***
Documentation    Testes de Carrinho
Resource         ../resources/_base.robot
Resource         ../keywords/carrinho_keywords.robot
Suite Setup      Setup Carrinho
Suite Teardown   Teardown Carrinho

*** Test Cases ***
CT22 - Listar todos os carrinhos
    [Documentation]    Lista todos os carrinhos cadastrados
    [Tags]    carrinho    listagem    positivo
    Listar Todos Os Carrinhos Com Sucesso

CT23 - Criar carrinho com produtos válidos
    [Documentation]    Cria carrinho com produtos válidos
    [Tags]    carrinho    criacao    positivo
    Criar Carrinho Com Produtos Validos

CT24 - Criar carrinho sem token de autorização
    [Documentation]    Tenta criar carrinho sem token
    [Tags]    carrinho    criacao    negativo
    Tentar Criar Carrinho Sem Token

CT25 - Criar carrinho com produto inexistente
    [Documentation]    Tenta criar carrinho com produto inexistente
    [Tags]    carrinho    criacao    negativo
    Tentar Criar Carrinho Com Produto Inexistente

CT26 - Concluir compra do carrinho
    [Documentation]    Conclui compra do carrinho
    [Tags]    carrinho    compra    positivo
    Concluir Compra Com Sucesso

CT27 - Cancelar compra do carrinho
    [Documentation]    Cancela compra do carrinho
    [Tags]    carrinho    cancelamento    positivo
    Cancelar Compra Com Sucesso

*** Keywords ***
Setup Carrinho
    [Documentation]    Inicializa testes de carrinho

    TRY
        Criar Sessao ServeRest
        Criar Usuario E Produto Para Carrinho

    EXCEPT    Exception    AS    ${error}
        Log To Console     Erro no setup: ${error}
        Log    Detalhes do erro no setup: ${error}
        Fail    Setup falhou: ${error}
    END

Teardown Carrinho
    [Documentation]    Finaliza testes de carrinho
    TRY
        Remover Carrinho Se Existir
    EXCEPT    Exception    AS    ${error}
        Log To Console    Aviso na limpeza: ${error}
        Log    Cleanup teve problemas (não crítico): ${error}
    END
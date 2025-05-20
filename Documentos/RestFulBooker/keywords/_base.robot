*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Variables ***
${BASE_URL}    https://restful-booker.herokuapp.com
${USERNAME}    admin
${PASSWORD}    password123

*** Keywords ***
Criando sessao e obtendo token
    # Criando uma sessão na api
    Create Session    BookerAPI    ${BASE_URL}
    # Definindo o body da request
    ${body}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    # Enviando post para autenticar e salvando na variavel ${response}. Indicando o endpoint /auth
    ${response}=    Post On Session    BookerAPI    /auth    json=${body}
    # Verificando o retorno de status e validando se é igual a 200
    Should Be Equal As Integers    ${response.status_code}    200
    # Verifica se retorno da request traz a chave token (não precisa atribuir)
    Dictionary Should Contain Key    ${response.json()}    token
    # Obtendo a chave token e salvando dentro da variavel ${token}
    ${token}=    Get From Dictionary    ${response.json()}    token
    # Obtendo e salvando status na variavel ${status}
    ${status}=    Set Variable    ${response.status_code}
    # Retornando variavel ${status} e ${token}
    RETURN    ${status}    ${token}
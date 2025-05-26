*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../keywords/Auth.robot

*** Test Cases ***
Sessão autenticada com atatus HTTP 200
    Printando retorno do status

Token de cesso Gerado com Sucesso
    Printando retorno do token

*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../keywords/Auth.robot
Resource    ../keywords/GetBookingIds.robot
Resource    ../keywords/GetBooking.robot
Resource    ../keywords/CreateBooking.robot
Resource    ../keywords/UpdateBooking.robot
Resource    ../keywords/PartialUpdateBooking.robot
Resource    ../keywords/DeleteBooking.robot
Resource    ../keywords/Ping.robot

*** Test Cases ***
Sessão autenticada com atatus HTTP 200
    Printando retorno do status
Token de cesso Gerado com Sucesso
    Printando retorno do token
Listando bookings
    GET GetBookingIds
Buscando bookings por ID
    ${booking_id}=    Set Variable    1
    ${booking_data}=    GET GetBooking    ${booking_id}
    Should Not Be Equal    ${booking_data}    ${None}    Falha ao obter dados da reserva

Criando booking
    POST CreateBooking
Atualizando booking existente
    ${booking_id}=    POST CreateBooking
    PUT UpdateBooking    ${booking_id}
Atualização parcial de booking
    ${booking_id}=    POST CreateBooking
    PATCH PartialUpdateBooking    ${booking_id}
Deletar booking
    ${booking_id}=    POST CreateBooking
    DEL DeleteBooking    ${booking_id}
Ping status do server
    PING PingHealtCheck


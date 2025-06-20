*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../keywords/GetBookingIds.robot
Resource    ../keywords/GetBooking.robot
Resource    ../keywords/CreateBooking.robot
Resource    ../keywords/UpdateBooking.robot
Resource    ../keywords/PartialUpdateBooking.robot
Resource    ../keywords/DeleteBooking.robot

*** Test Cases ***
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

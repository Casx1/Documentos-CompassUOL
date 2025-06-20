*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Keywords ***
POST CreateBooking
    [Documentation]    Creates a new booking in the Restful Booker API.
    ...    Returns the booking ID if successful.
    ...    Requires an authenticated session to be created first.
    [Arguments]    ${firstname}=John    ${lastname}=Doe    ${totalprice}=110
    ...    ${depositpaid}=${True}    ${checkin}=2018-01-01
    ...    ${checkout}=2019-01-01    ${additionalneeds}=Breakfast

    # Ensure we have an authenticated session
    Criando sessao e obtendo token

    # Prepare request data
    ${bookingdates}=    Create Dictionary
    ...    checkin=${checkin}
    ...    checkout=${checkout}

    ${payload}=    Create Dictionary
    ...    firstname=${firstname}
    ...    lastname=${lastname}
    ...    totalprice=${totalprice}
    ...    depositpaid=${depositpaid}
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=${additionalneeds}

    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json

    # Send request and handle response
    TRY
        ${response}=    Post On Session
        ...    BookerAPI
        ...    /booking
        ...    headers=${headers}
        ...    json=${payload}

        IF    ${response.status_code} == 200
            ${booking_id}=    Get From Dictionary    ${response.json()}    bookingid
            RETURN    ${booking_id}
        ELSE
            Log To Console    >>> Falha ao criar booking. Status code: ${response.status_code}
            Log To Console    >>> Response body: ${response.text}
            FAIL    Criação de booking falhou com status code: ${response.status_code}
        END
    EXCEPT    AS    ${error}
        Log To Console    >>> Erro durante processo de criação do booking: ${error}
        FAIL    Falha ao criar o booking devido ao erro: ${error}
    END

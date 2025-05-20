*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Keywords ***
POST CreateBooking
    Criando sessao e obtendo token
    ${bookingdates}=    Create Dictionary    checkin=2018-01-01    checkout=2019-01-01
    ${payload}=    Create Dictionary
    ...    firstname=John
    ...    lastname=Doe
    ...    totalprice=110
    ...    depositpaid=${True}
    ...    bookingdates=${bookingdates}
    ...    additionalneeds=Breakfast
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${response}=    Post On Session
    ...    BookerAPI
    ...    /booking
    ...    headers=${headers}
    ...    json=${payload}
    IF    ${response.status_code}==200
        Log To Console    >>> ${response.status_code}
        ELSE
            Log To Console    >>> Falha ao criar booking.
        END

    ${booking_id}=    Get From Dictionary    ${response.json()}    bookingid
    RETURN    ${booking_id}

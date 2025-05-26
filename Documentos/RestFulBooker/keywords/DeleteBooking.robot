*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../_base.robot

*** Keywords ***
DEL DeleteBooking
    [Documentation]    Deletes a booking using the provided booking ID.
    ...    Returns the response status code.
    [Arguments]    ${booking_id}

    # Get authentication token
    ${auth_status}    ${auth_token}=    Criando sessao e obtendo token

    # Prepare request headers
    ${headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Cookie=token=${auth_token}

    # Create session and send DELETE request
    Create Session    BookerAPI    ${BASE_URL}
    ${response}=    Delete On Session
    ...    BookerAPI
    ...    /booking/${booking_id}
    ...    headers=${headers}
    ...    expected_status=any

    # Validate response
    Should Be Equal As Integers    ${response.status_code}    201

    # Log and return status code for potential reuse
    Log To Console    ${EMPTY}
    Log To Console    >>> Booking deletado com sucesso. Status: ${response.status_code}
    Log    ${response.status_code}
    RETURN    ${response.status_code}
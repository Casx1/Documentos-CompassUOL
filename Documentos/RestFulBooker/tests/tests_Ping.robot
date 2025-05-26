*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    ../keywords/Ping.robot

*** Test Cases ***
Ping status do server
    PING PingHealtCheck

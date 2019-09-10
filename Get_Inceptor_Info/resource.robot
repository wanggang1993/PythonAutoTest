*** Settings ***
Library  RequestsLibrary
Library  String
Library  Collections
Variables  ../variable.py


*** Keywords ***

Login

  ${header}  create dictionary  Content-Type=text/plain; charset=UTF-8
  ${post_data}  create dictionary    userName=${USERNAME}    userPassword=${PASSWORD}
  ${jsondata}    json.Dumps    ${post_data}
#  ${cookie}     create dictionary  accessToken=${AccessToken}
  create session    manager    ${MANAGER}    headers=${header}
  ${resp}   post request   manager   /api/users/login    data=${jsondata}   #Cookie=${cookie}
  log to console     ${resp.text}
  should be equal    ${resp.status_code}   ${200}
  log to console  LOGIN SUCCESS
  [Return]  ${resp}



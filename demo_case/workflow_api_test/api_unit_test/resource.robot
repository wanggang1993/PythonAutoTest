*** Settings ***
Library  RequestsLibrary
Library  String
Library  Collections
Variables  ../variables.py




*** Keywords ***


Login
   ${header}=  create dictionary    Content-Type=application/json
#   #${post_data}=  create dictionary   password=${PASSWORD}   username=${USERNAME}
   create session  workflow  ${WORKFLOW}  headers=${header}
#   #${resp}=   post request   workflow    /api/v1/login   data=${post_data}
#   #log to console  ${resp.cookies}
#   #should be equal   ${resp.status_code}    ${200}
#   #log to console   LOGIN SUCCESS
#   #[Return]  ${resp}
Login_unsafe
   ${header}=  create dictionary    Content-Type=application/json
   ${post_data}=  create dictionary   password=${PASSWORD}   username=${USERNAME}
   create session  workflow  ${WORKFLOW}  headers=${header}
   ${resp}=   post request   workflow    /api/v1/login   data=${post_data}
   #log to console  ${resp.cookies}
   should be equal   ${resp.status_code}    ${200}
   log to console   LOGIN SUCCESS
   [Return]  ${resp}


Verify StatusCode
    [Arguments]   ${status_code}      ${expected}
    should be equal   ${status_code}   ${expected}
    log to console   ${status_code}


GET Value From Dic
    [Arguments]    ${string}     ${key}
    ${json}=  to json  ${string}
    #log to console   ${json}
    ${value}=  get from dictionary     ${json}   ${key}
    [Return]   ${value}



Prepare GuardianParams
    ${params}=  create dictionary  guardian_access_token=${guardian_access_token}
    [Return]   ${params}

Get Guardian_Token
    [Return]  ${guardian_access_token}

Get JDBC
    ${result}=  catenate   SEPARATOR=  ${JDBC}    guardianToken=   ${guardian_access_token}
    [Return]   ${result}
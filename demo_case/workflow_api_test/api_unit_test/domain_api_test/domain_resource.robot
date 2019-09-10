*** Settings ***
Documentation    workspace api keyword
Library  RequestsLibrary
Library   Collections
Resource   ../resource.robot




*** Keywords ***
Create Domain
    [Arguments]     ${domain_name}
    log to console    ----------create domaim--------------
    ${data}=   create dictionary    name=${domain_name}   desc=${domain_name}
    ${guardian_params}=  Prepare GuardianParams
    ${resp}=   put request    workflow   api/v1/domains  data=${data}   params=${guardian_params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    #should be equal   ${resp.status_code}   ${200}
    #log to console   ${resp.status_code}
    ${domain_id}=   Run Keyword If   ${resp.status_code}==${200}   GET Value From Dic  ${resp.content}  id
     ...             ELSE       SET VARIABLE   ${-1}
    #log to console   domain_id=${domain_id}
    ${result}=   create dictionary    status_code=${resp.status_code}   domain_id=${domain_id}
    log to console  ${result}
    [Return]  ${result}



Get Domain
    [Arguments]  ${domain_id}
    log to console    ----------get domain--------------
    ${params}=    create dictionary   id=${domain_id}
    ${guardian_params}=  Prepare GuardianParams
    ${resp}=    get request   workflow    /api/v1/domain/${domain_id}     params=${params}   params=${guardian_params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    #should be equal   ${resp.status_code}    ${200}
    log to console   ${resp.status_code}
    [Return]  ${resp}


Update Domain
    [Arguments]  ${domain_id}   ${name}
    log to console    ----------update domain--------------
    ${data}=  create dictionary   id=${domain_id}    name=${name}
    ${guardian_params}=  Prepare GuardianParams
    ${resp}=  post request   workflow   /api/v1/domain/${domain_id}   data=${data}   params=${guardian_params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    #should be equal   ${resp.status_code}    ${200}
    log to console   ${resp.status_code}
    [Return]   ${resp.status_code}


Remove Domain
    [Arguments]  ${domain_id}
    log to console    ----------remove domain--------------
    ${data}=   create dictionary    id=${domain_id}
    ${guardian_params}=  Prepare GuardianParams
    ${resp}=   delete request   workflow    /api/v1/domain/${domain_id}   params=${data}  params=${guardian_params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    #should be equal    ${resp.status_code}    ${200}
    log to console  ${resp.status_code}
    [Return]   ${resp.status_code}

Get Domains
    [Arguments]   ${name_pattern}    ${require_perm}=false
    log to console  ------------get domains fit namepattern----
    ${guardian_params}=  Get Guardian_Token
    ${params}=  create dictionary   namePattern=${name_pattern}  requirePerm=${require_perm}   guardian_access_token=${guardian_params}
    ${resp}=   get request  workflow   /api/v1/domains    params=${params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    log to console  ${resp.status_code}
    [Return]   ${resp}

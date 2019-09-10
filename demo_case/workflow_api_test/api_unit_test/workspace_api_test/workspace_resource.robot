*** Settings ***
Documentation    workspace api keyword
Library  RequestsLibrary
Library   Collections
Resource   ../resource.robot

*** Keywords ***
Create Workspace
    [Arguments]   ${workspace_name}    ${domain_id}
    log to console    ----------create workspace--------------
    ${data}=   create dictionary  desc=${workspace_name}  name=${workspace_name}   domainId=${domain_id}
    ${guardian_params}=  Prepare GuardianParams
    ${resp}=   put request   workflow     /api/v1/workspaces   data=${data}   params=${guardian_params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    ${workspace_id}=   Run Keyword If   ${resp.status_code}==${200}   GET Value From Dic  ${resp.content}  id
     ...             ELSE       SET VARIABLE   ${-1}
    ${result}=   create dictionary    status_code=${resp.status_code}   workspace_id=${workspace_id}
    log to console  ${result}
    [Return]  ${result}



Get Workspace
    #[Arguments]  ${workspace_id}
    [Arguments]  ${workspace_id}  ${perm_check}=${false}
    log to console    ----------get workspace--------------
    ${guardian_params}=  Get Guardian_Token
    #${params}=    create dictionary   id=${workspace_id}   guardian_access_token=${guardian_params}
    ${params}=    create dictionary   guardian_access_token=${guardian_params}
    #${guardian_params}=  Prepare GuardianParams
    Run Keyword If  ${perm_check}!=${false}  set to dictionary  ${params}  requirePermCheck=${perm_check}
    ${resp}=    get request   workflow    /api/v1/workspace/${workspace_id}     params=${params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    log to console   ${resp.status_code}
    #log to console   ${resp}
    [Return]  ${resp}


Update Workspace
    [Arguments]  ${domain_id}  ${workspace_id}  ${new_name}
    log to console    ----------update workspace--------------
    ${data}=  create dictionary   id=${workspace_id}    name=${new_name}   domainId=${domain_id}
    ${guardian_params}=  Prepare GuardianParams
    ${resp}=  post request   workflow   /api/v1/workspace/${workspace_id}   data=${data}   params=${guardian_params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    log to console     ${resp.status_code}
    [Return]  ${resp.status_code}


Remove Workspace
    [Arguments]  ${workspace_id}
    log to console    ----------remove workspace--------------
    ${params}=   create dictionary    id=${workspace_id}
    ${guardian_params}=  Prepare GuardianParams
    ${resp}=   delete request   workflow    /api/v1/workspace/${workspace_id}     params=${guardian_params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    log to console    ${resp.status_code}
    [Return]   ${resp.status_code}



Get Workspaces
    [Arguments]   ${domain_id}  ${name_pattern}  ${require_perm}=False
    log to console  -------get workspaces fit domian&namepattern------
    ${guardian_params}=  Get Guardian_Token
    ${params}=   create dictionary   namePattern=${name_pattern}   domainId=${domain_id}  requirePerm=${require_perm}  guardian_access_token=${guardian_params}
    log to console  ${params}
    #${guardian_params}=  Prepare GuardianParams
    ${resp}=   get request   workflow   /api/v1/workspaces   params=${params}
    Run Keyword If    ${resp.status_code}!=${200}   log to console  ${resp.text}
    [Return]   ${resp}

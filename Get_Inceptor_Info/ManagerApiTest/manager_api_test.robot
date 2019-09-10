*** Settings ***
Library  RequestsLibrary
Library  String
Library  Collections
Library  json
Resource  ../resource.robot
Variables  ../variable.py

Suite Setup   Login

*** Test Cases ***

Test_Services
  ${header}     create dictionary  Content-Type=text/plain; charset=UTF-8
  ${post_data}  create dictionary    clusterId=${1}   type=${TYPE}   version=${VERSION}
  ${list_post_data}  create list    ${post_data}
  ${jsondata}     json.dumps    ${list_post_data}
#  create session    manager    ${MANAGER}    headers=${header}   #Cookie=${cookie}
  ${resp}      post request   manager    /api/services   data=${jsondata}
  log to console    ${resp.text}
  should be equal   ${resp.status_code}  ${201}
#  log to console    ADD SERVICE SUCCESSFUL
#   ${jsonresp}    to json   ${resp.text}
#   log to console  ${jsonresp}
#  :for   ${element}  in   ${jsonresp}
#    \     log   ${element}
#  log to console       ${element}
  ${inceptor_service_id}   set variable   ${resp.json()[0]['id']}
  ${sid}   set variable   ${resp.json()[0]['sid']}
  log to console      Inceptor_Service_Id:${inceptor_service_id}
  set suite variable   ${inceptor_service_id}
  set suite variable    ${sid}



Test_ServiceRoles
  ${header}     create dictionary  Content-Type=text/plain; charset=UTF-8
#   ${nodeid}    create list     1      3
#   :for   ${element} in  ${nodeid}
#    \       log       ${element}
  log to console   ------Incpotor_Merastore-------
  ${post_data_1}  create dictionary   nodeId   ${1}    serviceId    ${inceptor_service_id}      roleType   ${RoleType1}
  ${list_post_data_1}  create list    ${post_data_1}
  ${jsondata_1}    json.Dumps      ${list_post_data_1}
  ${resp_1}    post request   manager    /api/serviceRoles     ${jsondata_1}
  log to console   ${resp_1.text}
  should be equal  ${resp_1.status_code}      ${201}


  ${post_data_2}  create dictionary   nodeId   ${3}    serviceId    ${inceptor_service_id}      roleType   ${RoleType1}
  ${list_post_data_2}  create list    ${post_data_2}
  ${jsondata_2}    json.Dumps      ${list_post_data_2}
  ${resp_2}    post request   manager    /api/serviceRoles     ${jsondata_2}
#  log to console  ${resp_2.text}
  should be equal  ${resp_2.status_code}      ${201}
  log to console  Inceptor_metastore Pass



  log to console   ------Incpotor_Server-------
  ${post_data_3}  create dictionary   nodeId   ${1}    serviceId    ${inceptor_service_id}      roleType   ${RoleType2}
  ${list_post_data_3}  create list    ${post_data_3}
  ${jsondata_3}    json.Dumps      ${list_post_data_3}
#  log to console  ${jsondata3}
  ${resp_3}    post request   manager    /api/serviceRoles     ${jsondata_3}#
  log to console  ${resp_3.text}
  should be equal  ${resp_3.status_code}      ${201}
  log to console  Inceptor_Server Pass
  log to console   SET ROLES SUCCESSFUL


#  log to console   ------Incpotor_Executor-------
#  ${post_data_4}  create dictionary   nodeId   ${1}    serviceId    ${inceptor_service_id}      roleType   ${RoleType3}
#  ${list_post_data_4}   create list    ${post_data_4}
#  ${jsondata_4}    json.Dumps       ${list_post_data_4}
#  log to console   请求参数：${jsondata4}
#  ${resp_4}    post request   manager    /api/serviceRoles     ${jsondata_4}
#  log to console   ${resp_4.text}
#
#  ${post_data_5}  create dictionary   nodeId   ${2}    serviceId    ${inceptor_service_id}      roleType   ${RoleType3}
#  ${list_post_data_5}  create list    ${post_data_5}
#  ${jsondata_5}    json.Dumps       ${list_post_data_5}
#  log to console    请求参数：${jsondata5}
#  ${resp_5}    post request   manager    /api/serviceRoles     ${jsondata_5}
#  log to console   ${resp_5.text}
#
#
#  ${post_data_6}  create dictionary   nodeId   ${3}    serviceId    ${inceptor_service_id}      roleType   ${RoleType3}
#  ${list_post_data_6}  create list    ${post_data_6}
#  ${jsondata_6}    json.Dumps      ${list_post_data_6}
#  log to console   请求参数：${jsondata6}
#  ${resp_6}    post request   manager    /api/serviceRoles     ${jsondata_6}
#  log to console   ${resp_6.text}


#  should be equal  ${resp_4.status_code}      ${201}
#  should be equal  ${resp_5.status_code}      ${201}
#  should be equal  ${resp_6.status_code}      ${201}




Test_Give_Service_Security
  ${header}     create dictionary  Content-Type=text/plain; charset=UTF-8
  ${post_data}  create dictionary  userName    ${KAdmin}  password  ${123}  pluginEnabled  ${true}
  ${jsondata}    json.Dumps      ${post_data}
 # log to console  ${jsondata}
  ${resp}    post request   manager   /api/services/${inceptor_service_id}/enableKerberos    ${jsondata}
 #  log to console   ${resp}
  should be equal  ${resp.status_code}      ${200}
  log to console   GIVE SECURITY SUCCESSFUL


Get_Config_INFO
  ${header}     create dictionary  Content-Type=text/plain; charset=UTF-8
  ${resp}       get request  manager    /api/services/${inceptor_service_id}/configs/firstWizard
  should be equal   ${resp.status_code}    ${200}
#  log to console  ${resp.text}
  ${r_list}    set variable     ${resp.json()}
  ${result}    create list
   :FOR    ${server_config}    in     @{r_list}
#   \     log to console        ${server_config}
   \   remove from dictionary     ${server_config}     recommendedValue     isSupportMultiInstances     description     configFile  values  visibility
#   \     log to console        ${server_config}
   \     append to list     ${result}    ${server_config}
#    run keyword if   ${server_config.isSupportMultiInstances}==null
     log to console     ${result}
     set suite variable      ${result}
#  log to console    Get Config Info SUCCESSFUL








Test_Dispose_Service
  ${header}      create dictionary  Content-Type=text/plain; charset=UTF-8
  ${post_data}  create dictionary  name   ${sid}     configs     ${result}
  ${jsondata}    json.dumps    ${post_data}
  log to console        ${jsondata}
  ${resp}       put request   manager     /api/services/${inceptor_service_id}     ${jsondata}
  log to console    ${resp.text}
  should be equal   ${resp.status_code}    ${200}
  log to console    DISPOSE SERVICE SUCCESSFUL



Test_Deploy_Service
  ${header}     create dictionary  Content-Type=text/plain; charset=UTF-8
  ${post_data}  create list      ${inceptor_service_id}
  ${jsondata}   json.dumps     ${post_data}
  ${resp}        post request   manager     /api/services/operations/init    ${jsondata}
  should be equal   ${resp.status_code}    ${202}
  log to console    DEPLOY SERVICE SUCCESSFUL
   sleep    300


Test_Get_Service_Info
  ${header}     create dictionary  Content-Type=text/plain; charset=UTF-8
#  ${post_data}  create dictionary  ... ${...} ... ${...}
  ${resp}       get request    manager         /api/services
#  LOG TO CONSOLE  ${resp.text}
  should be equal   ${resp.status_code}   ${200}
#  log to console  ${resp.json()}
#  ${name}    get from dictionary  ${resp.json()[17]}   name
#  log to console  ${name}
#
  :FOR    ${dic}   in   @{resp.json()}
    \     ${name}    get from dictionary   ${dic}    name
 #   \     log to console   ${dic["name"]}
    \     ${name_1}   convert to string    ${name}
    \    run keyword if   '${name}'=='inceptor3'    log to console   ${dic}
    \     set suite variable  ${dic}
#    ${dict}  to json  ${dic}
#    log to console  ${dict}


 #    \    log to console     ${dic}








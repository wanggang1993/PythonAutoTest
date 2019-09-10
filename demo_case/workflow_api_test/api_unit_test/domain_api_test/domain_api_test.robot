*** Settings ***
Documentation    domain api test
Resource   ../resource.robot
Resource   domain_resource.robot
Resource   ../workspace_api_test/workspace_resource.robot
Test Setup  Login

*** Variables ***
${Domain_name1}    multi_domain1
${Domain_name2}    multi_domain2
${Namepattern}  multi_domain
${Workspace_name}  workspace


*** Test Cases ***

test_create_new_domain
    [Documentation]   TEST  CREATE DOMAIN
    ${result}=   Create Domain   ${TEST_NAME}
    ${status_code}=  get from dictionary  ${result}  status_code
    ${domain_id}=  get from dictionary  ${result}    domain_id
    should be equal  ${status_code}   ${200}
    should not be equal   ${domain_id}   ${-1}
    ${remove_status}=  Remove Domain   ${domain_id}
    should be equal  ${remove_status}  ${200}


test_create_duplication_of_name_domain
    ${result1}=  Create Domain   ${TEST_NAME}
    ${status_code1}=  get from dictionary  ${result1}  status_code
    ${domain_id1}=  get from dictionary  ${result1}    domain_id
    ${result2}=  Create Domain   ${TEST_NAME}
    ${status_code2}=  get from dictionary  ${result2}  status_code
    ${domain_id2}=  get from dictionary  ${result2}    domain_id
    should be equal  ${status_code1}   ${200}
    should not be equal  ${domain_id1}  ${-1}
    should not be equal  ${status_code2}   ${200}
    should be equal   ${domain_id2}      ${-1}
    ${remove_status1}=  Remove Domain   ${domain_id1}
    should be equal   ${remove_status1}   ${200}
    ${remove_status2}=  Remove Domain   ${domain_id2}
    should not be equal   ${remove_status2}   ${200}


test_remove_workspace_before_remove_domian
    ${result}=   Create Domain   ${TEST_NAME}
    ${status_code}=  get from dictionary  ${result}  status_code
    ${domain_id}=  get from dictionary  ${result}    domain_id
    should be equal  ${status_code}   ${200}
    should not be equal   ${domain_id}  ${-1}
    ${result}=   Create Workspace   ${Workspace_name}   ${domain_id}
    ${status_code}=  get from dictionary    ${result}   status_code
    ${workspace_id}=  get from dictionary   ${result}   workspace_id
    should be equal  ${status_code}   ${200}
    should not be equal  ${workspace_id}   ${-1}
    ${remove_status1}=  Remove Workspace  ${workspace_id}
    should be equal   ${remove_status1}   ${200}
    ${remove_status2}=  Remove Domain   ${domain_id}
    should be equal  ${remove_status2}  ${200}


test_remove_domian_without_remove_workspace
    ${result}=   Create Domain   ${TEST_NAME}
    ${status_code}=  get from dictionary  ${result}  status_code
    ${domain_id}=  get from dictionary  ${result}    domain_id
    should be equal  ${status_code}   ${200}
    should not be equal   ${domain_id}  ${-1}
    ${result}=   Create Workspace   ${Workspace_name}   ${domain_id}
    ${status_code}=  get from dictionary    ${result}   status_code
    ${workspace_id}=  get from dictionary   ${result}   workspace_id
    should be equal  ${status_code}   ${200}
    should not be equal  ${workspace_id}   ${-1}
    ${remove_status1}=  Remove Domain   ${domain_id}
    should not be equal  ${remove_status1}  ${200}
    ${remove_status2}=  Remove Workspace  ${workspace_id}
    should be equal   ${remove_status2}   ${200}
    ${remove_status3}=  Remove Domain   ${domain_id}
    should be equal  ${remove_status3}  ${200}



test_get_domian_domians
    ${result1}=  Create Domain  ${Domain_name1}
    ${status_code1}=  get from dictionary  ${result1}  status_code
    ${domain_id1}=  get from dictionary  ${result1}    domain_id
    should be equal   ${status_code1}   ${200}
    should not be equal   ${domain_id1}  ${-1}
    ${result2}=  Create Domain  ${Domain_name2}
    ${status_code2}=  get from dictionary  ${result2}  status_code
    ${domain_id2}=  get from dictionary  ${result2}    domain_id
    should be equal  ${status_code2}  ${200}
    should not be equal   ${domain_id2}  ${-1}
    ${result3}=  Get Domain  ${domain_id1}
    should be equal  ${result3.status_code}  ${200}
    ${name}=  GET Value From Dic  ${result3.content}   name
    should be equal   ${name}   ${Domain_name1}

    ${result4}=  Get Domains   ${Namepattern}
    ${list}=  to json   ${result4.content}
    log to console  ${list}
    dictionary should contain value  ${list[0]}   ${Domain_name1}
    dictionary should contain value  ${list[1]}   ${Domain_name2}

    ${status_code5}=   Remove Domain  ${domain_id1}
    should be equal  ${status_code5}  ${200}
    ${status_code6}=   Remove Domain  ${domain_id2}
    should be equal  ${status_code6}  ${200}


test_update_domain
    ${result1}=  Create Domain  ${TEST_NAME}
    ${status_code1}=  get from dictionary  ${result1}  status_code
    ${domain_id1}=  get from dictionary  ${result1}    domain_id
    ${status_code2}=  Update Domain   ${domain_id1}  update_domian_name
    should be equal  ${status_code2}   ${200}

    ${result2}=  Get Domain   ${domain_id1}
    should be equal   ${result2.status_code}   ${200}
    #${content2}=  to json  ${result2.content}
    ${name}=  get value from dic  ${result2.content}  name
    should be equal   ${name}   update_domian_name

    ${remove_status}=  Remove Domain   ${domain_id1}
    should be equal  ${remove_status}  ${200}


#test remove
#    Remove Domain   ${91}
#    Remove Domain   ${92}
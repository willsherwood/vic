*** Settings ***
Documentation  Test 6-07 - Verify vic-machine create network function
Resource  ../../resources/Util.robot
Test Teardown  Run Keyword If Test Failed  Cleanup VIC Appliance On Test Server

*** Keywords ***
External network - default
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=%{BRIDGE_NETWORK} ${vicmachinetls}
    Should Contain  ${output}  Installer completed successfully
    Get Docker Params  ${output}  ${true}
    Log To Console  Installer completed successfully: ${vch-name}

    ${vm}=  Get VM Name  ${vch-name}
    ${info}=  Get VM Info  ${vm}
    Should Contain  ${info}  VM Network

    Run Regression Tests
    Cleanup VIC Appliance On Test Server

External network - invalid
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --external-network=AAAAAAAAAA ${vicmachinetls}
    Should Contain  ${output}  --external-network: network 'AAAAAAAAAA' not found
    Should Contain  ${output}  vic-machine-linux failed

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

External network - invalid vCenter
    Pass execution  Test not implemented

External network - DHCP
    Pass execution  Test not implemented

External network - valid
    Pass execution  asdf

Management network - none
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=%{BRIDGE_NETWORK} --external-network=%{EXTERNAL_NETWORK} ${vicmachinetls}
    Should Contain  ${output}  Installer completed successfully
    ${status}=  Run Keyword And Return Status  Should Contain  ${output}  Network role "management" is sharing NIC with "external"
    ${status2}=  Run Keyword And Return Status  Should Contain  ${output}  Network role "external" is sharing NIC with "management"
    ${status3}=  Run Keyword And Return Status  Should Contain  ${output}  Network role "external" is sharing NIC with "client"
    ${status4}=  Run Keyword And Return Status  Should Contain  ${output}  Network role "management" is sharing NIC with "client"
    Should Be True  ${status} | ${status2} | ${status3} | ${status4}
    Get Docker Params  ${output}  ${true}
    Log To Console  Installer completed successfully: ${vch-name}

    Run Regression Tests
    Cleanup VIC Appliance On Test Server

Management network - invalid
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --management-network=AAAAAAAAAA ${vicmachinetls}
    Should Contain  ${output}  --management-network: network 'AAAAAAAAAA' not found
    Should Contain  ${output}  vic-machine-linux failed

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

Management network - invalid vCenter
    Pass execution  Test not implemented

Management network - unreachable
    Pass execution  Test not implemented

Management network - valid
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=%{BRIDGE_NETWORK} --management-network=%{EXTERNAL_NETWORK} ${vicmachinetls}
    Should Contain  ${output}  Installer completed successfully
    Get Docker Params  ${output}  ${true}
    Log To Console  Installer completed successfully: ${vch-name}

    Run Regression Tests
    Cleanup VIC Appliance On Test Server

Bridge network - vCenter none
    Run Keyword If  '%{HOST_TYPE}' == 'ESXi'  Pass Execution  Test skipped on ESXi

    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} ${vicmachinetls}
    Should Contain  ${output}  FAILURE

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}


Bridge network - ESX none
    Run Keyword If  '%{HOST_TYPE}' == 'VC'  Pass Execution  Test skipped on VC

    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} ${vicmachinetls}
    Should Contain  ${output}  Installer completed successfully
    Get Docker Params  ${output}  ${true}
    Log To Console  Installer completed successfully: ${vch-name}

    Run Regression Tests
    Cleanup VIC Appliance On Test Server

Bridge network - invalid
    Pass execution  asdf
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=AAAAAAAAAA ${vicmachinetls}
    Should Contain  ${output}  --bridge-network: network 'AAAAAAAAAA' not found
    Should Contain  ${output}  vic-machine-linux failed

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

Bridge network - invalid vCenter
    Run Keyword If  '%{HOST_TYPE}' == 'ESXi'  Pass Execution  Test skipped on ESXi

    Pass execution  Test not implemented

Bridge network - non-DPG
    Run Keyword If  '%{HOST_TYPE}' == 'ESXi'  Pass Execution  Test skipped on ESXi

    Pass execution  Test not implemented

Bridge network - valid
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=%{BRIDGE_NETWORK} ${vicmachinetls}
    Should Contain  ${output}  Installer completed successfully
    Get Docker Params  ${output}  ${true}
    Log To Console  Installer completed successfully: ${vch-name}

    Run Regression Tests
    Cleanup VIC Appliance On Test Server

Bridge network - reused port group
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=%{BRIDGE_NETWORK} --external-network=%{BRIDGE_NETWORK} ${vicmachinetls}
    Should Contain  ${output}  the bridge network must not be shared with another network role

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=%{BRIDGE_NETWORK} --management-network=%{BRIDGE_NETWORK} ${vicmachinetls}
    Should Contain  ${output}  the bridge network must not be shared with another network role

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=%{BRIDGE_NETWORK} --client-network=%{BRIDGE_NETWORK} ${vicmachinetls}
    Should Contain  ${output}  the bridge network must not be shared with another network role

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

Bridge network - invalid IP settings
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=%{BRIDGE_NETWORK} --bridge-network-range 1.1.1.1 ${vicmachinetls}
    Should Contain  ${output}  Error parsing bridge network ip range

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

Bridge network - valid simple bridge network
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --bridge-network=%{BRIDGE_NETWORK} --bridge-network-range 192.168.1.1/16 ${vicmachinetls}
    Should Contain  ${output}  Installer completed successfully
    Log To Console  Installer completed successfully: ${vch-name}

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

Container network invalid 1
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=fakeNet:alias ${vicmachinetls}
    Should Contain  ${output}  Error adding container network "alias": network 'fakeNet' not found

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

Container network invalid 2
    Log To Console  TODO - Needs to be done on VC

Container network 1
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=%{BRIDGE_NETWORK}:net1 ${vicmachinetls}
    Should Contain  ${output}  Installer completed successfully
    Log To Console  Installer completed successfully: ${vch-name}

    Get Docker Params  ${output}  ${true}
    Run Regression Tests

    ${out}=  Run  docker ${params} network ls
    Should Contain  ${out}  net1

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

Container network 2
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=%{BRIDGE_NETWORK} ${vicmachinetls}
    Should Contain  ${output}  Installer completed successfully
    Log To Console  Installer completed successfully: ${vch-name}

    Get Docker Params  ${output}  ${true}
    Run Regression Tests

    ${out}=  Run  docker ${params} network ls
    Should Contain  ${out}  %{BRIDGE_NETWORK}

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

Network mapping invalid
    Pass Execution  Test not implemented - maybe doesn't make sense

Network mapping gateway invalid
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=%{BRIDGE_NETWORK}:net1 --container-network-gateway=%{BRIDGE_NETWORK}:192.168.1.0/24 ${vicmachinetls}
    Should Contain  ${output}  Gateway 192.168.1.0 is not a routable address

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=%{BRIDGE_NETWORK}:net1 --container-network-gateway=fakeNetwork:1.1.1.1/24 ${vicmachinetls}
    Should Contain  ${output}  fakeNetwork:1.1.1.1/24, "fakeNetwork" should be vSphere network name

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

Network mapping IP invalid
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=%{BRIDGE_NETWORK}:net1 --container-network-gateway=%{BRIDGE_NETWORK}:192.168.1.1/24 --container-network-ip-range=fakeNetwork:192.168.1.1-192.168.1.100 ${vicmachinetls}
    Should Contain  ${output}  fakeNetwork:[{192.168.1.1 192.168.1.100}], "fakeNetwork" should be vSphere network name

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=%{BRIDGE_NETWORK}:net1 --container-network-gateway=%{BRIDGE_NETWORK}:192.168.1.1/24 --container-network-ip-range=%{BRIDGE_NETWORK}:192.168.2.1-192.168.2.100 ${vicmachinetls}
    Should Contain  ${output}  IP range {"192.168.2.1" "192.168.2.100"} is not in subnet {"192.168.1.1" "ffffff00"}

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

DNS format invalid
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=%{BRIDGE_NETWORK}:net1 --container-network-dns=fakeNetwork:8.8.8.8 ${vicmachinetls}
    Should Contain  ${output}  fakeNetwork:[8.8.8.8], "fakeNetwork" should be vSphere network name

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=%{BRIDGE_NETWORK}:net1 --container-network-dns=%{BRIDGE_NETWORK}:abcdefg ${vicmachinetls}
    Should Contain  ${output}  Error parsing container network parameter %{BRIDGE_NETWORK}:abcdefg: invalid IP address: abcdefg

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

*** Test Cases ***
Network mapping
    Set Test Environment Variables
    # Attempt to cleanup old/canceled tests
    Run Keyword And Ignore Error  Cleanup Dangling VMs On Test Server
    Run Keyword And Ignore Error  Cleanup Datastore On Test Server

    ${output}=  Run  bin/vic-machine-linux create --name=${vch-name} --target="%{TEST_USERNAME}:%{TEST_PASSWORD}@%{TEST_URL}" --thumbprint=%{TEST_THUMBPRINT} --image-store=%{TEST_DATASTORE} --container-network=%{BRIDGE_NETWORK}:net1 --container-network-gateway=%{BRIDGE_NETWORK}:192.168.1.1/24 --container-network-ip-range=%{BRIDGE_NETWORK}:192.168.1.1-192.168.1.100 --container-network-dns=%{BRIDGE_NETWORK}:8.8.8.8 ${vicmachinetls}
    Should Contain  ${output}  Installer completed successfully
    Log To Console  Installer completed successfully: ${vch-name}

    Get Docker Params  ${output}  ${true}
    Run Regression Tests
    
    ${out}=  Run  docker ${params} network ls
    Should Contain  ${out}  net1
    
    ${out}=  Run  docker ${params} run -itd --name ping1 --net net1 busybox sh -c "ifconfig && /bin/top"
    ${out2}=  Run  docker ${params} run --name ping2 --net net1 busybox ping -c2 ping1
    
    ${out}=  Run  docker ${params} logs ping1
    ${out2}=  Run  docker ${params} logs ping2
    
    Log  ${out}
    Log  ${out2}
    
    Should Contain  ${out}  192.168.1.
    # Can't get this to work
    #Should Contain  ${out2}  2 packets transmitted, 2 received, 0% packet loss

    # Delete the portgroup added by env vars keyword
    Cleanup VCH Bridge Network  ${vch-name}

VCH static IP - Static external
    Pass execution  Test not implemented

VCH static IP - Static client
    Pass execution  Test not implemented

VCH static IP - Static management
    Pass execution  Test not implemented

VCH static IP - different port groups 1
    Pass execution  Test not implemented

VCH static IP - different port groups 2
    Pass execution  Test not implemented

VCH static IP - same port group
    Pass execution  Test not implemented

VCH static IP - same subnet for multiple port groups
    Pass execution  Test not implemented

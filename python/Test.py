"""this allows to retrieve the headers, query params, and body from a given URL """
import requests
import json
import pprint
from bs4 import BeautifulSoup as BS

EXAMPLEURL = "https://help.inin.com/developer/cic/docs/icws/webhelp/\
icws/connection/index.htm#post"
METHOD = "post"
DATA_SOURCE = {}

# FEE = open("./debug.html", 'wb')
# FEE.write(requests.get(EXAMPLEURL).content)
# FEE.close()

def get_call_data(url, method):
    """this method is what is supposed to be called from outside
    this module to get the headers + body of each api call"""
    data = {}
    method = method.lower()
    page = requests.get(url)
    soup = BS(page.text, "html.parser")
    # page = open("example.html", 'r')
    # soup = BS(page.read(), "html.parser")
    data_clone_source(soup)
    sections = soup.find("header", attrs={"id": method})\
    .find_next_sibling().section.find_all('section')
    data["headers"] = get_headers(sections[0])
    data["template"] = get_templae(sections[0])
    data["query_params"] = get_query_params(sections[0])
    data["body"] = get_body(sections[1])
    return data

def data_clone_source(soup):
    """Retrieve data contract clone sources"""
    result = soup.findAll("div", attrs={"class":"complex-type-contents data-contract-clone-source"})
    for item in result:
        level = item.find("div").attrs["class"][1][-1:]
        DATA_SOURCE[item.attrs['data-clone-id']] = get_body(item, int(level))
    # pprint.pprint(DATA_SOURCE)


def get_headers(parameters_section):
    """get Headers from URL and method"""
    return get_x_param(parameters_section, "Header")

def get_templae(parameters_section):
    """get template from URL and method"""
    return get_x_param(parameters_section, "Template")

def get_query_params(parameters_section):
    """Get the query params from the Parameters section"""
    return get_x_param(parameters_section, "Query")

def get_x_param(parameters_section, parameters):
    """Get the X params from the Parameters section"""
    ximo = parameters_section.find_all("span", attrs={"data-param-type":parameters})
    result = []
    for item in ximo:
        result.append(item.parent.find_next_sibling().get_text())
    return result

def get_body(body_section, level=0):
    """gets the api call body from the html webpage"""
    # FIrst, let's create the dict to be converted to a json later
    i = 0
    result = {}
    # starting with the simple elements
    simple_keys = body_section\
    .find_all("div", attrs={"class":"row data-contract-level-"+str(level)})
    for item in simple_keys:
        dict_to_be = item.find_all("div", attrs={"class":"span2"})
        try:
            req = " ***"+dict_to_be[1].find_next_sibling()\
            .find("span", attrs={"class":"label label-important"}).get_text()[1:]+"***"
        except AttributeError:
            req = " ---Optional---"
        result[dict_to_be[0].get_text()] = dict_to_be[1].get_text()+req
    # Then, let's get the other Complex elements
    complex_keys = body_section\
    .find_all("div", attrs={"class":"row data-contract-level-"+str(level)+" collapsible collapsed"})
    for complexy in complex_keys:
        complex_key = complexy.find("span", attrs={"class":"property-content"}).get_text()
        if complex_key in result:
            i += 1
            complex_key += i*"*"
        siblingo = complexy.find_next_sibling()
        if "data-contract-clone-target" in siblingo.attrs["class"]:
            result[complex_key] = DATA_SOURCE[siblingo.attrs["data-clone-id"]]
        else:
            result[complex_key] = get_body(siblingo, level+1)

        # data-contract-clone-target
    return result

# with open("./json/debug.json", 'w') as fifile:
#     fifile.write(json.dumps(get_call_data(EXAMPLEURL, METHOD)))


1 Login: FAIL (hr = 0x80fb0800)

   autoRetryByErrorCode=0
   withRescheduleHint=0
   withAutoRetrials=0
   Login failed with permanent error or no auto-retrials
1.1 Lync-autodiscovery: FAIL (hr = 0x80fb0800)
Lync autodiscovery completed with hr: 0X80fb0800 sipint:  sipext:  authint:  authext:  ucwaint:  ucwaext:  wts:  ucwaurl:  telemetryurl:  isServiceInRefresh: 0 isTempError: 0Lync autodiscovery completed with hr: 0X80fb0800 sipint:  sipext:  authint:  authext:  ucwaint:  ucwaext:  wts:  ucwaurl:  telemetryurl:  isServiceInRefresh: 0 isTempError: 0
1.1.1 Get-NewWebTicket: FAIL (hr = 0x80fb0800)
Executing wws method with OAuth, asyncContext=1214F6C8,
 context: WebRequest context@ :301222784
  MethodType:7
  ExecutionComplete? :1
  Callback@ :11E27454
  AsyncHResult:80f10041
  TargetUri:https://webdir1a.online.lync.com/WebTicket/WebTicketService.svc/OAuth
  OperationName:http://tempuri.org/:IWebTicketService
 Error:
The server returned a trust fault: 'The specified request failed'.
The fault reason was: 'The SIP URI in the claim type requirements of the web ticket request does not match the SIP URI associated with the presented credentials.'.

.Executing wws method with OAuth, asyncContext=1214F6C8,
 context: WebRequest context@ :301222784
  MethodType:7
  ExecutionComplete? :1
  Callback@ :11E27454
  AsyncHResult:80f10041
  TargetUri:https://webdir1a.online.lync.com/WebTicket/WebTicketService.svc/OAuth
  OperationName:http://tempuri.org/:IWebTicketService
 Error:
The server returned a trust fault: 'The specified request failed'.
The fault reason was: 'The SIP URI in the claim type requirements of the web ticket request does not match the SIP URI associated with the presented credentials.'.

.
1.1.1.1 ExecuteWithWindowsOrNoAuthInternal: FAIL (hr = 0x3d0000)
Executing wws method with no auth auth, asyncContext=1214F6C8,
 context: WebRequest context@ :155521456
  MethodType:0
  ExecutionComplete? :1
  Callback@ :11E1F770
  AsyncHResult:3d0000
  TargetUri:https://webdir1a.online.lync.com/WebTicket/WebTicketService.svc/mex

.
1.1.1.2 ExecuteWithMetadataInternal: FAIL (hr = 0x3d0000)
Executing wws method with no auth auth, asyncContext=1214F6C8,
 context: WebRequest context@ :155521456
  MethodType:0
  ExecutionComplete? :1
  Callback@ :11E1F770
  AsyncHResult:3d0000
  TargetUri:https://webdir1a.online.lync.com/WebTicket/WebTicketService.svc/mex

.
1.1.1.3 ExecuteWithWindowsOrNoAuthInternal: PASS
1.1.1.4 Get-OAuthToken: PASS
1.1.1.4.1 ExecuteWithOAuthInternal: FAIL (hr = 0x3d0000)
OAuth access token retrieved for asyncontext(1214F6C8), current client-request-id(0E9C327C-149F-4341-BDEC-0B171A46493E), token's client-request-id(0E9C327C-149F-4341-BDEC-0B171A46493E), CLogonCredentialManager::GetProxyCredentials()Requesting credential user 0x09691658 id=15 asking for credentials with ProxyChallengeDetails[authModes=0, firewallName=, realm=]
1.1.1.4.2 ExecuteWithMetadataInternal: FAIL (hr = 0x3d0000)
OAuth access token retrieved for asyncontext(1214F6C8), current client-request-id(0E9C327C-149F-4341-BDEC-0B171A46493E), token's client-request-id(0E9C327C-149F-4341-BDEC-0B171A46493E), CLogonCredentialManager::GetProxyCredentials()Requesting credential user 0x09691658 id=15 asking for credentials with ProxyChallengeDetails[authModes=0, firewallName=, realm=]
1.1.1.4.3 ExecuteWithOAuthInternal: FAIL (hr = 0x3d0000)
CLogonCredentialManager::GetProxyCredentials()Requesting credential user 0x09691658 id=15 asking for credentials with ProxyChallengeDetails[authModes=0, firewallName=, realm=]
1.1.1.5 Get-OAuthToken: PASS
1.1.1.5.1 ExecuteWithOAuthInternal: FAIL (hr = 0x3d0000)
OAuth access token retrieved for asyncontext(1214F6C8), current client-request-id(0E9C327C-149F-4341-BDEC-0B171A46493E), token's client-request-id(0E9C327C-149F-4341-BDEC-0B171A46493E), CLogonCredentialManager::GetProxyCredentials()Requesting credential user 0x09691658 id=15 asking for credentials with ProxyChallengeDetails[authModes=0, firewallName=, realm=]
1.1.1.5.2 ExecuteWithOAuthInternal: FAIL (hr = 0x3d0000)
CLogonCredentialManager::GetProxyCredentials()Requesting credential user 0x09691658 id=15 asking for credentials with ProxyChallengeDetails[authModes=0, firewallName=, realm=]
1.1.1.6 Get-OAuthToken: PASS
1.1.1.6.1 ExecuteWithOAuthInternal: FAIL (hr = 0x3d0000)
OAuth access token retrieved for asyncontext(1214F6C8), current client-request-id(0E9C327C-149F-4341-BDEC-0B171A46493E), token's client-request-id(0E9C327C-149F-4341-BDEC-0B171A46493E), CLogonCredentialManager::GetProxyCredentials()Requesting credential user 0x09691658 id=15 asking for credentials with ProxyChallengeDetails[authModes=0, firewallName=, realm=]
1.1.1.6.2 ExecuteWithOAuthInternal: FAIL (hr = 0x3d0000)
CLogonCredentialManager::GetProxyCredentials()Requesting credential user 0x09691658 id=15 asking for credentials with ProxyChallengeDetails[authModes=0, firewallName=, realm=]
1.1.1.7 ExecuteWithOAuthInternal: FAIL (hr = 0x80fb0800)
Executing wws method with OAuth, asyncContext=1214F6C8,
 context: WebRequest context@ :301222784
  MethodType:7
  ExecutionComplete? :1
  Callback@ :11E27454
  AsyncHResult:80f10041
  TargetUri:https://webdir1a.online.lync.com/WebTicket/WebTicketService.svc/OAuth
  OperationName:http://tempuri.org/:IWebTicketService
 Error:
The server returned a trust fault: 'The specified request failed'.
The fault reason was: 'The SIP URI in the claim type requirements of the web ticket request does not match the SIP URI associated with the presented credentials.'.

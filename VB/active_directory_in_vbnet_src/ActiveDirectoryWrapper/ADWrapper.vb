Imports System.DirectoryServices
Imports System.Security
Imports system.Security.Principal
Imports System.Threading
Imports System.Globalization
Imports System.Windows.Forms
Imports System.Text.StringBuilder
Namespace PC
    Public Class ADWrapper
#Region "Private Variables"
        Public Shared ADAdminUser As String
        ' = "administrator"; //Administrator username of DC
        Public Shared ADAdminPassword As String
        ' = "password"; //Password of admin user on DC
        'This needs to have the domain name or IP address on this line
        Public Shared ADFullPath As String
        ' = "LDAP://192.168.0.3"; 
        'This must be the domain name of the domain controller (not the computer name, just the domain name)
        Public Shared ADServer As String
        ' = "sakura.com";
        '		private static string ADPath= ADFullPath ; 
        '		private static string ADUser = ADAdminUser ;
        '		private static string ADPassword = ADAdminPassword ;

#End Region

#Region "Enumerations"
        Public Enum ADAccountOptions
            UF_TEMP_DUPLICATE_ACCOUNT = 256
            UF_NORMAL_ACCOUNT = 512
            UF_INTERDOMAIN_TRUST_ACCOUNT = 2048
            UF_WORKSTATION_TRUST_ACCOUNT = 4096
            UF_SERVER_TRUST_ACCOUNT = 8192
            UF_DONT_EXPIRE_PASSWD = 65536
            UF_SCRIPT = 1
            UF_ACCOUNTDISABLE = 2
            UF_HOMEDIR_REQUIRED = 8
            UF_LOCKOUT = 16
            UF_PASSWD_NOTREQD = 32
            UF_PASSWD_CANT_CHANGE = 64
            UF_ACCOUNT_LOCKOUT = 16
            UF_ENCRYPTED_TEXT_PASSWORD_ALLOWED = 128
        End Enum


        Public Enum LoginResult
            LOGIN_OK = 0
            LOGIN_USER_DOESNT_EXIST
            LOGIN_USER_ACCOUNT_INACTIVE
        End Enum

#End Region
        Public Shared Function GetDirectoryEntry() As DirectoryEntry
            Dim dirEntry As DirectoryEntry = New DirectoryEntry()
            dirEntry.Path = "LDAP://192.168.1.1/CN=Users;DC=Yourdomain"
            dirEntry.Username = "yourdomain\sampleuser"
            dirEntry.Password = "samplepassword"
            Return dirEntry
        End Function

        ''' <summary>
        ''' Function to extract just the login from the provided string (given in the format AMBASSADORSGROU\Firstname.Lastname)
        ''' </summary>
        ''' <param name="path">Full AD login of the associate</param>
        ''' <returns>The login with the "AMBASSADORSGROU\" stripped</returns>
        ''' <remarks></remarks>
        Public Function ExtractUserName(ByVal path As String) As String
            Dim userPath As String() = path.Split(New Char() {"\"c})
            Return userPath((userPath.Length - 1))
        End Function

        ''' <summary>
        ''' Helper method that sets properties for AD users.
        ''' </summary>
        ''' <param name="de">DirectoryEntry to use</param>
        ''' <param name="pName">Property name to set</param>
        ''' <param name="pValue">Value of property to set</param>
        Public Shared Sub SetProperty(ByVal de As DirectoryEntry, ByVal pName As String, ByVal pValue As String)
            'First make sure the property value isnt "nothing"
            If Not pValue Is Nothing Then
                'Check to see if the DirectoryEntry contains this property already
                If de.Properties.Contains(pName) Then   'The DE contains this property
                    'Update the properties value
                    de.Properties(pName)(0) = pValue
                Else    'Property doesnt exist
                    'Add the property and set it's value
                    de.Properties(pName).Add(pValue)
                End If
            End If
        End Sub

        Public Function IsValidADLogin(ByVal loginName As String, ByVal givenName As String, ByVal surName As String) As Boolean
            Try
                Dim search As New DirectorySearcher()
                search.Filter = String.Format("(&(SAMAccountName={0})(givenName={1})(sn={2}))", ExtractUserName(loginName), givenName, surName)
                search.PropertiesToLoad.Add("cn")
                search.PropertiesToLoad.Add("SAMAccountName")   'Users login name
                search.PropertiesToLoad.Add("givenName")    'Users first name
                search.PropertiesToLoad.Add("sn")   'Users last name
                'Use the .FindOne() Method to stop as soon as a match is found
                Dim result As SearchResult = search.FindOne()
                If result Is Nothing Then
                    Return False
                Else
                    Return True
                End If
            Catch ex As Exception
                MessageBox.Show(ex.Message, "Active Directory Error", MessageBoxButtons.OK, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1)
            End Try
        End Function

        ''' <summary>
        ''' Method to add a user to a group
        ''' </summary>
        ''' <param name="de">DirectoryEntry to use</param>
        ''' <param name="deUser">DirectoryEntry (User) to use</param>
        ''' <param name="GroupName">Group name (in string formation) to search and ultimately add user to</param>
        Public Shared Sub AddUserToGroup(ByVal de As DirectoryEntry, ByVal deUser As DirectoryEntry, ByVal GroupName As String)
            Dim deSearch As DirectorySearcher = New DirectorySearcher()
            deSearch.SearchRoot = de
            deSearch.Filter = "(&(objectClass=group) (cn=" & GroupName & "))"
            Dim results As SearchResultCollection = deSearch.FindAll()
            Dim isGroupMember As Boolean = False
            If results.Count > 0 Then
                Dim group As New DirectoryEntry(results(0).Path)
                Dim members As Object = group.Invoke("Members", Nothing)
                For Each member As Object In CType(members, IEnumerable)
                    Dim x As DirectoryEntry = New DirectoryEntry(member)
                    Dim name As String = x.Name
                    If name <> deUser.Name Then
                        isGroupMember = False
                    Else
                        isGroupMember = True
                        Exit For
                    End If
                Next member
                If (Not isGroupMember) Then
                    group.Invoke("Add", New Object() {deUser.Path.ToString()})
                End If
                group.Close()
            End If
            Return
        End Sub

        ''' <summary>
        ''' Procedure to create a new Active Directory account
        ''' </summary>
        ''' <param name="sUserName">Username for the new account</param>
        ''' <param name="sPassword">Password for the new account</param>
        ''' <remarks></remarks>
        Public Sub CreateAdAccount(ByVal sUserName As String, ByVal sPassword As String)
            Dim sUser As String = "CN=username"
            Dim dirEntry As New DirectoryEntry(GetDirectoryEntry)
            Dim deChild As DirectoryEntries = dirEntry.Children
            Dim deUser As DirectoryEntry = deChild.Add(sUser, "user")
            deUser.Properties("SAMAccountName").Add(sUserName)
            deUser.CommitChanges()
            SetPassword(deUser, sPassword)
            EnableAccount(deUser)
        End Sub

        '' <summary>
        ''' Method to set a user's password
        ''' <param name="dEntry">DirectoryEntry to use</param>
        ''' <param name="sPassword">Password for the new user</param>
        Private Shared Sub SetPassword(ByVal dEntry As DirectoryEntry, ByVal sPassword As String)
            Dim oPassword As Object() = New Object() {sPassword}
            Dim ret As Object = dEntry.Invoke("SetPassword", oPassword)
            dEntry.CommitChanges()
        End Sub

        ''' <summary>
        ''' Method to enable a user account in the AD.
        ''' </summary>
        ''' <param name="de"></param>
        Private Shared Sub EnableAccount(ByVal de As DirectoryEntry)
            'UF_DONT_EXPIRE_PASSWD 0x10000
            Dim exp As Integer = CInt(de.Properties("userAccountControl").Value)
            de.Properties("userAccountControl").Value = exp Or &H1
            de.CommitChanges()
            'UF_ACCOUNTDISABLE 0x0002
            Dim val As Integer = CInt(de.Properties("userAccountControl").Value)
            de.Properties("userAccountControl").Value = val And Not &H2
            de.CommitChanges()
        End Sub

        ''' <summary>
        ''' Procedure to create a new Active Directory account
        ''' </summary>
        ''' <param name="sUserName">Username for the new account</param>
        ''' <param name="sPassword">Password for the new account</param>
        ''' <param name="sFirstName">First name of the user</param>
        ''' <param name="sLastName">Last name of the user</param>
        ''' <param name="sGroupName">Group to add the user to</param>
        ''' <remarks></remarks>
        Public Sub CreateAdAccount(ByVal sUserName As String, ByVal sPassword As String, ByVal sFirstName As String, ByVal sLastName As String, ByVal sGroupName As String)
            Dim dirEntry As New DirectoryEntry()
            ' 1. Create user account
            Dim adUsers As DirectoryEntries = dirEntry.Children
            Dim newUser As DirectoryEntry = adUsers.Add("CN=" & sUserName, "user")
            ' 2. Set properties
            SetProperty(newUser, "givenname", sFirstName)
            SetProperty(newUser, "sn", sLastName)
            SetProperty(newUser, "SAMAccountName", sUserName)
            SetProperty(newUser, "userPrincipalName", sUserName)
            newUser.CommitChanges()
            ' 3. Set the password
            SetPassword(newUser, sPassword)
            ' 5. Add the user to the specified group
            AddUserToGroup(dirEntry, newUser, sGroupName)
            ' 6. Enable the account
            EnableAccount(newUser)
            ' 7. Close & clean-up
            newUser.Close()
            dirEntry.Close()
        End Sub

        ''' <summary>
        ''' Method that disables a user account in the AD 
        ''' and hides user's email from Exchange address lists.
        ''' </summary>
        ''' <param name="sLogin">Login of the user to disable</param>
        Public Sub DisableAccount(ByVal sLogin As String)
            '   1. Search the Active Directory for the desired user
            Dim dirEntry As DirectoryEntry = GetDirectoryEntry()
            Dim dirSearcher As DirectorySearcher = New DirectorySearcher(dirEntry)
            dirSearcher.Filter = "(&(objectCategory=Person)(objectClass=user)(SAMAccountName=" & sLogin & "))"
            dirSearcher.SearchScope = SearchScope.Subtree
            Dim results As SearchResult = dirSearcher.FindOne()
            '   2. Check returned results
            If Not results Is Nothing Then
                '   2a. User was returned
                Dim dirEntryResults As New DirectoryEntry(results.Path)
                Dim iVal As Integer = CInt(dirEntryResults.Properties("userAccountControl").Value)
                '   3. Disable the users account
                dirEntryResults.Properties("userAccountControl").Value = iVal Or &H2
                '   4. Hide users email from all Exchange Mailing Lists
                dirEntryResults.Properties("msExchHideFromAddressLists").Value = "TRUE"
                dirEntryResults.CommitChanges()
                dirEntryResults.Close()
            End If
            dirEntry.Close()
        End Sub

        '''<summary>
        ''' Establish identity (principal) and culture for a thread.
        ''' </summary>
        Public Shared Sub SetCultureAndIdentity()
            AppDomain.CurrentDomain.SetPrincipalPolicy(PrincipalPolicy.WindowsPrincipal)
            Dim principal As WindowsPrincipal = CType(Thread.CurrentPrincipal, WindowsPrincipal)
            Dim identity As WindowsIdentity = CType(principal.Identity, WindowsIdentity)
            System.Threading.Thread.CurrentThread.CurrentCulture = New CultureInfo("en-US")
        End Sub

        ''' <summary>
        ''' Method that updates user's properties
        ''' </summary>
        ''' <param name="userLogin">Login of the user to update</param>
        ''' <param name="userDepartment">New department of the specified user</param>
        ''' <param name="userTitle">New title of the specified user</param>
        ''' <param name="userPhoneExt">New phone extension of the specified user</param>
        Public Sub UpdateUserADAccount(ByVal userLogin As String, ByVal userDepartment As String, ByVal userTitle As String, ByVal userPhoneExt As String)
            Dim dirEntry As DirectoryEntry = GetDirectoryEntry()
            Dim dirSearcher As DirectorySearcher = New DirectorySearcher(dirEntry)
            '   1. Search the Active Directory for the speied user
            dirSearcher.Filter = "(&(objectCategory=Person)(objectClass=user)(SAMAccountName=" & userLogin & "))"
            dirSearcher.SearchScope = SearchScope.Subtree
            Dim searchResults As SearchResult = dirSearcher.FindOne()
            If Not searchResults Is Nothing Then
                Dim dirEntryResults As New DirectoryEntry(searchResults.Path)
                'The properties listed here may be different then the properties in your Active Directory
                'so they may need to be changed according to your network
                '   2. Set the new property values for the specified user
                SetProperty(dirEntryResults, "department", userDepartment)
                SetProperty(dirEntryResults, "title", userTitle)
                SetProperty(dirEntryResults, "phone", userPhoneExt)
                '   3. Commit the changes
                dirEntryResults.CommitChanges()
                '   4. Close & Cleanup
                dirEntryResults.Close()
            End If
            '   4a. Close & Cleanup
            dirEntry.Close()
        End Sub

        ''' <summary>
        ''' Function to query the Active Directory and return all the computer names on the network
        ''' </summary>
        ''' <returns>A collection populated with all the computer names</returns>
        Public Shared Function ListAllADComputers() As Collection
            Dim dirEntry As DirectoryEntry = GetDirectoryEntry()
            Dim pcList As New Collection()
            '   1. Search the Active Directory for all objects with type of computer
            Dim dirSearcher As DirectorySearcher = New DirectorySearcher(dirEntry)
            dirSearcher.Filter = ("(objectClass=computer)")
            '   2. Check the search results
            Dim dirSearchResults As SearchResult
            '   3. Loop through all the computer names returned
            For Each dirSearchResults In dirSearcher.FindAll()
                '   4. Check to ensure the computer name isnt already listed in the collection
                If Not pcList.Contains(dirSearchResults.GetDirectoryEntry().Name.ToString()) Then
                    '   5. Add the computer name to the collection (since it dont already exist)
                    pcList.Add(dirSearchResults.GetDirectoryEntry().Name.ToString())
                End If
            Next
            '   6. Return the results
            Return pcList
        End Function

        ''' <summary>
        ''' Function to return all the groups the user is a member od
        ''' </summary>
        ''' <param name="_path">Path to bind to the AD</param>
        ''' <param name="username">Username of the user</param>
        ''' <param name="password">password of the user</param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Private Function GetGroups(ByVal _path As String, ByVal username As String, ByVal password As String) As Collection
            Dim Groups As New Collection
            Dim dirEntry As New System.DirectoryServices.DirectoryEntry(_path, username, password)
            Dim dirSearcher As New DirectorySearcher(dirEntry)
            dirSearcher.Filter = String.Format("(sAMAccountName={0}))", username)
            dirSearcher.PropertiesToLoad.Add("memberOf")
            Dim propCount As Integer
            Try
                Dim dirSearchResults As SearchResult = dirSearcher.FindOne()
                propCount = dirSearchResults.Properties("memberOf").Count
                Dim dn As String
                Dim equalsIndex As String
                Dim commaIndex As String
                For i As Integer = 0 To propCount - 1
                    dn = dirSearchResults.Properties("memberOf")(i)
                    equalsIndex = dn.IndexOf("=", 1)
                    commaIndex = dn.IndexOf(",", 1)
                    If equalsIndex = -1 Then
                        Return Nothing
                    End If
                    If Not Groups.Contains(dn.Substring((equalsIndex + 1), (commaIndex - equalsIndex) - 1)) Then
                        Groups.Add(dn.Substring((equalsIndex + 1), (commaIndex - equalsIndex) - 1))
                    End If
                Next
            Catch ex As Exception
                If ex.GetType Is GetType(System.NullReferenceException) Then
                    MessageBox.Show("does not have a group", "No groups listed", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    'they are still a good user just does not
                    'have a "memberOf" attribute so it errors out.
                    'code to do something else here if you want
                Else
                    MessageBox.Show(ex.Message.ToString, "Search Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End If
            End Try
            Return Groups
        End Function

        ''' <summary>
        ''' This will perfrom a logical operation on the userAccountControl values
        ''' to see if the user account is enabled or disabled.  The flag for determining if the
        ''' account is active is a bitwise value (decimal =2)
        ''' </summary>
        ''' <param name="userAccountControl"></param>
        ''' <returns></returns>
        Public Shared Function IsAccountActive(ByVal userAccountControl As Integer) As Boolean
            Dim accountDisabled As Integer = Convert.ToInt32(ADAccountOptions.UF_ACCOUNTDISABLE)
            Dim flagExists As Integer = userAccountControl And accountDisabled
            'if a match is found, then the disabled flag exists within the control flags
            If flagExists > 0 Then
                Return False
            Else
                Return True
            End If
        End Function

        ''' <summary>
        ''' This will perform the removal of a user from the specified group
        ''' </summary>
        ''' <param name="UserName">Username of the user to remove</param>
        ''' <param name="GroupName">Groupname to remove them from</param>
        ''' <remarks></remarks>
        Public Shared Sub RemoveUserFromGroup(ByVal UserName As String, ByVal GroupName As String)
            Dim Domain As New String("")

            'get reference to group
            Domain = "/CN=" + GroupName + ",CN=Users," + GetLDAPDomain()
            Dim oGroup As DirectoryEntry = GetDirectoryObject(Domain)

            'get reference to user
            Domain = "/CN=" + UserName + ",CN=Users," + GetLDAPDomain()
            Dim oUser As DirectoryEntry = GetDirectoryObject(Domain)

            'Add the user to the group via the invoke method
            oGroup.Invoke("Remove", New Object() {oUser.Path.ToString()})

            oGroup.Close()
            oUser.Close()
        End Sub

        ''' <summary>
        ''' This method will not actually log a user in, but will perform tests to ensure
        ''' that the user account exists (matched by both the username and password), and also
        ''' checks if the account is active.
        ''' </summary>
        ''' <param name="UserName"></param>
        ''' <param name="Password"></param>
        ''' <returns></returns>
        Public Shared Function Login(ByVal UserName As String, ByVal Password As String) As ADWrapper.LoginResult
            'first, check if the logon exists based on the username and password
            If IsUserValid(UserName, Password) Then
                Dim dirEntry As DirectoryEntry = GetUser(UserName)
                If Not dirEntry Is Nothing Then
                    'convert the accountControl value so that a logical operation can be performed
                    'to check of the Disabled option exists.
                    Dim accountControl As Integer = Convert.ToInt32(dirEntry.Properties("userAccountControl")(0))
                    dirEntry.Close()

                    'if the disabled item does not exist then the account is active
                    If Not IsAccountActive(accountControl) Then
                        Return LoginResult.LOGIN_USER_ACCOUNT_INACTIVE
                    Else
                        Return LoginResult.LOGIN_OK

                    End If
                Else
                    Return LoginResult.LOGIN_USER_DOESNT_EXIST
                End If
            Else
                Return LoginResult.LOGIN_USER_DOESNT_EXIST
            End If
        End Function

        ''' <summary>
        ''' This method will attempt to log in a user based on the username and password
        ''' to ensure that they have been set up within the Active Directory.  This is the basic UserName, Password
        ''' check.
        ''' </summary>
        ''' <param name="UserName"></param>
        ''' <param name="Password"></param>
        ''' <returns></returns>
        Public Shared Function IsUserValid(ByVal UserName As String, ByVal Password As String) As Boolean
            Try
                'if the object can be created then return true
                Dim dirUser As DirectoryEntry = GetUser(UserName, Password)
                dirUser.Close()
                Return True
            Catch generatedExceptionName As Exception
                'otherwise return false
                Return False
            End Try
        End Function

        ''' <summary>
        ''' This method will return all users for the specified group in a dataset
        ''' </summary>
        ''' <param name="GroupName"></param>
        ''' <returns></returns>
        Public Shared Function GetUsersinGroup(ByVal GroupName As String) As DataSet
            Dim dsUsers As New DataSet()
            Dim dirEntry As DirectoryEntry = GetDirectoryObject()

            'create instance fo the direcory searcher
            Dim dirSearch As New DirectorySearcher()

            'set the search filter
            dirSearch.SearchRoot = dirEntry
            'deSearch.PropertiesToLoad.Add("cn");
            dirSearch.Filter = "(&(objectClass=group)(cn=" + GroupName + "))"

            'get the group result
            Dim searchResults As SearchResult = dirSearch.FindOne()

            'Create a new table object within the dataset
            Dim dtUser As DataTable = dsUsers.Tables.Add("Users")
            dtUser.Columns.Add("UserName")
            dtUser.Columns.Add("DisplayName")
            dtUser.Columns.Add("EMailAddress")

            'Create default row
            Dim drUser As DataRow = dtUser.NewRow()
            drUser("UserName") = "0"
            drUser("DisplayName") = "(Not Specified)"
            drUser("EMailAddress") = "(Not Specified)"
            dtUser.Rows.Add(drUser)

            'if the group is valid, then continue, otherwise return a blank dataset
            If Not searchResults Is Nothing Then
                'create a link to the group object, so we can get the list of members
                'within the group
                Dim dirGroup As New DirectoryEntry(searchResults.Path, ADAdminUser, ADAdminPassword, AuthenticationTypes.Secure)
                'assign a property collection
                Dim propCollection As PropertyCollection = dirGroup.Properties
                Dim n As Integer = propCollection("member").Count
                For l As Integer = 0 To n - 1

                    'if there are members fo the group, then get the details and assign to the table
                    'create a link to the user object sot hat the FirstName, LastName and SUername can be gotten
                    Dim deUser As New DirectoryEntry(ADFullPath + "/" + propCollection("member")(l).ToString(), ADAdminUser, ADAdminPassword, AuthenticationTypes.Secure)

                    'set a new empty row
                    Dim rwUser As DataRow = dtUser.NewRow()

                    'populate the column
                    rwUser("UserName") = GetProperty(deUser, "cn")
                    rwUser("DisplayName") = GetProperty(deUser, "givenName") + " " + GetProperty(deUser, "sn")
                    rwUser("EMailAddress") = GetProperty(deUser, "mail")
                    'append the row to the table of the dataset
                    dtUser.Rows.Add(rwUser)

                    'close the directory entry object

                    deUser.Close()
                Next
                dirEntry.Close()
                dirGroup.Close()
            End If


            Return dsUsers
        End Function

        ''' <summary>
        ''' This method will query all of the defined AD groups
        ''' and will turn the results into a dataset to be returned
        ''' </summary>
        ''' <returns></returns>
        Public Shared Function GetAllGroups() As DataSet
            Dim dsGroup As New DataSet()
            Dim dirEntry As DirectoryEntry = GetDirectoryObject()

            'create instance fo the direcory searcher
            Dim dirSearch As New DirectorySearcher()

            'set the search filter
            dirSearch.SearchRoot = dirEntry
            'deSearch.PropertiesToLoad.Add("cn");
            dirSearch.Filter = "(&(objectClass=group)(cn=CS_*))"

            'find the first instance
            Dim searchResults As SearchResultCollection = dirSearch.FindAll()

            'Create a new table object within the dataset
            Dim dtGroup As DataTable = dsGroup.Tables.Add("Groups")
            dtGroup.Columns.Add("GroupName")

            'if there are results (there should be some!!), then convert the results
            'into a dataset to be returned.
            If searchResults.Count > 0 Then

                'iterate through collection and populate the table with
                'the Group Name
                For Each Result As SearchResult In searchResults
                    'set a new empty row
                    Dim drGroup As DataRow = dtGroup.NewRow()

                    'populate the column
                    drGroup("GroupName") = Result.Properties("cn")(0)

                    'append the row to the table of the dataset
                    dtGroup.Rows.Add(drGroup)
                Next
            End If
            Return dsGroup
        End Function

#Region " GetUser Methods "
        ''' <summary>
        ''' This will return a DirectoryEntry object if the user does exist
        ''' </summary>
        ''' <param name="UserName"></param>
        ''' <returns></returns>
        Public Shared Function GetUser(ByVal UserName As String) As DirectoryEntry
            'create an instance of the DirectoryEntry
            Dim dirEntry As DirectoryEntry = GetDirectoryObject("/" + GetLDAPDomain())

            'create instance fo the direcory searcher
            Dim dirSearch As New DirectorySearcher(dirEntry)

            dirSearch.SearchRoot = dirEntry
            'set the search filter
            dirSearch.Filter = "(&(objectCategory=user)(cn=" + UserName + "))"
            'deSearch.SearchScope = SearchScope.Subtree;

            'find the first instance
            Dim searchResults As SearchResult = dirSearch.FindOne()

            'if found then return, otherwise return Null
            If Not searchResults Is Nothing Then
                'de= new DirectoryEntry(results.Path,ADAdminUser,ADAdminPassword,AuthenticationTypes.Secure);
                'if so then return the DirectoryEntry object
                Return searchResults.GetDirectoryEntry()
            Else
                Return Nothing
            End If
        End Function

        ''' <summary>
        ''' Override method which will perfrom query based on combination of username and password
        ''' This is used with the login process to validate the user credentials and return a user
        ''' object for further validation.  This is slightly different from the other GetUser... methods as this
        ''' will use the UserName and Password supplied as the authentication to check if the user exists, if so then
        ''' the users object will be queried using these credentials.s
        ''' </summary>
        ''' <param name="UserName"></param>
        ''' <param name="password"></param>
        ''' <returns></returns>
        Public Shared Function GetUser(ByVal UserName As String, ByVal Password As String) As DirectoryEntry
            'create an instance of the DirectoryEntry
            Dim dirEntry As DirectoryEntry = GetDirectoryObject(UserName, Password)

            'create instance fo the direcory searcher
            Dim dirSearch As New DirectorySearcher()

            dirSearch.SearchRoot = dirEntry
            'set the search filter
            dirSearch.Filter = "(&(objectClass=user)(cn=" + UserName + "))"
            dirSearch.SearchScope = SearchScope.Subtree

            'set the property to return
            'deSearch.PropertiesToLoad.Add("givenName");

            'find the first instance
            Dim searchResults As SearchResult = dirSearch.FindOne()

            'if a match is found, then create directiry object and return, otherwise return Null
            If Not searchResults Is Nothing Then
                'create the user object based on the admin priv.
                dirEntry = New DirectoryEntry(searchResults.Path, ADAdminUser, ADAdminPassword, AuthenticationTypes.Secure)
                Return dirEntry
            Else
                Return Nothing
            End If
        End Function
#End Region

#Region " Helpers "
        ''' <summary>
        ''' This is an internal method for retreiving a new directoryentry object
        ''' </summary>
        ''' <returns></returns>
        Private Shared Function GetDirectoryObject() As DirectoryEntry
            Dim oDE As DirectoryEntry

            oDE = New DirectoryEntry(ADFullPath, ADAdminUser, ADAdminPassword, AuthenticationTypes.Secure)

            Return oDE
        End Function

        ''' <summary>
        ''' Override function that that will attempt a logon based on the users credentials
        ''' </summary>
        ''' <param name="UserName"></param>
        ''' <param name="Password"></param>
        ''' <returns></returns>
        Private Shared Function GetDirectoryObject(ByVal UserName As String, ByVal Password As String) As DirectoryEntry
            Dim oDE As DirectoryEntry

            oDE = New DirectoryEntry(ADFullPath, UserName, Password, AuthenticationTypes.Secure)

            Return oDE
        End Function

        ''' <summary>
        ''' This will create the directory entry based on the domain object to return
        ''' The DomainReference will contain the qualified syntax for returning an entry
        ''' at the location rather than returning the root.  
        ''' i.e. /CN=Users,DC=creditsights, DC=cyberelves, DC=Com
        ''' </summary>
        ''' <param name="DomainReference"></param>
        ''' <returns></returns>
        Private Shared Function GetDirectoryObject(ByVal DomainReference As String) As DirectoryEntry
            Dim oDE As DirectoryEntry

            oDE = New DirectoryEntry(ADFullPath + DomainReference, ADAdminUser, ADAdminPassword, AuthenticationTypes.Secure)

            Return oDE
        End Function

        ''' <summary>
        ''' Addition override that will allow ovject to be created based on the users credentials.
        ''' This is useful for instances such as setting password etc.
        ''' </summary>
        ''' <param name="DomainReference"></param>
        ''' <param name="UserName"></param>
        ''' <param name="Password"></param>
        ''' <returns></returns>
        Private Shared Function GetDirectoryObject(ByVal DomainReference As String, ByVal UserName As String, ByVal Password As String) As DirectoryEntry
            Dim oDE As DirectoryEntry

            oDE = New DirectoryEntry(ADFullPath + DomainReference, UserName, Password, AuthenticationTypes.Secure)

            Return oDE
        End Function


        ''' <summary>
        ''' This will read in the ADServer value from the web.config and will return it
        ''' as an LDAP path ie DC=creditsights, DC=cyberelves, DC=com.
        ''' This is required when creating directoryentry other than the root.
        ''' </summary>
        ''' <returns></returns>
        Private Shared Function GetLDAPDomain() As String

            Dim LDAPDomain As New Text.StringBuilder()
            Dim LDAPDC As String() = ADServer.Split("."c)
            For i As Integer = 0 To LDAPDC.GetUpperBound(0)

                LDAPDomain.Append("DC=" + LDAPDC(i))
                If i < LDAPDC.GetUpperBound(0) Then
                    LDAPDomain.Append(",")
                End If
            Next

            Return LDAPDomain.ToString()
        End Function

        ''' <summary>
        ''' This will retreive the specified poperty value from the DirectoryEntry object (if the property exists)
        ''' </summary>
        ''' <param name="oDE"></param>
        ''' <param name="PropertyName"></param>
        ''' <returns></returns>
        Public Shared Function GetProperty(ByVal oDE As DirectoryEntry, ByVal PropertyName As String) As String
            If oDE.Properties.Contains(PropertyName) Then
                Return oDE.Properties(PropertyName)(0).ToString()
            Else
                Return String.Empty
            End If
        End Function

        ''' <summary>
        ''' This is an override that will allow a property to be extracted directly from
        ''' a searchresult object
        ''' </summary>
        ''' <param name="searchResult"></param>
        ''' <param name="PropertyName"></param>
        ''' <returns></returns>
        Public Shared Function GetProperty(ByVal searchResult As SearchResult, ByVal PropertyName As String) As String
            If searchResult.Properties.Contains(PropertyName) Then
                Return searchResult.Properties(PropertyName)(0).ToString()
            Else
                Return String.Empty
            End If
        End Function
#End Region
    End Class
End Namespace
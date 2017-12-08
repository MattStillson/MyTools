USE ACCTMGMT;

DROP TABLE IF EXISTS [master_list], [campusVueImport], [active_directory], [i3users], [inow];

CREATE TABLE master_list( /** data needs to be moved from temporal to full data set. **/
	Ticket INT IDENTITY,
	HireType CHAR(10),
	Template CHAR(10),
	Paths CHAR(60),
	StartDate DATE,
	UserName CHAR(15),
	FirstName CHAR(10),
	LastName CHAR(10),
	DisplayName CHAR(15),
	Extension CHAR(6),
	Telephone CHAR(10),
	Title CHAR(15),
	Department CHAR(20),
	Email CHAR(25),
	City CHAR(10),
	States CHAR(2),
	Campus CHAR(10),
	SystaffID CHAR(6),
	NetworkID CHAR(19),
	MailBox CHAR(20),
	Roles CHAR(15),
	WorkGroups CHAR(65)
);

CREATE TABLE master_list_archive( /** full data set. **/
	Ticket INT IDENTITY,
	HireType CHAR(10),
	Template CHAR(10),
	Paths CHAR(60),
	StartDate DATE,
	UserName CHAR(15),
	FirstName CHAR(10),
	LastName CHAR(10),
	DisplayName CHAR(15),
	Extension CHAR(6),
	Telephone CHAR(10),
	Title CHAR(15),
	Department CHAR(20),
	Email CHAR(25),
	City CHAR(10),
	States CHAR(10),
	Campus CHAR(10),
	SystaffID CHAR(6),
	NetworkID CHAR(19),
	MailBox CHAR(20),
	Roles CHAR(15),
	WorkGroups CHAR(65)
);

CREATE TABLE cvue_import( /** get data from export from cvue **/
	FirstName CHAR(10),
	LastName CHAR(10),
	Code CHAR(25),
	SyStaffID CHAR(10),
	DateAdded CHAR(10),
	Email CHAR(25),
	Active CHAR(10),
	Locked CHAR(10),
	ActivityPolicyName CHAR(10),
	DocumentPolicyName CHAR(10),
	CampusGroup CHAR(10),
	BlackBoard CHAR(10)
);

CREATE TABLE active_directory( /** create table from master list temporal table **/
	Template CHAR(10),
	Paths CHAR(60),
	Startdate CHAR(10),
	Username CHAR(10),
	FirstName CHAR(10),
	LastName CHAR(10),
	Passwords CHAR(10),
	Title CHAR(10),
	Department CHAR(10),
	Email CHAR(10),
	City CHAR(10),
	States CHAR(10),
	Campus CHAR(10)
);

CREATE TABLE i3users( /** create table from master list temporal table **/
	Username CHAR(10),
	FirstName CHAR(10),
	LastName CHAR(10),
	DisplayName CHAR(10),
	NetworkID CHAR(10),
	Extension CHAR(10),
	DID CHAR(10),
	MailBox CHAR(10),
	Roles CHAR(10),
	Workgroups CHAR(10),
	Passwords CHAR(10)
);

CREATE TABLE inow( /** create table from master list temporal table **/
	Username CHAR(10),
	Prefix CHAR(10),
	FirstName CHAR(10),
	LastName CHAR(10),
	Title CHAR(10),
	Locality CHAR(10),
	Organizationalunit CHAR(10),
	Oraganization CHAR(10),
	Email CHAR(10),
	Phone CHAR(10),
	Mobile CHAR(10),
	Fax CHAR(10),
	Pager CHAR(10)
);

$PBExportHeader$n_cst_platform_privileges.sru
forward
global type n_cst_platform_privileges from nonvisualobject
end type
type shellexecuteinfo from structure within n_cst_platform_privileges
end type
type sididentifierauthority from structure within n_cst_platform_privileges
end type
type tokenelevation from structure within n_cst_platform_privileges
end type
type sidandattributes from structure within n_cst_platform_privileges
end type
type tokenmandatorylabel from structure within n_cst_platform_privileges
end type
type longreturn from structure within n_cst_platform_privileges
end type
end forward

type shellexecuteinfo from structure
	long		cbsize
	long		fmask
	long		hwnd
	string		lpverb
	string		lpfile
	string		lpparameters
	string		lpdirectory
	long		nshow
	long		hinstapp
	long		lpidlist
	string		lpclass
	long		hkeyclass
	long		dwhotkey
	long		hicon
	long		hprocess
end type

type sididentifierauthority from structure
	byte		value[]
end type

type tokenelevation from structure
	long		tokeniselevated
end type

type sidandattributes from structure
	unsignedlong		sid
	unsignedlong		attributes
end type

type tokenmandatorylabel from structure
	sidandattributes		label
end type

type longreturn from structure
	long		returnvalue
end type

global type n_cst_platform_privileges from nonvisualobject
end type
global n_cst_platform_privileges n_cst_platform_privileges

type prototypes
function boolean IsUserAnAdmin ( ) library "shell32.dll"
function ulong GetModuleFileName (ulong hinstModule, ref string lpszPath, ulong cchPath ) library "KERNEL32.DLL" alias for "GetModuleFileNameW"
function long ShellExecuteEx(ref shellexecuteinfo lpExecInfo) library "shell32.dll" alias for "ShellExecuteExW"
function long GetLastError() library "kernel32" alias for "GetLastError"

// Handle this call with Byte array or pointer
function boolean CheckTokenMembership(ulong TokenHandle, ulong SidToCheck, ref boolean IsMember) library "advapi32.dll"
function boolean CheckTokenMembership(ulong TokenHandle, byte SidToCheck[], ref boolean IsMember) library "advapi32.dll"

function ulong AllocateAndInitializeSid(sididentifierauthority pIdentifierAuthority, long nSubAuthorityCount, ulong nSubAuthority0, ulong nSubAuthority1, ulong nSubAuthority2, ulong nSubAuthority3, ulong nSubAuthority4, ulong nSubAuthority5, ulong nSubAuthority6, ulong nSubAuthority7, ref ulong lpPSid) LIBRARY "advapi32.dll"
subroutine FreeSid (ulong pSid ) LIBRARY "advapi32.dll"
function long OpenProcessToken (long ProcessHandle, long DesiredAccess, ref long TokenHandle) Library "advapi32.dll"
function long GetCurrentProcess () Library "kernel32"

// GetTokenInformation could have different argument types 
function boolean GetTokenElevation(long TokenHandle,long TokenInformationClass,ref tokenelevation tTokenInformation,ulong TokenInformationLength, ref ulong ReturnLength) library "advapi32.dll" alias for "GetTokenInformation";
function boolean GetTokenElevationType(long TokenHandle,long TokenInformationClass,ref long tElevationType,ulong TokenInformationLength, ref ulong ReturnLength) library "advapi32.dll" alias for "GetTokenInformation";
function boolean GetTokenLinkedToken(long TokenHandle,long TokenInformationClass,ref long tTokenHandle,ulong TokenInformationLength, ref ulong ReturnLength) library "advapi32.dll" alias for "GetTokenInformation";
function boolean GetTokenIntegrityLevel(long TokenHandle,long TokenInformationClass,ref tokenmandatorylabel tLabel,ulong TokenInformationLength, ref ulong ReturnLength) library "advapi32.dll" alias for "GetTokenInformation";

function ulong DuplicateToken(long TokenHandle,long ImpersonationLevel,ref long DuplicateTokenHandle) LIBRARY "advapi32.dll"
function boolean CreateWellKnownSid(long WellKnownSidType, long DomainSid, ref byte pSid[],ref ulong cbSid) library "advapi32.dll"
function ulong GetSidSubAuthority(ulong sid, ulong subAuthorityIndex) library "advapi32.dll"
subroutine CopyMemoryLong (ref ulong destination, long source, ulong size) LIBRARY "kernel32" ALIAS FOR "RtlMoveMemory"
Function long LocalFree (long MemHandle) library "kernel32.dll"


end prototypes

type variables
protected:

// http://www.pinvoke.net/default.aspx/user32/ShowState.html
constant long SW_NORMAL = 1

// http://www.pinvoke.net/default.aspx/Constants/WINERROR.html
constant long ERROR_CANCELLED = 1223;

// http://www.pinvoke.net/default.aspx/advapi32/AllocateAndInitializeSid.html
constant long NtSecurityAuthority = 5;
constant long BuiltInDomainRid = 32
constant long DomainAliasRidAdmins = 544
constant long AuthenticatedUser = 11;

// http://www.pinvoke.net/default.aspx/Constants/WINNT.html
constant ulong TOKEN_DUPLICATE = 2;
constant ulong TOKEN_QUERY = 8;

// http://www.pinvoke.net/default.aspx/Enums/TOKEN_INFORMATION_CLASS.html
constant long TokenElevationType = 18
constant long TokenLinkedToken = 19
constant long TokenElevation = 20
constant long TokenIntegrityLevel = 25

// http://www.pinvoke.net/default.aspx/Enums/TOKEN_ELEVATION_TYPE.html
constant long TokenElevationTypeDefault = 1
constant long TokenElevationTypeFull = 2
constant long TokenElevationTypeLimited = 3

// http://www.pinvoke.net/default.aspx/Enums/SECURITY_IMPERSONATION_LEVEL.html
constant long SecurityAnonymous = 0
constant long SecurityIdentification = 1
constant long SecurityImpersonation = 2
constant long SecurityDelegation = 3

// http://www.pinvoke.net/default.aspx/Enums/WELL_KNOWN_SID_TYPE.html
constant long WinBuiltinAdministratorsSid = 26

// http://www.pinvoke.net/default.aspx/Constants/SECURITY_MANDATORY.html
constant long SECURITY_MANDATORY_UNTRUSTED_RID = 0;
constant long SECURITY_MANDATORY_LOW_RID = 4096;
constant long SECURITY_MANDATORY_MEDIUM_RID = 8192;
constant long SECURITY_MANDATORY_HIGH_RID = 12288;
constant long SECURITY_MANDATORY_SYSTEM_RID = 16384;
 
end variables

forward prototypes
protected function string of_getcurrentexe ()
public function boolean of_isuserinadmingroup ()
public function boolean of_isrunasadmin ()
public function boolean of_isprocesselevated ()
public function boolean of_isuseranadmin ()
public function long of_runwithhighprivileges (string as_path)
public function long of_selfelevation ()
public function string of_getprocessintegritylevel ()
end prototypes

protected function string of_getcurrentexe ();//====================================================================
// Function: n_cst_platform_privileges.of_getcurrentexe()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  string
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2023/03/14
//--------------------------------------------------------------------
// Usage: n_cst_platform_privileges.of_getcurrentexe ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================


ClassDefinition  lcd

String ls_fullpath
ULong lul_handle, lul_length = 512

If Handle(GetApplication()) = 0 Then
	// running from the IDE
	lcd = GetApplication().ClassDefinition
	ls_fullpath = lcd.LibraryName
Else
	// running from EXE
	lul_handle = Handle( GetApplication() )
	ls_fullpath = Space(lul_length)
	GetModuleFilename( lul_handle, ls_fullpath, lul_length )
End If

Return ls_fullpath

end function

public function boolean of_isuserinadmingroup ();//====================================================================
// Function: n_cst_platform_privileges.of_isuserinadmingroup()
//--------------------------------------------------------------------
// Description: Checks if the current user is in admin group
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  boolean NULL if an error occured
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2023/03/14
//--------------------------------------------------------------------
// Usage: n_cst_platform_privileges.of_isuserinadmingroup ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================


Long			ll_process, ll_token, ll_tokenType, ll_tokenChecked, lul_tokenToCheck, ll_duplicatedToken, ll_null
ULong			lul_elevationTypeSize, lul_size = 4, lul_plinkedSize, lul_sidSize = 68
Boolean		lb_isInGroup, lb_null
byte			lbta_adminsid[]
environment	lnv_environment

SetNull(lb_null)
SetNull(ll_null)

If GetEnvironment(Ref lnv_environment) < 0 Then
	Return lb_null
End If

ll_process = GetCurrentProcess()
If OpenProcessToken(ll_process, TOKEN_QUERY + TOKEN_DUPLICATE, Ref ll_token) < 0 Then
	Return lb_null
End If

If lnv_environment.OSMajorRevision >= 6 Then
	If Not GetTokenElevationType(ll_token, TokenElevationType, Ref ll_tokenType, lul_size, Ref lul_elevationTypeSize) Then
		Return lb_null
	End If
	
	If ll_tokenType = TokenElevationTypeLimited Then
		If Not GetTokenLinkedToken(ll_token, TokenLinkedToken, Ref lul_tokenToCheck, lul_size, Ref lul_plinkedSize) Then
			Return lb_null
		End If
	End If
End If

If lul_tokenToCheck = 0 Then
	DuplicateToken(ll_token, SecurityIdentification, Ref lul_tokenToCheck)
End If

lbta_adminsid[lul_sidSize] = 0

If Not CreateWellKnownSid(WinBuiltinAdministratorsSid, ll_null, Ref lbta_adminsid, Ref lul_sidSize) Then
	Return lb_null
End If

If Not CheckTokenMembership(lul_tokenToCheck, lbta_adminsid, Ref lb_isInGroup) Then
	Return lb_null
End If

Return lb_isInGroup = True

end function

public function boolean of_isrunasadmin ();//====================================================================
// Function: n_cst_platform_privileges.of_isrunasadmin()
//--------------------------------------------------------------------
// Description: Checks if the application was started by "Run as Admin"
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  boolean NULL if an error occured
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2023/03/14
//--------------------------------------------------------------------
// Usage: n_cst_platform_privileges.of_isrunasadmin ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================


ULong							lul_AuthenticatedUsersSid
ULong							lul_handle
Boolean						lb_runAsAdmin, lb_null
sididentifierauthority 	lstr_ntAuhtority

SetNull(lb_null)

lstr_ntAuhtority.Value[1] = 0
lstr_ntAuhtority.Value[2] = 0
lstr_ntAuhtority.Value[3] = 0
lstr_ntAuhtority.Value[4] = 0
lstr_ntAuhtority.Value[5] = 0
lstr_ntAuhtority.Value[6] = NtSecurityAuthority

lul_AuthenticatedUsersSid = 0

AllocateAndInitializeSid(Ref lstr_ntAuhtority, 2, BuiltInDomainRid, DomainAliasRidAdmins, 0, 0, 0, 0, 0, 0, Ref lul_AuthenticatedUsersSid)

SetNull(lul_handle)

If Not CheckTokenMembership(lul_handle, lul_AuthenticatedUsersSid, Ref lb_runAsAdmin) Then
	Return lb_null
End If

FreeSid(lul_AuthenticatedUsersSid)

Return lb_runAsAdmin = True

end function

public function boolean of_isprocesselevated ();//====================================================================
// Function: n_cst_platform_privileges.of_isprocesselevated()
//--------------------------------------------------------------------
// Description: Checks if the process was elevated
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  boolean NULL if an error occured
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2023/03/14
//--------------------------------------------------------------------
// Usage: n_cst_platform_privileges.of_isprocesselevated ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Long				ll_process, ll_token
ULong				lul_tokenElevationSize = 4, lul_size
Boolean 			lb_null
tokenelevation	lstr_tokenelevation

SetNull(lb_null)

ll_process = GetCurrentProcess ( )
If OpenProcessToken(ll_process, TOKEN_QUERY, Ref ll_token) < 0 Then
	Return lb_null
End If

If Not GetTokenElevation(ll_token, tokenelevation, Ref lstr_tokenelevation, lul_tokenElevationSize, Ref lul_size) Then
	Return lb_null
End If

Return lstr_tokenelevation.TokenIsElevated = 1

end function

public function boolean of_isuseranadmin ();//====================================================================
// Function: n_cst_platform_privileges.of_isuseranadmin()
//--------------------------------------------------------------------
// Description: This is a simple wrapper method to check if the application runs as admin
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  boolean
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2023/03/14
//--------------------------------------------------------------------
// Usage: n_cst_platform_privileges.of_isuseranadmin ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

return IsUserAnAdmin ( )
end function

public function long of_runwithhighprivileges (string as_path);//====================================================================
// Function: n_cst_platform_privileges.of_runwithhighprivileges()
//--------------------------------------------------------------------
// Description: Checks if the current user is in admin group
//--------------------------------------------------------------------
// Arguments:
// 	string	as_path	
//--------------------------------------------------------------------
// Returns:  long
//		0  = Is already elevated
//		-1	= Unknown error
//		-2 = Canceled by user
//		1 = OK
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2023/03/14
//--------------------------------------------------------------------
// Usage: n_cst_platform_privileges.of_runwithhighprivileges ( string as_path )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================


shellexecuteinfo lstr_shellexecuteinfo

If This.of_isRunAsAdmin() Then
	Return 0
End If

lstr_shellexecuteinfo.cbsize = 60
lstr_shellexecuteinfo.lpVerb = "runas"
lstr_shellexecuteinfo.lpFile = as_path
lstr_shellexecuteinfo.hwnd = Handle(This)
lstr_shellexecuteinfo.nShow = SW_NORMAL

If ShellExecuteEx(Ref lstr_shellexecuteinfo) <> 1 Then
	If GetLastError() = ERROR_CANCELLED Then
		Return -2
	Else
		Return -1
	End If
End If

Return 1

end function

public function long of_selfelevation ();//====================================================================
// Function: n_cst_platform_privileges.of_selfelevation()
//--------------------------------------------------------------------
// Description: Run current EXE with High Privileges
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  long
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2023/03/14
//--------------------------------------------------------------------
// Usage: n_cst_platform_privileges.of_selfelevation ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Return of_runWithHighPrivileges(of_getCurrentExe ( ) )


end function

public function string of_getprocessintegritylevel ();//====================================================================
// Function: n_cst_platform_privileges.of_getprocessintegritylevel()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  string 
//		untrusted
//		low
//		medium
//		high
//		system
//		unknown
//		OR null if an error occured
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2023/03/14
//--------------------------------------------------------------------
// Usage: n_cst_platform_privileges.of_getprocessintegritylevel ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================


String					ls_null
Long 						ll_process, ll_token
ULong						lul_level
ULong 					lul_size = 0, lul_integritySize = 72, lul_sidSize = 68, lul_zero = 0, lul_levelSize = 4
ULong						lul_levelPointer, lul_labelPtr, lul_cbSize
tokenmandatorylabel	lstr_label, lstr_empty

SetNull(ls_null)

ll_process = GetCurrentProcess ( )
If OpenProcessToken(ll_process, TOKEN_QUERY, Ref ll_token) < 0 Then
	Return ls_null
End If

// Initialize Structure
lstr_label.Label.sid = 0
lstr_label.Label.attributes = 0

If GetTokenIntegrityLevel(ll_token, TokenIntegrityLevel, Ref lstr_label, lul_integritySize, Ref lul_cbSize) = False Then
	LocalFree(ll_token)
	Return ls_null
End If

lul_levelPointer = GetSidSubAuthority(lstr_label.Label.sid, 0)
CopyMemoryLong(Ref lul_level, lul_levelPointer, 4)

LocalFree(ll_token)

Choose Case lul_level
	Case SECURITY_MANDATORY_UNTRUSTED_RID
		Return "untrusted"
	Case SECURITY_MANDATORY_LOW_RID
		Return "low"
	Case SECURITY_MANDATORY_MEDIUM_RID
		Return "medium"
	Case SECURITY_MANDATORY_HIGH_RID
		Return "high"
	Case SECURITY_MANDATORY_SYSTEM_RID
		Return "system"
End Choose

Return "unknown"

end function

on n_cst_platform_privileges.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_platform_privileges.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on


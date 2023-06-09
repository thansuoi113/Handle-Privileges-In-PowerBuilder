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
Function Boolean IsUserAnAdmin ( ) Library "shell32.dll"
Function ULong GetModuleFileName (ULong hinstModule, Ref String lpszPath, ULong cchPath ) Library "KERNEL32.DLL" Alias For "GetModuleFileNameW"
Function Long ShellExecuteEx(Ref shellexecuteinfo lpExecInfo) Library "shell32.dll" Alias For "ShellExecuteExW"
Function Long GetLastError() Library "kernel32" Alias For "GetLastError"

// Handle this call with Byte array or pointer
Function Boolean CheckTokenMembership(ULong TokenHandle, ULong SidToCheck, Ref Boolean IsMember) Library "advapi32.dll"
Function Boolean CheckTokenMembership(ULong TokenHandle, byte SidToCheck[], Ref Boolean IsMember) Library "advapi32.dll"

Function ULong AllocateAndInitializeSid(sididentifierauthority pIdentifierAuthority, Long nSubAuthorityCount, ULong nSubAuthority0, ULong nSubAuthority1, ULong nSubAuthority2, ULong nSubAuthority3, ULong nSubAuthority4, ULong nSubAuthority5, ULong nSubAuthority6, ULong nSubAuthority7, Ref ULong lpPSid) Library "advapi32.dll"
Subroutine FreeSid (ULong pSid ) Library "advapi32.dll"
Function Long OpenProcessToken (Long ProcessHandle, Long DesiredAccess, Ref Long TokenHandle) Library "advapi32.dll"
Function Long GetCurrentProcess () Library "kernel32"

// GetTokenInformation could have different argument types 
Function Boolean GetTokenElevation(Long TokenHandle,Long TokenInformationClass,Ref tokenelevation tTokenInformation,ULong TokenInformationLength, Ref ULong ReturnLength) Library "advapi32.dll" Alias For "GetTokenInformation";
Function Boolean GetTokenElevationType(Long TokenHandle,Long TokenInformationClass,Ref Long tElevationType,ULong TokenInformationLength, Ref ULong ReturnLength) Library "advapi32.dll" Alias For "GetTokenInformation";
Function Boolean GetTokenLinkedToken(Long TokenHandle,Long TokenInformationClass,Ref Long tTokenHandle,ULong TokenInformationLength, Ref ULong ReturnLength) Library "advapi32.dll" Alias For "GetTokenInformation";
Function Boolean GetTokenIntegrityLevel(Long TokenHandle,Long TokenInformationClass,Ref tokenmandatorylabel tLabel,ULong TokenInformationLength, Ref ULong ReturnLength) Library "advapi32.dll" Alias For "GetTokenInformation";

Function ULong DuplicateToken(Long TokenHandle,Long ImpersonationLevel,Ref Long DuplicateTokenHandle) Library "advapi32.dll"
Function Boolean CreateWellKnownSid(Long WellKnownSidType, Long DomainSid, Ref byte pSid[],Ref ULong cbSid) Library "advapi32.dll"
Function ULong GetSidSubAuthority(ULong sid, ULong subAuthorityIndex) Library "advapi32.dll"
Subroutine CopyMemoryLong (Ref ULong destination, Long Source, ULong size) Library "kernel32" Alias For "RtlMoveMemory"
Function Long LocalFree (Long MemHandle) Library "kernel32.dll"



end prototypes
type variables
Protected:

// http: //www.pinvoke.net/default.aspx/user32/ShowState.html
Constant Long SW_NORMAL = 1

// http: //www.pinvoke.net/default.aspx/Constants/WINERROR.html
Constant Long ERROR_CANCELLED = 1223;

// http: //www.pinvoke.net/default.aspx/advapi32/AllocateAndInitializeSid.html
Constant Long NtSecurityAuthority = 5;
Constant Long BuiltInDomainRid = 32
Constant Long DomainAliasRidAdmins = 544
Constant Long AuthenticatedUser = 11;

// http: //www.pinvoke.net/default.aspx/Constants/WINNT.html
Constant ULong TOKEN_DUPLICATE = 2;
Constant ULong TOKEN_QUERY = 8;

// http: //www.pinvoke.net/default.aspx/Enums/TOKEN_INFORMATION_CLASS.html
Constant Long TokenElevationType = 18
Constant Long TokenLinkedToken = 19
Constant Long TokenElevation = 20
Constant Long TokenIntegrityLevel = 25

// http: //www.pinvoke.net/default.aspx/Enums/TOKEN_ELEVATION_TYPE.html
Constant Long TokenElevationTypeDefault = 1
Constant Long TokenElevationTypeFull = 2
Constant Long TokenElevationTypeLimited = 3

// http: //www.pinvoke.net/default.aspx/Enums/SECURITY_IMPERSONATION_LEVEL.html
Constant Long SecurityAnonymous = 0
Constant Long SecurityIdentification = 1
Constant Long SecurityImpersonation = 2
Constant Long SecurityDelegation = 3

// http: //www.pinvoke.net/default.aspx/Enums/WELL_KNOWN_SID_TYPE.html
Constant Long WinBuiltinAdministratorsSid = 26

// http: //www.pinvoke.net/default.aspx/Constants/SECURITY_MANDATORY.html
Constant Long SECURITY_MANDATORY_UNTRUSTED_RID = 0;
Constant Long SECURITY_MANDATORY_LOW_RID = 4096;
Constant Long SECURITY_MANDATORY_MEDIUM_RID = 8192;
Constant Long SECURITY_MANDATORY_HIGH_RID = 12288;
Constant Long SECURITY_MANDATORY_SYSTEM_RID = 16384;


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


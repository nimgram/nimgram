
//@description An object of this type can be returned on every function call, in case of an error
//@code Error code
//@message Error message
error code:int32 message:string = Error;

//@description An object of this type is returned on a successful function call for certain functions
ok = Ok;

//@class AuthorizationState @description Current authorization status of the client

//@description The client has not been initialized yet with the function initializeNimgram
authorizationStateUninitialized = AuthorizationState;

//@description The client has been initialized, but not authenticated
authorizationStateWaitAuthentication = AuthorizationState;

//@description The client has been authenticated and can now send requests
authorizationStateReady = AuthorizationState;

//@description The user is currently logging out
authorizationStateLoggingOut = AuthorizationState;

//@description The client is now closing and won't accept any function call after that
authorizationStateClosing = AuthorizationState; 

//@description The client is closed and will refuse any function call
authorizationStateClosed = AuthorizationState;

//@class Update @description Object containing an update about data changes

//@description Update containing the new authorization state @authorization_state New authorization state
updateAuthorizationState authorization_state:AuthorizationState = Update;

---functions---

//@description initialize Nimgram with the specified parameters
//@use_test_dc Whether to use test servers, this parameter does not apply if a session has been registered previously
//@database_filename Name of the file where the sessions will be stored
//@api_id Application identifier for Telegram API access, which can be obtained at https://my.telegram.org
//@api_hash Application identifier hash for Telegram API access, which can be obtained at https://my.telegram.org
//@system_language_code IETF language tag of the user's operating system language; must be non-empty
//@device_model Model of the device the application is being run on; must be non-empty
//@system_version Version of the operating system the application is being run on
//@application_version Application version; must be non-empty
initializeNimgram use_test_dc:Bool database_filename:string api_id:int32 api_hash:string system_language_code:string device_model:string system_version:string application_version:string = Ok;


//@description Get the current authorization state
getAuthorizationState = AuthorizationState;

//@description Login as a bot. Works only when the current authorization state is authorizationStateWaitPhoneNumber.
//@token The bot token
botLogin token:string = Ok;

//@description Logout from the current user session
logOut = Ok;

//@description Close the current Nimgram instance
close = Ok;

part of '../msal_js.dart';

/// A callback used for letting MSAL retrieve a redirect URI from the application dynamically.
/// 
/// A valid URI should be returned from this function.
typedef RedirectUriCallback = String Function();

/// A callback for an authentication response after a redirect.
/// 
/// - [error] - If not null, contains the error that caused authentication to fail.
/// - [response] - If not null, contains the successful authentication response data.
typedef AuthResponseCallback = void Function(AuthException error, [AuthResponse response]);

/// An MSAL authentication context.
/// 
/// See https://github.com/AzureAD/microsoft-authentication-library-for-js/wiki/MSAL-basics
/// for more information.
class UserAgentApplication {
  /// Gets the authority for this application.
  String get authority => _jsObject['authority'];
  /// Sets the authority of this application.
  /// 
  /// [value] - A URL indicating a directory that MSAL can use to obtain tokens:
  /// - In Azure AD, it is of the form https://<instance>/<tenant>, where <instance> is the directory host 
  ///   (e.g. https://login.microsoftonline.com) and <tenant> is a identifier within the directory itself 
  ///   (e.g. a domain associated to the tenant, such as contoso.onmicrosoft.com, or the GUID representing 
  ///   the TenantID property of the directory)
  /// - In Azure B2C, it is of the form https://<instance>/tfp/<tenant>/<policyName>/
  /// - Default value is: "https://login.microsoftonline.com/common"
  set authority(String value) => _jsObject['authority'] = value;
  
  final JsObject _jsObject;

  /// Creates a new MSAL authentication context from the given [configuration].
  /// 
  /// If the [configuration] is invalid, a [ClientConfigurationException] will be thrown.
  factory UserAgentApplication(Configuration configuration) {
    if (configuration == null) throw ArgumentError.notNull('configuration');

    return UserAgentApplication._fromJsObject(
      JsObject(msalJsObject['UserAgentApplication'], [configuration._jsObject])
    );
  }

  UserAgentApplication._fromJsObject(this._jsObject);

  /// Sets the callback function for the redirect flow.
  /// 
  /// This callback must be set before [acquireTokenRedirect] and [loginRedirect] can be used.
  void handleRedirectCallback(AuthResponseCallback callback) {
    if (callback == null) throw ArgumentError.notNull('callback');
    
    void jsCallback(JsObject error, [JsObject response]) {
      callback(_convertJsAuthError(error), AuthResponse._fromJsObject(response));
    }

    try {
      _jsObject.callMethod('handleRedirectCallback', [allowInterop(jsCallback)]);
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Acquires an access token using interactive authentication via a popup Window. 
  /// 
  /// To renew an ID token, pass the client ID as the only scope in the [request].
  /// 
  /// Will throw an [AuthException] on failure.
  Future<AuthResponse> acquireTokenPopup(AuthRequest request) async {
    try {
      final JsObject response = await _convertMsalPromise(
        _jsObject.callMethod('acquireTokenPopup', [request._jsObject])
      );

      return AuthResponse._fromJsObject(response);
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Acquires an access token by redirecting the user to the authorization endpoint.
  /// 
  /// To renew an ID token, pass the client ID as the only scope in the [request].
  void acquireTokenRedirect(AuthRequest request) {
    try {
      _jsObject.callMethod('acquireTokenRedirect', [request._jsObject]);
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Acquires an access token by using a cached token if available or by sending a
  /// request to the authorization endpoint to obtain a new token using a hidden iframe.
  /// 
  /// To renew an ID token, pass the client ID as the only scope in the [request].
  /// 
  /// Will throw an [AuthException] on failure.
  Future<AuthResponse> acquireTokenSilent(AuthRequest request) async {
    try {
      final JsObject response = await _convertMsalPromise(
        _jsObject.callMethod('acquireTokenSilent', [request._jsObject])
      );

      return AuthResponse._fromJsObject(response);
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Gets all currently cached unique accounts based on `homeAccountIdentifier`.
  List<Account> getAllAccounts() {
    try {
      return (_jsObject
        .callMethod('getAllAccounts') as JsArray)
        .map((jsAccount) => Account._fromJsObject(jsAccount))
        .toList();
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Gets the signed in account or `null` if no-one is signed in.
  Account getAccount() {
    try {
      final JsObject jsAccount = _jsObject.callMethod('getAccount');

      return jsAccount == null ? null : Account._fromJsObject(jsAccount);
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Initiates the login process by opening a popup browser window.
  /// 
  /// Will throw an [AuthException] on failure.
  Future<AuthResponse> loginPopup([AuthRequest request]) async {
    try {
      final JsObject response = await _convertMsalPromise(
        _jsObject.callMethod('loginPopup', [request?._jsObject])
      );

      return AuthResponse._fromJsObject(response);
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Initiates the login process by redirecting the user to the authorization endpoint.
  void loginRedirect([AuthRequest request]) {
    try {
      _jsObject.callMethod('loginRedirect', [request?._jsObject]);
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Logs out the current user, and redirects to the `postLogoutRedirectUri`.
  void logout() {
    try {
      _jsObject.callMethod('logout');
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Returns whether a login is currently in progress.
  bool getLoginInProgress() {
    try {
      return _jsObject.callMethod('getLoginInProgress');
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Returns the current configuration of this user agent application.
  Configuration getCurrentConfiguration() {
    try {
      return Configuration._fromJsObject(_jsObject.callMethod('getCurrentConfiguration'));
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Returns the post-logout redirect URI currently configured.
  /// 
  /// If the post-logout redirect URI was configured as a function, it
  /// will be evaluated and its result will be returned.
  String getPostLogoutRedirectUri() {
    try {
      return _jsObject.callMethod('getPostLogoutRedirectUri');
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }

  /// Returns the redirect URI currently configured.
  /// 
  /// If the redirect URI was configured as a function, it
  /// will be evaluated and its result will be returned.
  String getRedirectUri() {
    try {
      return _jsObject.callMethod('getRedirectUri');
    } on dynamic catch (ex) {
      throw _convertJsAuthError(ex);
    }
  }
}

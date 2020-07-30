import IBMCloudAppID
class delegate : AuthorizationDelegate {
    public func onAuthorizationSuccess(accessToken: AccessToken, identityToken: IdentityToken, response:Response?) {
        //ユーザー認証済み
        
    }

    public func onAuthorizationCanceled() {
        //ユーザーによる認証の取り消し
    }

    public func onAuthorizationFailure(error: AuthorizationError) {
        //例外の発生
    }
}

AppID.sharedInstance.loginWidget?.launch(delegate: delegate())

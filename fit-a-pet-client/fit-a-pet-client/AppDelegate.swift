

import UIKit
import KakaoSDKCommon
import GoogleSignIn
import NaverThirdPartyLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let kakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as! String
        let naverClientId = Bundle.main.infoDictionary?["NaverClientID"] as! String
        let naverClientSecret = Bundle.main.infoDictionary?["NaverClientSecret"] as! String
        
        
        KakaoSDK.initSDK(appKey: kakaoAppKey)
        
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        ///  네이버앱으로 로그인
        instance!.isNaverAppOauthEnable = true
        /// 사파리로 로그인
        instance!.isInAppOauthEnable = true
        
        instance?.serviceUrlScheme = "naverlogin" // 앱을 등록할 때 입력한 URL Scheme
        instance?.consumerKey = naverClientId // 상수 - client id
        instance?.consumerSecret = naverClientSecret // pw
        instance?.appName = "Fit a Pet" // app name
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
        
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(application, open: url, options: options)
        
        GIDSignIn.sharedInstance.handle(url)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


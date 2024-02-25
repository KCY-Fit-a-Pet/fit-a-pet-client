

import UIKit
import KakaoSDKCommon
import GoogleSignIn
import NaverThirdPartyLogin
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
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
        
        
        //push notification
        registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        
        
        NaverThirdPartyLoginConnection.getSharedInstance()?.application(application, open: url, options: options)
        
        GIDSignIn.sharedInstance.handle(url)
        
        return true
    }
    private func registerForRemoteNotifications() {
        
        // 1. 푸시 center (유저에게 권한 요청 용도)
        let center = UNUserNotificationCenter.current()
        center.delegate = self // push처리에 대한 delegate - UNUserNotificationCenterDelegate
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { (granted, error) in
            
            guard granted else {
                return
            }
            
            DispatchQueue.main.async {
                // 2. APNs에 디바이스 토큰 등록
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
     
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print("APNs device token: \(deviceTokenString)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }

}

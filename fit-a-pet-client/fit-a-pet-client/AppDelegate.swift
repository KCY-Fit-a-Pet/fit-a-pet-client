

import UIKit
import KakaoSDKCommon
import GoogleSignIn
import NaverThirdPartyLogin
import Firebase
import FirebaseCore

import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Firebase 세팅
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        // FCM 다시 사용 설정
        Messaging.messaging().isAutoInitEnabled = true

        //push notification, device token 요청.
        registerForRemoteNotifications()
        
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
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

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
    // APN 토큰과 등록 토큰 매핑
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print("APNs device token: \(deviceTokenString)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner])
    }
}

extension AppDelegate: MessagingDelegate {
    // 현재 등록 토큰 가져오기.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        
//        let device = UIDevice.current
//        print("os: \(device.systemVersion)")
//        var modelName = ""
//        let selName = "_\("deviceInfo")ForKey:"
//                let selector = NSSelectorFromString(selName)
//                
//                if device.responds(to: selector) { // [옵셔널 체크 실시]
//                    modelName = String(describing: device.perform(selector, with: "marketing-name").takeRetainedValue())
//                }
//        print("devieModel: \(modelName)")
//
//        // TODO: - 디바이스 토큰을 보내는 서버통신 구현
//        print("APNs fcm Token: \(String(describing: fcmToken!))")
////       // sendDeviceTokenWithAPI(fcmToken: fcmToken ?? "")
////
        
//        AuthorizationAlamofire.shared.registDeviceToken(String(describing: fcmToken!), device.systemVersion, modelName) {result in
//            switch result {
//            case .success(let data):
//                if let responseData = data,
//                   let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
//                    print("response jsonData: \(jsonObject)")
//                    
//                    AuthorizationAlamofire.shared.pushNotificationAPI{result in
//                        switch result {
//                        case .success(let data):
//                            if let responseData = data,
//                               let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
//                                print("response jsonData: \(jsonObject)")
//                            }
//                            
//                        case .failure(let error):
//                            print("Error: \(error)")
//                        }
//                    }
//                }
//                
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//        
       
        
    }
}

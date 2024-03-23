//
//  LocalNotiTest.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 3/17/24.
//

import UIKit

class LocalNotificationHelper {
    static let shared = LocalNotificationHelper()

    func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
        
        // 1️⃣ 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body

        // 2️⃣ 조건(시간, 반복)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)

        // 3️⃣ 요청
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)

        // 4️⃣ 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}




import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        UITabBar.appearance().backgroundColor = .white
        
        tabBar.tintColor = UIColor(named: "Primary")
        
        let mainVC = MainVC()
        let calendarVC = CalendarVC()
        let recordVC = RecordVC()
        let petVC = PetVC()
        let settingVC = SettingVC()
      
        // navigationController의 root view 설정
        let navigationMain = UINavigationController(rootViewController: mainVC)
        let navigationCalendar = UINavigationController(rootViewController: calendarVC)
        let navigationRecord = UINavigationController(rootViewController: recordVC)
        let navigationPet = UINavigationController(rootViewController: petVC)
        let navigationSetting = UINavigationController(rootViewController: settingVC)
        
        setViewControllers([navigationCalendar, navigationRecord, navigationMain, navigationPet, navigationSetting ], animated: false)
        
        navigationMain.tabBarItem.image = UIImage(named: "icon_tabbar_home")
        navigationCalendar.tabBarItem.image = UIImage(named: "icon_tabbar_calendar")
        navigationRecord.tabBarItem.image = UIImage(named: "icon_tabbar_note")
        navigationPet.tabBarItem.image = UIImage(named: "icon_tabbar_pets")
        navigationSetting.tabBarItem.image = UIImage(named: "icon_tabbar_settings")
        
        
        //각 tab bar의 viewcontroller 타이틀 설정
        navigationMain.title = "홈"
        navigationCalendar.title = "캘린더"
        navigationRecord.title = "기록"
        navigationPet.title = "반려동물"
        navigationSetting.title = "설정"
        
        selectedIndex = 2
    }
}

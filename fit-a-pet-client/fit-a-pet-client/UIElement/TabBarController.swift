

import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        UITabBar.appearance().backgroundColor = .white
        
        let mainVC = MainVC()
        let calendarVC = CalendarVC()
        let recordVC = RecordVC()
        let petVC = PetVC()
        let settingVC = SettingVC()
        
        

//        homeVC.tabBarItem.image = UIImage.init(systemName: "house")
//        searchVC.tabBarItem.image = UIImage.init(systemName: "magnifyingglass")
//        libraryVC.tabBarItem.image = UIImage.init(systemName: "book")
      
        // navigationController의 root view 설정
        let navigationMain = UINavigationController(rootViewController: mainVC)
        let navigationCalendar = UINavigationController(rootViewController: calendarVC)
        let navigationRecord = UINavigationController(rootViewController: recordVC)
        let navigationPet = UINavigationController(rootViewController: petVC)
        let navigationSetting = UINavigationController(rootViewController: settingVC)
        
        setViewControllers([navigationCalendar, navigationRecord, navigationMain, navigationPet, navigationSetting ], animated: false)
        
        //각 tab bar의 viewcontroller 타이틀 설정
        navigationMain.title = "홈"
        navigationCalendar.title = "캘린더"
        navigationRecord.title = "기록"
        navigationPet.title = "반려동물"
        navigationSetting.title = "설정"
        
        selectedIndex = 2
        
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        print("나와라ㅏㅏㅏㅏㅏㅏ")
//    }
    
}

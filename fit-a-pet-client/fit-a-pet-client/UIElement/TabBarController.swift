

import UIKit

class TabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        
        // Do any additional setup after loading the view.
        let mainVC = MainVC()
        let calendarVC = CalendarVC()
        let recordVC = RecordVC()
        let petVC = PetVC()
        let settingVC = SettingVC()
        
        //각 tab bar의 viewcontroller 타이틀 설정
        
        mainVC.title = "홈"
        calendarVC.title = "캘린더"
        recordVC.title = "기록"
        petVC.title = "반려동물"
        settingVC.title = "설정"
        
//        homeVC.tabBarItem.image = UIImage.init(systemName: "house")
//        searchVC.tabBarItem.image = UIImage.init(systemName: "magnifyingglass")
//        libraryVC.tabBarItem.image = UIImage.init(systemName: "book")
        
        //self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
        
        // 위에 타이틀 text를 항상 크게 보이게 설정
//        mainVC.navigationItem.largeTitleDisplayMode = .always
//        calendarVC.navigationItem.largeTitleDisplayMode = .always
//        recordVC.navigationItem.largeTitleDisplayMode = .always
//        petVC.navigationItem.largeTitleDisplayMode = .always
//        settingVC.navigationItem.largeTitleDisplayMode = .always
        
        // navigationController의 root view 설정
        let navigationMain = UINavigationController(rootViewController: mainVC)
        let navigationCalendar = UINavigationController(rootViewController: calendarVC)
        let navigationRecord = UINavigationController(rootViewController: recordVC)
        let navigationPet = UINavigationController(rootViewController: petVC)
        let navigationSetting = UINavigationController(rootViewController: settingVC)
        
    
//        navigationMain.navigationBar.prefersLargeTitles = true
//        navigationCalendar.navigationBar.prefersLargeTitles = true
//        navigationRecord.navigationBar.prefersLargeTitles = true
//        navigationPet.navigationBar.prefersLargeTitles = true
//        navigationSetting.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navigationCalendar, navigationRecord, navigationMain, navigationPet, navigationSetting ], animated: false)
        
        selectedIndex = 2
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

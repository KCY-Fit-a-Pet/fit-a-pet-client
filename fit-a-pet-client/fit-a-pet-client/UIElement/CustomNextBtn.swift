

import UIKit

class CustomNextBtn: UIButton {
    
    var GRAY3 = UIColor(named: "Gray3")
    var PRIMARYCOLOR = UIColor(named: "PrimaryColor")

    init(title: String) {
       super.init(frame: .zero)
       
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setTitleColor(.white, for: .normal)
        backgroundColor = GRAY3
        layer.cornerRadius = 8
       
       snp.makeConstraints { make in
           make.height.equalTo(56)
       }
   }
       
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    func updateButtonColor(_ text: String, _ authNum: Bool) {
        if authNum == false  {
            if !text.isEmpty{
                backgroundColor = PRIMARYCOLOR
            }
            else{
                backgroundColor = GRAY3
            }
            
        } else if authNum == true{
            if text.count == 6{
                backgroundColor = PRIMARYCOLOR
            }
            else{
                backgroundColor = GRAY3
            }
        }
    }
}

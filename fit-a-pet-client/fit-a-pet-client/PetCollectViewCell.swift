//
//  PetCollectViewCell.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/25.
//

import UIKit

class PetCollectViewCell: UICollectionViewCell {
    
   // let petName = UILabel()

    @IBOutlet weak var namee: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//
//        petName.text = "label"
//
//        petName.snp.makeConstraints{make in
//            make.top.equalToSuperview().offset(5)
//            make.leading.equalToSuperview().offset(5)
//            make.width.equalTo(20)
//            make.height.equalTo(20)
//        }
    }
    
    func configure(_ name: String){
        //petName.text = name
        namee.text = name
    }
}

import UIKit

class PetDataCollectionViewMethod: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var petCollectData: [SummaryPet] = PetDataManager.summaryPets
    var didSelectPetClosure: ((IndexPath) -> Void)?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petCollectData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPetCollectionViewCell", for: indexPath) as! MainPetCollectionViewCell
        let data = petCollectData[indexPath.item].petName
        cell.configure(data)

        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = petCollectData[indexPath.item].petName.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17) // 레이블 폰트에 맞게 조절
        ]).width + 15 // 텍스트 너비에 여분의 여백을 추가하여 잘리지 않도록 함
        return CGSize(width: cellWidth, height: 40)
    }
    
    func updatePetCollectData(with newData: [SummaryPet]) {
        self.petCollectData = newData
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPet = petCollectData[indexPath.item]
        print("Selected Pet: \(selectedPet.id)")
        didSelectPetClosure?(indexPath)
    }
}

class PetCareCollectionViewMethod: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var petCareData: [Int: [CareCategory]] = PetDataManager.careCategoriesByPetId
    var selectedPet: Int = 0
    var dataDidChange: (() -> Void)?
    var didSelectPetClosure: ((IndexPath) -> Void)?

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return petCareData[selectedPet]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petCareData[selectedPet]?[section].cares.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPetCareCollectionViewCell", for: indexPath) as! MainPetCareCollectionViewCell

        if let careCategory = petCareData[selectedPet]?[indexPath.section] {
            let care = careCategory.cares[indexPath.item]
            let data = care.careName
            
            if let formattedTime = DateFormatterUtils.formatTime(care.careDate) {
                
                if care.isClear {
                    cell.configure(data, "완료됨")
                    cell.careNameLabel.textColor = UIColor(named: "Gray3")
                    cell.careTimeLabel.textColor = UIColor(named: "Success")
                } else {
                    cell.configure(data, formattedTime)
                    cell.careNameLabel.textColor = .black
                    cell.careTimeLabel.textColor = UIColor(named: "Gray5")
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.bounds.width
        let cellWidth = viewWidth / 2 - 5
        return CGSize(width: cellWidth, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PetCareHeaderView", for: indexPath) as! PetCareHeaderView
            if let careCategory = petCareData[selectedPet]?[indexPath.section] {
                headerView.titleLabel.text = careCategory.categoryName
            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    func notifyDataDidChange() {
        dataDidChange?()
    }
    func updatePetCareCollectData(with newData:  [Int: [CareCategory]]) {
        self.petCareData = newData
        self.notifyDataDidChange()
    }
    func seletedPetId(_ petId: Int){
        selectedPet = petId
        self.notifyDataDidChange()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let careCategory = petCareData[selectedPet]?[indexPath.section] {
//            let selectedCare = careCategory.cares[indexPath.item]
//            print("Selected Pet Care ID: \(selectedCare.careId)")
//        }
        didSelectPetClosure?(indexPath)
    }
}



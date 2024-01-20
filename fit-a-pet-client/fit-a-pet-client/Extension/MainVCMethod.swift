import UIKit

class PetDataCollectionViewMethod: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var petCollectData: [String] = ["동물11111", "동물222", "동물33", "동물4", "동물5555", "동물6"]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petCollectData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPetCollectionViewCell", for: indexPath) as! MainPetCollectionViewCell
        let data = petCollectData[indexPath.item]
        cell.configure(data)
        
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = petCollectData[indexPath.item].size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17) // 레이블 폰트에 맞게 조절
        ]).width + 15 // 텍스트 너비에 여분의 여백을 추가하여 잘리지 않도록 함
        return CGSize(width: cellWidth, height: 40)
    }
}

class PetCareCollectionViewMethod: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var petCareData: [String] = ["예시1", "예시 2", "예시 3"]

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPetCareCollectionViewCell", for: indexPath) as! MainPetCareCollectionViewCell
        
        cell.configure("예시", "시간")

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 168, height: 150)
    }
}

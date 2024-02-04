import UIKit

class PetProfileUtils {
    static func configurePetInfoSubview(_ petInfoView: PetProfileView, petName: String, gender: String, age: String, feed: String) {
        petInfoView.petName.text = petName
        if gender == "FEMALE" {
            petInfoView.petGender.attributedText = createAttributedString(withTopic: "성별", data: "암컷")
        } else {
            petInfoView.petGender.attributedText = createAttributedString(withTopic: "성별", data: "수컷")
        }
        petInfoView.petAge.attributedText = createAttributedString(withTopic: "나이", data: age)
        petInfoView.petFeed.attributedText = createAttributedString(withTopic: "사료", data: feed)
    }

    static func createAttributedString(withTopic topic: String, data: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: topic + "  ")
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: 2))

        let dataAttributedString = NSAttributedString(string: data)
        attributedString.append(dataAttributedString)

        return attributedString
    }
}


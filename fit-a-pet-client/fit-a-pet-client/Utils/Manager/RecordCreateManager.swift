import UIKit

struct RecordCreateManager {
    static var shared = RecordCreateManager()

    var title: String?
    var content: String?
    var memoImages: [UIImage]?
    var memoImageUrls: [String]?

    private init() {
        title = nil
        content = nil
        memoImageUrls = nil
    }

    mutating func addInput(title: String? = nil, content: String? = nil, memoImages: [UIImage]? = nil, memoImageUrls: [String]? = nil) {
        if let title = title {
            self.title = title
        }
        if let content = content {
            self.content = content
        }
        if let memoImages = memoImages {
            self.memoImages = memoImages
        }
        if let memoImageUrls = memoImageUrls {
            self.memoImageUrls = memoImageUrls
        }
    }

    func performRegistration() {
        if let title = title,
           let content = content,
           let memoImageUrls = memoImageUrls
        {
            print("""
                Title - \(title)
                Content - \(content)
                MemoImageUrls - \(memoImageUrls)
            """)
        } else {
            print("Missing information for Record Create")
        }
    }
}

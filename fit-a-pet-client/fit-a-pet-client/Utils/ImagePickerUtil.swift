
import UIKit

class ImagePickerUtil: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let pickerController = UIImagePickerController()
    private weak var presentationController: UIViewController?
    private var completion: ((UIImage?) -> Void)?
    
    override init() {
        super.init()
        pickerController.delegate = self
    }
    
    func present(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        self.presentationController = viewController
        self.completion = completion
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
                self.showImagePicker(sourceType: .camera)
            }
            actionSheet.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
            self.showImagePicker(sourceType: .photoLibrary)
        }
        actionSheet.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        viewController.present(actionSheet, animated: true, completion: nil)
    }
    
    private func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        pickerController.sourceType = sourceType
        presentationController?.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            completion?(nil)
            return
        }
        completion?(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        completion?(nil)
        picker.dismiss(animated: true, completion: nil)
    }
}

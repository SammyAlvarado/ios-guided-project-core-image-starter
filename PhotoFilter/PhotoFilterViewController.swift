import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos

class PhotoFilterViewController: UIViewController {

	@IBOutlet weak var brightnessSlider: UISlider!
	@IBOutlet weak var contrastSlider: UISlider!
	@IBOutlet weak var saturationSlider: UISlider!
	@IBOutlet weak var imageView: UIImageView!
    
    var originalImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    private let context = CIContext()
    private let filter = CIFilter.colorControls()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
//        let filter = CIFilter.gaussianBlur()
//        let filter2 = CIFilter(name: "CIColorControls")
//
//        print(filter.attributes) // print the attributes to see what they can do.
        
        originalImage = imageView.image

	}

    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("This is were the error should be presented to the user NSLOG or Alert")
            return
        }

        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        let inputImage = CIImage(image: image)
        
        filter.inputImage = inputImage
        filter.saturation = saturationSlider.value
        filter.brightness = brightnessSlider.value
        filter.contrast = contrastSlider.value
        
        guard let outputimage = filter.outputImage else { return image }
        
        guard let renderedCGImage = context.createCGImage(outputimage, from: outputimage.extent) else { return image}
        
        return UIImage(cgImage: renderedCGImage)
    }
    
    private func updateImage() {
        if let originalImage = originalImage {
            imageView.image = originalImage
        } else {
            imageView.image = nil
        }
    }
	
	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
        presentImagePickerController()
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {
		// TODO: Save to photo library
	}
	

	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {
        updateImage()
	}
	
	@IBAction func contrastChanged(_ sender: Any) {
        updateImage()
	}
	
	@IBAction func saturationChanged(_ sender: Any) {
        updateImage()
	}
}

extension PhotoFilterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            originalImage = image
        } else if let image = info[.originalImage] as? UIImage {
            originalImage = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


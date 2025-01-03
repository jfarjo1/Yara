import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import CountryPickerView

class ApplyScreen: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var back_button: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var employmentStatusTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var monthlySalaryTextField: UITextField!
    @IBOutlet weak var nationalityTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var phoneNumberCountryPicker: CountryPickerView!
    @IBOutlet weak var emiratesIDFrontTextField: UITextField!
    @IBOutlet weak var emiratesIDBackTextField: UITextField!
    
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var learnMoreButton: UIButton!
    @IBOutlet weak var learnMoreLabel: UILabel!
    
    @IBOutlet weak var whatsappView:UIView!
    
    @IBOutlet weak var cell2Height: NSLayoutConstraint!
    @IBOutlet weak var cellHeight: NSLayoutConstraint!
    var apartment: Apartment? = nil
    
    // Properties to store upload URLs
    private var emiratesIDFrontURL: String?
    private var emiratesIDBackURL: String?
    private var bankStatementURL: String?
    private var currentUploadType: UploadType = .front
    
    private var emiratesIDFrontButton: UIButton?
    private var emiratesIDBackButton: UIButton?
    private var bankStatementButton: UIButton?
    
    // Properties for keyboard handling
    private var activeTextField: UITextField?
    private var originalViewFrame: CGRect?
    
    var selectedCountry: Country?
    
    enum UploadType {
        case front
        case back
        case bankStatement
    }
    
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
        setupNumberPads()
        addDoneButtonOnKeyboard()
        setupKeyboardHandling()
        setupTextFieldDelegates()
    }
    
    private func setupKeyboardHandling() {
        // Store original frame
        originalViewFrame = view.frame
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupTextFieldDelegates() {
        // Assign delegates to all text fields
        let textFields: [UITextField] = [
            firstNameTextField,
            lastNameTextField,
            dateOfBirthTextField,
            employmentStatusTextField,
            addressTextField,
            monthlySalaryTextField,
            nationalityTextField,
            phoneNumberTextField,
            emiratesIDFrontTextField,
            emiratesIDBackTextField
        ]
        
        textFields.forEach { $0.delegate = self }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeTextField = activeTextField else { return }
        
        // Calculate the text field's bottom position
        let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: view)
        let textFieldBottom = textFieldFrame.origin.y + textFieldFrame.height
        
        // Calculate the distance between the text field's bottom and keyboard's top
        let keyboardTop = view.frame.height - keyboardFrame.height
        let distance = textFieldBottom - keyboardTop
        
        // If text field is hidden by keyboard, move the view up
        if distance > 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -distance - 20 // Added 20pt padding
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        // Reset view position
        guard let originalFrame = originalViewFrame else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame = originalFrame
        }
    }
    
    private func setupDatePicker() {
        // Configure date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date() // Don't allow future dates
        self.cellHeight.constant = ScreenRatioHelper.adjustedHeight(50)
        
        self.cell2Height.constant = ScreenRatioHelper.adjustedHeight(50)
        // Set date picker as input view for date of birth field
        dateOfBirthTextField.inputView = datePicker
        
        // Add target to handle date changes
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    private func setupNumberPads() {
        // Set keyboard type for monthly salary
        monthlySalaryTextField.keyboardType = .numberPad
        
        // Set keyboard type for phone number
        phoneNumberTextField.keyboardType = .numberPad
    }
    
    @objc private func dateChanged() {
        // Format the date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateOfBirthTextField.text = formatter.string(from: datePicker.date)
    }
    
    func setupUI() {
        TapGestureRecognizer.addTapGesture(to: whatsappView) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "BottomUpViewController") as! BottomUpViewController
            vc.modalTransitionStyle = .coverVertical
            
            self.present(vc, animated: true)
        }
        
        self.back_button.setRounded()
        self.titleLabel.text = "Apply Now"
        self.titleLabel.font = CustomFont.boldFont(size: 22)
        
        self.firstNameTextField.setConfigForApply()
        self.firstNameTextField.placeholder = "First Name"
        self.firstNameTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.lastNameTextField.setConfigForApply()
        self.lastNameTextField.placeholder = "Last Name"
        self.lastNameTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.dateOfBirthTextField.setConfigForApply()
        self.dateOfBirthTextField.placeholder = "Date of Birth"
        self.dateOfBirthTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.employmentStatusTextField.setConfigForApply()
        self.employmentStatusTextField.placeholder = "Employment Status"
        self.employmentStatusTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.addressTextField.setConfigForApply()
        self.addressTextField.placeholder = "Address"
        self.addressTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.monthlySalaryTextField.setConfigForApply()
        self.monthlySalaryTextField.placeholder = "Monthly Salary"
        self.monthlySalaryTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.nationalityTextField.setConfigForApply()
        self.nationalityTextField.placeholder = "Nationality"
        self.nationalityTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.phoneNumberView.addDottedBorderView(color: UIColor(hex: "#F7F7F7")!, lineWidth: 2, cornerRadius: 12.5, dashPattern: [4,4])
        self.phoneNumberTextField.placeholder = "Phone Number"
        self.phoneNumberTextField.font = CustomFont.semiBoldFont(size: 14)
        
        self.phoneNumberCountryPicker.textColor = .lightGray
        self.phoneNumberCountryPicker.showCountryCodeInView = false
        self.phoneNumberCountryPicker.showCountryNameInView = false
        self.phoneNumberCountryPicker.font = CustomFont.semiBoldFont(size: 14)
        self.phoneNumberCountryPicker.delegate = self
        self.phoneNumberCountryPicker.dataSource = self
        self.phoneNumberCountryPicker.hostViewController = self
        self.selectedCountry = self.phoneNumberCountryPicker.selectedCountry
        
        self.emiratesIDFrontTextField.setConfigForApply()
        self.emiratesIDFrontTextField.placeholder = "Emirates ID Front"
        self.emiratesIDFrontTextField.font = CustomFont.semiBoldFont(size: 14)
        self.addUploadButton(textField: self.emiratesIDFrontTextField, tag: 1)
        
        self.emiratesIDBackTextField.setConfigForApply()
        self.emiratesIDBackTextField.placeholder = "Emirates ID Back"
        self.emiratesIDBackTextField.font = CustomFont.semiBoldFont(size: 14)
        self.addUploadButton(textField: self.emiratesIDBackTextField, tag: 2)
        
        self.applyButton.layer.cornerRadius = 45/2
        self.applyButton.clipsToBounds = true
        self.applyButton.setTitle("Submit", for: .normal)
        self.applyButton.backgroundColor = UIColor(hex: "#484848")
        self.applyButton.titleLabel?.font = CustomFont.semiBoldFont(size: 17)
        self.applyButton.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        
        learnMoreLabel.text = "100% Free. No hidden fees."
        learnMoreLabel.textColor = UIColor(hex: "#999999")
        learnMoreLabel.font = CustomFont.semiBoldFont(size: 10)
        
        learnMoreButton.setTitle("Learn more", for: .normal)
        learnMoreButton.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        learnMoreButton.titleLabel?.font = CustomFont.semiBoldFont(size: 10)
        learnMoreButton.backgroundColor = UIColor(hex: "#F9FAFB")
        
        self.dateOfBirthTextField.setConfigForApply()
        self.dateOfBirthTextField.placeholder = "Date of Birth (DD/MM/YYYY)"
        self.dateOfBirthTextField.font = CustomFont.semiBoldFont(size: 14)
        
        _ = TapGestureRecognizer.addTapGesture(to: applyButton) {
            self.checkIfFieldsAreFilled()
        }
        
        TapGestureRecognizer.addTapGesture(to: learnMoreButton) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "BottomUpViewController") as! BottomUpViewController
            
            self.present(vc, animated: true)
        }
        
        _ = TapGestureRecognizer.addTapGesture(to: back_button) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func addUploadButton(textField: UITextField, tag: Int, padding: CGFloat = 10, buttonWidth: CGFloat = 80, font: UIFont = CustomFont.semiBoldFont(size: 14)) {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: buttonWidth + padding, height: textField.frame.size.height))
        
        let uploadButton = UIButton(type: .system)
        uploadButton.setTitle("Upload", for: .normal)
        uploadButton.titleLabel?.font = font
        uploadButton.setTitleColor(.black, for: .normal)
        uploadButton.frame = CGRect(x: padding - 20, y: 0, width: buttonWidth, height: containerView.frame.height)
        uploadButton.tag = tag
        
        // Store reference to the button
        switch tag {
        case 1:
            emiratesIDFrontButton = uploadButton
        case 2:
            emiratesIDBackButton = uploadButton
        case 3:
            bankStatementButton = uploadButton
        default:
            break
        }
        
        _ = TapGestureRecognizer.addTapGesture(to: uploadButton) {
            self.currentUploadType = tag == 1 ? .front : (tag == 2 ? .back : .bankStatement)
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        }
        
        containerView.addSubview(uploadButton)
        textField.rightView = containerView
        textField.rightViewMode = .always
    }
    
    func checkIfFieldsAreFilled() -> Bool {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let dateOfBirth = dateOfBirthTextField.text, !dateOfBirth.isEmpty,
              let employmentStatus = employmentStatusTextField.text, !employmentStatus.isEmpty,
              let address = addressTextField.text, !address.isEmpty,
              let monthlySalaryText = monthlySalaryTextField.text, !monthlySalaryText.isEmpty,
              let nationality = nationalityTextField.text, !nationality.isEmpty,
              let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            
            showAlert(title: "Missing Information", message: "Please fill in all required fields and upload Emirates ID front")
            return false
        }
        
        // Validate monthly salary is a number
        guard let monthlySalary = Double(monthlySalaryText) else {
            showAlert(title: "Invalid Salary", message: "Please enter a valid monthly salary")
            return false
        }
        
        let formattedPhoneNumber = "\(selectedCountry?.phoneCode ?? "")\(phoneNumber)"
        
        // Submit the application
        submitApplication(
            firstName: firstName,
            lastName: lastName,
            dateOfBirth: dateOfBirth,
            employmentStatus: employmentStatus,
            address: address,
            monthlySalary: monthlySalary,
            nationality: nationality,
            phoneNumber: formattedPhoneNumber,
            emiratesIDFrontURL: emiratesIDFrontURL ?? "",
            emiratesIDBackURL: emiratesIDBackURL ?? "",
            bankStatementURL: bankStatementURL ?? ""
        )
        
        return true
    }
    
    private func submitApplication(
        firstName: String,
        lastName: String,
        dateOfBirth: String,
        employmentStatus: String,
        address: String,
        monthlySalary: Double,
        nationality: String,
        phoneNumber: String,
        emiratesIDFrontURL: String,
        emiratesIDBackURL: String,
        bankStatementURL: String
    ) {
        guard let userID = Auth.auth().currentUser?.uid else {
            showAlert(title: "Error", message: "Please sign in to submit application")
            return
        }
        
        let db = Firestore.firestore()
        let applicationRef = db.collection("applications").document()
        
        let applicationData: [String: Any] = [
            "userID": userID,
            "firstName": firstName,
            "lastName": lastName,
            "dateOfBirth": dateOfBirth,
            "employmentStatus": employmentStatus,
            "address": address,
            "monthlySalary": monthlySalary,
            "nationality": nationality,
            "phoneNumber": phoneNumber,
            "emiratesIDFrontURL": emiratesIDFrontURL,
            "emiratesIDBackURL": emiratesIDBackURL,
            "bankStatementURL": bankStatementURL,
            "status": "1",
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp(),
            "apartmentId": apartment?.id ?? ""
        ]
        
        // Show loading indicator
        let spinner = UIActivityIndicatorView(style: .large)
        view.addSubview(spinner)
        spinner.center = view.center
        spinner.startAnimating()
        
        // Save to Firestore
        applicationRef.setData(applicationData) { [weak self] error in
            guard let self = self else { return }
            spinner.stopAnimating()
            
            if let error = error {
                print("Error saving to Firestore: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Failed to submit application. Please try again.")
            } else {
                print("Successfully submitted application")
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "MabroukScreenVC") as! MabroukScreenVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        // Remove observers when view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
}

extension UITextField {
    func setConfigForApply() {
        self.addDottedBorder(color: UIColor(hex: "#F7F7F7")!, lineWidth: 2, cornerRadius: 12.5, dashPattern: [4,4])
        self.setLeftPaddingPoints(30)
    }
}

extension ApplyScreen: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.selectedCountry = country
    }
    
    func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return CustomFont.semiBoldFont(size: 14)
    }
    
    func cellImageViewSize(in countryPickerView: CountryPickerView) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select Country"
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
}

extension ApplyScreen: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dismiss picker
        picker.dismiss(animated: true)
        
        // Get selected image
        guard let image = info[.editedImage] as? UIImage,
              let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        // Show loading indicator
        let spinner = UIActivityIndicatorView(style: .large)
        view.addSubview(spinner)
        spinner.center = view.center
        spinner.startAnimating()
        
        // Create unique filename
        let filename = UUID().uuidString
        
        // Get Storage reference
        let storageRef = Storage.storage().reference()
        
        // Determine the storage path based on upload type
        let storagePath: String
        switch currentUploadType {
        case .front:
            storagePath = "emiratesID/front"
        case .back:
            storagePath = "emiratesID/back"
        case .bankStatement:
            storagePath = "bankStatements"
        }
        
        let imageRef = storageRef.child("\(storagePath)/\(filename).jpg")
        
        // Upload image to Firebase Storage
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metadata) { [weak self] (metadata, error) in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                    print("Error uploading image: \(error.localizedDescription)")
                    self.showAlert(title: "Upload Error", message: error.localizedDescription)
                }
                return
            }
            
            // Get download URL
            imageRef.downloadURL { [weak self] (url, error) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                    
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        self.showAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                    
                    guard let downloadURL = url else { return }
                    
                    // Store the URL and update UI based on upload type
                    switch self.currentUploadType {
                    case .front:
                        self.emiratesIDFrontURL = downloadURL.absoluteString
                        self.emiratesIDFrontButton?.setTitle("Uploaded", for: .normal)
                        self.emiratesIDFrontButton?.setTitleColor(.systemGreen, for: .normal)
                        self.emiratesIDFrontButton?.isEnabled = false
                    case .back:
                        self.emiratesIDBackURL = downloadURL.absoluteString
                        self.emiratesIDBackButton?.setTitle("Uploaded", for: .normal)
                        self.emiratesIDBackButton?.setTitleColor(.systemGreen, for: .normal)
                        self.emiratesIDBackButton?.isEnabled = false
                    case .bankStatement:
                        self.bankStatementURL = downloadURL.absoluteString
                        self.bankStatementButton?.setTitle("Uploaded", for: .normal)
                        self.bankStatementButton?.setTitleColor(.systemGreen, for: .normal)
                        self.bankStatementButton?.isEnabled = false
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ApplyScreen: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ApplyScreen {
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        doneToolbar.items = [flexSpace, done]
        doneToolbar.sizeToFit()
        
        // Add toolbar to all text fields
        firstNameTextField.inputAccessoryView = doneToolbar
        lastNameTextField.inputAccessoryView = doneToolbar
        dateOfBirthTextField.inputAccessoryView = doneToolbar
        employmentStatusTextField.inputAccessoryView = doneToolbar
        addressTextField.inputAccessoryView = doneToolbar
        monthlySalaryTextField.inputAccessoryView = doneToolbar
        nationalityTextField.inputAccessoryView = doneToolbar
        phoneNumberTextField.inputAccessoryView = doneToolbar
        emiratesIDFrontTextField.inputAccessoryView = doneToolbar
        emiratesIDBackTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        view.endEditing(true)
    }
}

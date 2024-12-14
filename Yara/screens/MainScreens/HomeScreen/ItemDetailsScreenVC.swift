//
//  ItemDetailsScreenVC.swift
//  Yara
//
//  Created by Johnny Owayed on 19/10/2024.
//
import UIKit
import CoreLocation
import MapKit

class ItemDetailsScreenVC: UIViewController {
    
    @IBOutlet weak var top_carousel: UIView!
    @IBOutlet weak var price_btn: UIButton!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var price_label: UILabel!
    @IBOutlet weak var description_textView: UITextView!
    @IBOutlet weak var show_full: UIButton!
    @IBOutlet weak var area_label: UILabel!
    @IBOutlet weak var property_label: UILabel!
    @IBOutlet weak var bedrooms_label: UILabel!
    @IBOutlet weak var bathrooms_label: UILabel!
    @IBOutlet weak var service_label: UILabel!
    @IBOutlet weak var location_Btn: UIButton!
    @IBOutlet weak var buy_now: UIButton!
    @IBOutlet weak var close_btn_view: UIView!
    @IBOutlet weak var descriptionTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageCarouselHeight: NSLayoutConstraint!
    
    @IBOutlet weak var priceButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var stackItemHeight: NSLayoutConstraint!
    @IBOutlet weak var showAllButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var buyNowHeight: NSLayoutConstraint!
    private var fullText = ""
    private let maxLines = 4
    private var isExpanded = false
    private var fullTextHeight: CGFloat = 0
    private let initialTextViewHeight: CGFloat = ScreenRatioHelper.adjustedHeight(74)
    
    var apartment:Apartment? = nil
    var hasApplication = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserService().checkUserApplication { result in
            switch result {
            case .success(let hasApplication):
                self.hasApplication = hasApplication ? 1 : 0
            case .failure(_):
                self.hasApplication = -1
            }
        }
        setupUI(with: apartment)
    }
    
    // Helper method to safely format currency values
    private func formatCurrency(_ value: Double) -> String {
        return String(format: "%.2f$", value)
    }
    
    private func loadFirstImage(from urls: [String], completion: @escaping (UIImage?) -> Void) {
        // Check if there are any URLs
        guard let firstUrlString = urls.first else {
            completion(nil)
            return
        }
        
        guard let url = URL(string: firstUrlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }

    private func loadRemainingImages(from urls: [String], completion: @escaping ([UIImage]) -> Void) {
        // Skip the first URL since it's already loaded
        let remainingUrls = Array(urls.dropFirst())
        var images: [UIImage] = []
        var loadedIndices: [Int: UIImage] = [:] // Keep track of order
        let group = DispatchGroup()
        
        for (index, urlString) in remainingUrls.enumerated() {
            group.enter()
            
            guard let url = URL(string: urlString) else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                
                if let data = data,
                   let image = UIImage(data: data) {
                    loadedIndices[index] = image
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            // Reconstruct images in correct order
            images = loadedIndices.sorted { $0.key < $1.key }.map { $0.value }
            completion(images)
        }
    }
    
    
    private func setupUI(with apartment: Apartment? = nil) {
        // Setup carousel view and constraints
        self.setupCarouselView()
        self.imageCarouselHeight.constant = ScreenRatioHelper.adjustedHeight(300)
        self.showAllButtonHeight.constant = ScreenRatioHelper.adjustedHeight(23)
        self.stackItemHeight.constant = ScreenRatioHelper.adjustedHeight(35)
        self.priceButtonHeight.constant = ScreenRatioHelper.adjustedHeight(33)
        self.buyNowHeight.constant = ScreenRatioHelper.adjustedHeight(45)
        self.close_btn_view.setRounded()
        
        if let apartment = apartment {
            price_btn.setTitle("One time: \(apartment.oneTime)", for: .normal)
            price_label.text = "and \(apartment.perMonth) monthly"
        }
        
        // Configure title
        title_label.font = CustomFont.semiBoldFont(size: 20)
        title_label.textColor = UIColor(hex: "#0A0908")
        title_label.text = apartment?.name ?? ""
        
        // Configure price button
        price_btn.layer.cornerRadius = ScreenRatioHelper.adjustedHeight(33)/2
        price_btn.titleLabel?.font = CustomFont.semiBoldFont(size: 13)
        price_btn.setTitleColor(UIColor(hex: "#A9A9A9"), for: .normal)
        price_btn.applyGradient(colors: [(UIColor(hex:"#040404") ?? .black).cgColor,
                                        (UIColor(hex:"#343434") ?? .gray).cgColor,
                                        (UIColor(hex:"#4B4B4B") ?? .black).cgColor,
                                        (UIColor(hex:"#575757") ?? .gray).cgColor,
                                        (UIColor(hex:"#636363") ?? .black).cgColor])
        
        
        // Configure price label
        price_label.textColor = UIColor(hex: "#999999")
        price_label.font = CustomFont.semiBoldFont(size: 13)
        
        // Configure show full button
        show_full.layer.cornerRadius = ScreenRatioHelper.adjustedHeight(23)/2
        show_full.setTitle("Show full description", for: .normal)
        show_full.backgroundColor = UIColor(hex: "#F8F8FA")
        show_full.titleLabel?.font = CustomFont.boldFont(size: 10)
        show_full.setTitleColor(UIColor(hex: "#A3A5A4"), for: .normal)
        
        // Configure buy now button
        buy_now.layer.cornerRadius = ScreenRatioHelper.adjustedHeight(45)/2
        buy_now.clipsToBounds = true
        buy_now.setTitle("Get Now", for: .normal)
        buy_now.backgroundColor = UIColor(hex: "#484848")
        buy_now.titleLabel?.font = CustomFont.semiBoldFont(size: 17)
        buy_now.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        
        // Configure description text view
        description_textView.textContainerInset = .zero
        description_textView.textContainer.lineFragmentPadding = 0
        description_textView.textContainer.maximumNumberOfLines = maxLines
        description_textView.isScrollEnabled = false
        description_textView.isUserInteractionEnabled = false
        description_textView.textColor = UIColor(hex: "#999999")
        description_textView.font = CustomFont.semiBoldFont(size: 15)
        
        if let apartment = apartment {
            fullText = apartment.description
            description_textView.text = apartment.description
            
            // Update property details
            area_label.text = apartment.area
            property_label.text = apartment.propertySize
            bedrooms_label.text = apartment.bedrooms
            bathrooms_label.text = apartment.bathrooms
            service_label.text = apartment.serviceCharge
            
            // Process and load images
            let processedImageUrls = apartment.imageUrls.flatMap { urlString in
                urlString.split(separator: " ").map(String.init)
            }

            loadFirstImage(from: processedImageUrls) { [weak self] firstImage in
                guard let self = self else { return }
                if let firstImage = firstImage {
                    if let carouselView = self.top_carousel.subviews.first as? ImageCarouselView {
                        carouselView.hideTopLeftLabel()
                        carouselView.configure(with: [firstImage], topLeftText: nil)
                        
                        // Load remaining images
                        self.loadRemainingImages(from: processedImageUrls) { remainingImages in
                            let allImages = [firstImage] + remainingImages
                            carouselView.configure(with: allImages, topLeftText: nil)
                        }
                    }
                }
            }
        }
        
        // Configure property detail labels
        let detailLabels = [area_label, property_label, bedrooms_label, bathrooms_label, service_label]
        detailLabels.forEach { label in
            label?.font = CustomFont.semiBoldFont(size: 14)
            label?.textColor = UIColor(hex: "#222222")
        }
        
        // Configure location button
        location_Btn.setTitleColor(UIColor(hex: "#222222"), for: .normal)
        location_Btn.setTitle("Tap to view", for: .normal)
        location_Btn.titleLabel?.font = CustomFont.semiBoldFont(size: 14)
        
        // Set initial height
        descriptionTextViewHeightConstraint.constant = initialTextViewHeight
        
        // Calculate full height after layout
        DispatchQueue.main.async {
            self.calculateFullTextHeight()
        }
    }
    private func calculateFullTextHeight() {
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: description_textView.bounds.width, height: .greatestFiniteMagnitude))
        textView.text = fullText
        textView.font = description_textView.font
        textView.textContainerInset = description_textView.textContainerInset
        textView.textContainer.lineFragmentPadding = description_textView.textContainer.lineFragmentPadding
        textView.layoutManager.enumerateLineFragments(forGlyphRange: NSRange(location: 0, length: textView.textStorage.length)) { (rect, usedRect, textContainer, glyphRange, stop) in
            self.fullTextHeight = rect.maxY
        }
        show_full.isHidden = (self.fullTextHeight <= self.initialTextViewHeight)
    }
    
    @IBAction func showFull(_ sender: Any) {
        isExpanded.toggle()
        if isExpanded {
            descriptionTextViewHeightConstraint.constant = fullTextHeight
            description_textView.textContainer.maximumNumberOfLines = 0
            show_full.setTitle("Show less description", for: .normal)
        } else {
            descriptionTextViewHeightConstraint.constant = 85 // Or your initial fixed height
            description_textView.textContainer.maximumNumberOfLines = maxLines
            show_full.setTitle("Show full description", for: .normal)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popWithFade()
    }
    
    @IBAction func buyNow(_ sender: Any) {
        if(hasApplication == 0) {
            TapticEngine.impact.feedback(.medium)
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "HowItWorksViewController") as! HowItWorksViewController
            vc.apartment = self.apartment
            vc.modalTransitionStyle = .coverVertical
            vc.delegate = self
            self.present(vc, animated: true)
        }else if hasApplication == 1 {
            self.showAlert(title:"Application Submitted", message: "You already have a pending application. Please contact our support via WhatsApp")
        }
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        guard let apartment = apartment,
              let locationUrl = URL(string: apartment.location) else {
            return
        }
        
        UIApplication.shared.open(locationUrl, options: [:], completionHandler: nil)
    }
    
    private func setupCarouselView() {
        guard let containerView = top_carousel else {
            print("Error: Could not find view with tag 2")
            return
        }
        let carouselView: ImageCarouselView
        if let existingCarouselView = containerView.subviews.first as? ImageCarouselView {
            carouselView = existingCarouselView
            carouselView.hideTopLeftLabel()
        } else {
            carouselView = ImageCarouselView()
            carouselView.hideTopLeftLabel()
            carouselView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(carouselView)
            
            NSLayoutConstraint.activate([
                carouselView.topAnchor.constraint(equalTo: containerView.topAnchor),
                carouselView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                carouselView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                carouselView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
        
//         Remove or comment out these lines
         let images = [UIImage(named: "onb_one_bg"), UIImage(named: "onb_two_bg"), UIImage(named: "onb_one_bg")].compactMap { $0 }
         carouselView.configure(with: images, topLeftText: nil)
        carouselView.hideTopLeftLabel()
    }
}

extension ItemDetailsScreenVC : HowItWorksViewControllerDelegate{
    func onTapButtonPressed(type: String) {
        if(type == "HowItWorks") {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ApplyScreen") as! ApplyScreen
            vc.apartment = self.apartment
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}



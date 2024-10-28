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
    
    private let fullText = "This is a long text that will be truncated initially. It contains multiple lines and will show only the first four lines at the beginning. When the user taps 'Show More', it will expand to show the entire text content. This is useful for displaying long descriptions or articles in a compact way.\nThis is a long text that will be truncated initially. It contains multiple lines and will show only the first four lines at the beginning. When the user taps 'Show More', it will expand to show the entire text content. This is useful for displaying long descriptions or articles in a compact way."
    private let maxLines = 4
    private var isExpanded = false
    private var fullTextHeight: CGFloat = 0
    private let initialTextViewHeight: CGFloat = 91
    
    var apartment:Apartment? = nil
    var hasApplication = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserService().checkUserApplication { result in
            switch result {
            case .success(var hasApplication):
                self.hasApplication = hasApplication ? 1 : 0
            case .failure(let error):
                self.hasApplication = -1
            }
        }
        setupUI()
        if let apartment = apartment {
            updateUIWithApartment(apartment)
        }
    }
    
    private func updateUIWithApartment(_ apartment: Apartment) {
        // Update all content with actual data
        title_label.text = apartment.name
        title_label.font = CustomFont.semiBoldFont(size: 20)
        title_label.textColor = UIColor(hex: "#0A0908")
        // Price button text with safe formatting
        price_btn.setTitle("One time: \(apartment.oneTime)", for: .normal)
        
        // Monthly price with safe formatting
        price_label.text = "and \(apartment.perMonth) monthly"
        
        description_textView.text = apartment.description
        
        // Update property details
        area_label.text = apartment.area
        property_label.text = apartment.propertySize
        bedrooms_label.text = apartment.bedrooms
        bathrooms_label.text = apartment.bathrooms
        service_label.text = apartment.serviceCharge
        
        location_Btn.setTitleColor(UIColor(hex: "#222222"), for: .normal)
        location_Btn.setTitle("Tap to view", for: .normal)
        location_Btn.titleLabel?.font = CustomFont.semiBoldFont(size: 14)
        
        let processedImageUrls = apartment.imageUrls.flatMap { urlString in
            urlString.split(separator: " ").map(String.init)
        }
        
        loadImages(from: processedImageUrls) { [weak self] images in
            guard let self = self else { return }
            if let carouselView = self.top_carousel.subviews.first as? ImageCarouselView {
                carouselView.hideTopLeftLabel()
                carouselView.configure(with: images, topLeftText: nil)
            }
        }
        calculateFullTextHeight()
    }
    
    // Helper method to safely format currency values
    private func formatCurrency(_ value: Double) -> String {
        return String(format: "%.2f$", value)
    }
    
    private func setupCarouselWithApartmentImages(_ apartment: Apartment) {
        guard let containerView = top_carousel else {
            print("Error: Could not find carousel container view")
            return
        }
        
        let carouselView: ImageCarouselView
        if let existingCarouselView = containerView.subviews.first as? ImageCarouselView {
            carouselView = existingCarouselView
            carouselView.hideTopLeftLabel()
        } else {
            carouselView = ImageCarouselView()
            carouselView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(carouselView)
            carouselView.hideTopLeftLabel()
            NSLayoutConstraint.activate([
                carouselView.topAnchor.constraint(equalTo: containerView.topAnchor),
                carouselView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                carouselView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                carouselView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
        
        // Process image URLs (they seem to be space-separated in the string)
        let processedImageUrls = apartment.imageUrls.flatMap { urlString in
            urlString.split(separator: " ").map(String.init)
        }
        
        // Load images from URLs
        loadImages(from: processedImageUrls) { images in
            carouselView.configure(with: images, topLeftText: nil)
            carouselView.hideTopLeftLabel()
        }
    }
    
    private func loadImages(from urls: [String], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        for urlString in urls {
            group.enter()
            guard let url = URL(string: urlString) else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                
                if let data = data, let image = UIImage(data: data) {
                    images.append(image)
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    
    func setupUI() {
        self.setupCarouselView()
        
        self.close_btn_view.setRounded()
        
        self.title_label.text = "Studio in Damac Maison Prive"
        
        price_btn.setTitle("One time: $25000k", for: .normal)
        price_btn.layer.cornerRadius = 33/2
        price_btn.titleLabel?.font = CustomFont.semiBoldFont(size: 13)
        price_btn.setTitleColor(UIColor(hex: "#A9A9A9"), for: .normal)
        price_btn.applyGradient(colors: [(UIColor(hex:"#040404") ?? .black).cgColor, (UIColor(hex:"#636363") ?? .gray).cgColor])
        
        price_label.text = "and 1000$ per month"
        price_label.textColor = UIColor(hex: "#999999")
        price_label.font = CustomFont.semiBoldFont(size: 13)
        
        show_full.layer.cornerRadius = 23/2
        show_full.setTitle("Show full description", for: .normal)
        show_full.backgroundColor = UIColor(hex: "#F8F8FA")
        show_full.titleLabel?.font = CustomFont.boldFont(size: 10)
        show_full.setTitleColor(UIColor(hex: "#A3A5A4"), for: .normal)
        
        buy_now.layer.cornerRadius = 45/2
        buy_now.clipsToBounds = true
        buy_now.setTitle("Buy Now", for: .normal)
        buy_now.backgroundColor = UIColor(hex: "#484848")
        buy_now.titleLabel?.font = CustomFont.semiBoldFont(size: 17)
        buy_now.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        
        description_textView.text = fullText
        description_textView.textContainer.maximumNumberOfLines = maxLines
        description_textView.textContainer.lineBreakMode = .byTruncatingTail
        description_textView.isScrollEnabled = false
        description_textView.isUserInteractionEnabled = false
        description_textView.textColor = UIColor(hex: "#999999")
        description_textView.font = CustomFont.semiBoldFont(size: 15)
        
        area_label.text = "Business Bay"
        area_label.font = CustomFont.semiBoldFont(size: 14)
        area_label.textColor = UIColor(hex: "#222222")
        
        property_label.text = "Business Bay"
        property_label.font = CustomFont.semiBoldFont(size: 14)
        property_label.textColor = UIColor(hex: "#222222")
        
        bedrooms_label.text = "Business Bay"
        bedrooms_label.font = CustomFont.semiBoldFont(size: 14)
        bedrooms_label.textColor = UIColor(hex: "#222222")
        
        bathrooms_label.text = "Business Bay"
        bathrooms_label.font = CustomFont.semiBoldFont(size: 14)
        bathrooms_label.textColor = UIColor(hex: "#222222")
        
        service_label.text = "Business Bay"
        service_label.font = CustomFont.semiBoldFont(size: 14)
        service_label.textColor = UIColor(hex: "#222222")
        
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
        
        // Add a little extra padding
        self.fullTextHeight += 20
        
        // Ensure the button is visible if there's more text
        show_full.isHidden = (self.fullTextHeight <= self.initialTextViewHeight)
    }
    
    @IBAction func showFull(_ sender: Any) {
        isExpanded.toggle()
        if isExpanded {
            descriptionTextViewHeightConstraint.constant = fullTextHeight
            description_textView.textContainer.maximumNumberOfLines = 0
            show_full.setTitle("Show Less", for: .normal)
        } else {
            descriptionTextViewHeightConstraint.constant = 91 // Or your initial fixed height
            description_textView.textContainer.maximumNumberOfLines = maxLines
            show_full.setTitle("Show More", for: .normal)
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
            self.showAlert(title:"Can't Buy Now", message: "You already have a pending application.")
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



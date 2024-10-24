import UIKit
import FirebaseFirestore

class HomeScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var apartments: [Apartment] = []
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        fetchApartments()
    }
    
    private func fetchApartments() {
        db.collection("apartments").getDocuments { [weak self] (snapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching apartments: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            
            self.apartments = documents.map { document in
                return Apartment(id: document.documentID, data: document.data())
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           print("HomeScreenVC: numberOfRowsInSection called - returning \(apartments.count)")
           return apartments.count
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 428 // Make sure this matches your cell height in storyboard
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           print("HomeScreenVC: Configuring cell at index \(indexPath.row)")
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell", for: indexPath)
           
           if indexPath.row < apartments.count {
               configureCell(cell, with: apartments[indexPath.row], indexPath: indexPath)
           } else {
               print("HomeScreenVC: Index out of bounds - \(indexPath.row) >= \(apartments.count)")
           }
           
           cell.selectionStyle = .none
           return cell
       }
    
    private func configureCell(_ cell: UITableViewCell, with apartment: Apartment, indexPath:IndexPath) {
        if let containerView = cell.viewWithTag(1) {
            containerView.backgroundColor = UIColor(hex: "#F9FAFB")
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = 20
        }
        
        setupCarouselView(in: cell, with: apartment)
        
        if let titleLabel = cell.viewWithTag(3) as? UILabel {
            titleLabel.text = apartment.name
            titleLabel.font = CustomFont.semiBoldFont(size: 20)
            titleLabel.textColor = UIColor(hex: "#0A0908")
        }
        
        if let subtitleLabel = cell.viewWithTag(4) as? UILabel {
            subtitleLabel.text = "\(apartment.area)"
            subtitleLabel.textColor = UIColor(hex: "#999999")
            subtitleLabel.font = CustomFont.semiBoldFont(size: 13)
        }
        
        if let priceButton = cell.viewWithTag(5) as? UIButton {
            priceButton.setTitle("One time: \(apartment.oneTime)", for: .normal)
            priceButton.layer.cornerRadius = 33/2
            priceButton.setTitleColor(UIColor(hex: "#A9A9A9"), for: .normal)
            priceButton.titleLabel?.font = CustomFont.semiBoldFont(size: 13)
            priceButton.applyGradient(colors: [(UIColor(hex:"#040404") ?? .black).cgColor, (UIColor(hex:"#636363") ?? .gray).cgColor])
            
            _ = TapGestureRecognizer.addTapGesture(to: priceButton) {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ItemDetailsScreenVC") as! ItemDetailsScreenVC
                vc.apartment = self.apartments[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        if let monthlyLabel = cell.viewWithTag(6) as? UILabel {
            monthlyLabel.text = "and \(apartment.perMonth) monthly"
            monthlyLabel.textColor = UIColor(hex: "#999999")
            monthlyLabel.font = CustomFont.semiBoldFont(size: 13)
        }
    }
    
    private func setupCarouselView(in cell: UITableViewCell, with apartment: Apartment) {
        guard let containerView = cell.viewWithTag(2) else {
            print("Error: Could not find view with tag 2")
            return
        }
        
        let carouselView: ImageCarouselView
        if let existingCarouselView = containerView.subviews.first as? ImageCarouselView {
            carouselView = existingCarouselView
        } else {
            carouselView = ImageCarouselView()
            carouselView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(carouselView)
            
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
            carouselView.configure(with: images, topLeftText: "\(apartment.unitsLeft) units left")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ItemDetailsScreenVC") as! ItemDetailsScreenVC
        vc.apartment = apartments[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

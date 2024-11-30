import UIKit
import FirebaseFirestore
import OneSignalFramework

class HomeScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var whatsappView:UIView!
    
    private var apartments: [Apartment] = []
    private let db = Firestore.firestore()
    private var imageTasks: [URLSessionDataTask] = []
    private var isLoadingImages = false
    
    // Image cache
    static var imageCache = NSCache<NSString, UIImage>() {
        didSet {
            imageCache.totalCostLimit = 50 * 1024 * 1024
            imageCache.countLimit = 100
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchApartments()
        requestNotificationsPermission()
        TapGestureRecognizer.addTapGesture(to: whatsappView) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "BottomUpViewController") as! BottomUpViewController
            vc.modalTransitionStyle = .coverVertical
            
            self.present(vc, animated: true)
        }
    }
    
    func requestNotificationsPermission() {
        OneSignal.Notifications.requestPermission({ accepted in
          print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cancelAllImageTasks()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        // Performance optimizations
//        tableView.estimatedRowHeight = ScreenRatioHelper.adjustedHeight(410)
        tableView.layer.drawsAsynchronously = true
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func cancelAllImageTasks() {
        imageTasks.forEach { $0.cancel() }
        imageTasks.removeAll()
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
            
            // Clear existing data first
            self.apartments.removeAll()
            
            self.apartments = documents.map { document in
                return Apartment(id: document.documentID, data: document.data())
            }
            
            self.apartments = self.apartments.reversed()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - TableView Data Source & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apartments.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return ScreenRatioHelper.adjustedHeight(410)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell", for: indexPath)
        
        if indexPath.row < apartments.count {
            configureCell(cell, with: apartments[indexPath.row], indexPath: indexPath)
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    private func configureCell(_ cell: UITableViewCell, with apartment: Apartment, indexPath: IndexPath) {
        // Configure container view
        if let containerView = cell.viewWithTag(1) {
            containerView.backgroundColor = UIColor(hex: "#F9FAFB")
            containerView.clipsToBounds = true
            containerView.layer.cornerRadius = 20
        }
        
        setupCarouselView(in: cell, with: apartment, index:indexPath)
        configureTitleLabel(in: cell, with: apartment)
        configureSubtitleLabel(in: cell, with: apartment)
        configurePriceButton(in: cell, with: apartment, at: indexPath)
        configureMonthlyLabel(in: cell, with: apartment)
    }
    
    private func configureTitleLabel(in cell: UITableViewCell, with apartment: Apartment) {
        if let titleLabel = cell.viewWithTag(3) as? UILabel {
            titleLabel.text = apartment.name
            titleLabel.font = CustomFont.semiBoldFont(size: 20)
            titleLabel.textColor = UIColor(hex: "#0A0908")
        }
    }
    
    private func configureSubtitleLabel(in cell: UITableViewCell, with apartment: Apartment) {
        if let subtitleLabel = cell.viewWithTag(4) as? UILabel {
            subtitleLabel.text = "\(apartment.area)"
            subtitleLabel.textColor = UIColor(hex: "#999999")
            subtitleLabel.font = CustomFont.semiBoldFont(size: 13)
        }
    }
    
    private func configurePriceButton(in cell: UITableViewCell, with apartment: Apartment, at indexPath: IndexPath) {
        if let priceButton = cell.viewWithTag(5) as? UIButton {
            priceButton.setTitle("One time: \(apartment.oneTime)", for: .normal)
            priceButton.layer.cornerRadius = 33/2
            priceButton.setTitleColor(UIColor(hex: "#A9A9A9"), for: .normal)
            priceButton.titleLabel?.font = CustomFont.semiBoldFont(size: 13)
//            priceButton.setBackgroundImage(UIImage(named: "btn_gradient_bg"), for: .normal)
//            priceButton.clipsToBounds = true
            
            priceButton.applyGradient(colors: [
                (UIColor(hex:"#040404") ?? .black).cgColor,
                (UIColor(hex:"#343434") ?? .gray).cgColor,
                (UIColor(hex:"#4B4B4B") ?? .black).cgColor,
                (UIColor(hex:"#575757") ?? .gray).cgColor,
                (UIColor(hex:"#636363") ?? .black).cgColor,
            ])
            
            _ = TapGestureRecognizer.addTapGesture(to: priceButton) { [weak self] in
                self?.navigateToDetails(for: indexPath)
            }
        }
    }
    
    private func configureMonthlyLabel(in cell: UITableViewCell, with apartment: Apartment) {
        if let monthlyLabel = cell.viewWithTag(6) as? UILabel {
            monthlyLabel.text = "and \(apartment.perMonth) monthly"
            monthlyLabel.textColor = UIColor(hex: "#999999")
            monthlyLabel.font = CustomFont.semiBoldFont(size: 13)
        }
    }
    
    private func setupCarouselView(in cell: UITableViewCell, with apartment: Apartment, index: IndexPath) {
        guard let containerView = cell.viewWithTag(2) else {
            print("Error: Could not find view with tag 2")
            return
        }
        
        // Clear existing content before reuse
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        containerView.heightAnchor.constraint(equalToConstant: ScreenRatioHelper.adjustedHeight(265)).isActive = true
        
        let carouselView = ImageCarouselView()
        carouselView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(carouselView)
        
        NSLayoutConstraint.activate([
            carouselView.topAnchor.constraint(equalTo: containerView.topAnchor),
            carouselView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            carouselView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        let processedImageUrls = apartment.imageUrls.flatMap { urlString in
            urlString.split(separator: " ").map(String.init)
        }
        
        loadImages(from: processedImageUrls) { [weak carouselView] images in
            carouselView?.configure(with: images, topLeftText: "\(apartment.unitsLeft) units left")
        }
        
        _ = TapGestureRecognizer.addTapGesture(to: carouselView) { [self] in
            self.navigateToDetails(for: index)
        }
    }
    
    private func loadImages(from urls: [String], completion: @escaping ([UIImage]) -> Void) {
        var images: [UIImage] = []
        let group = DispatchGroup()
        
        for urlString in urls {
            group.enter()
            
            // Check cache first
            if let cachedImage = Self.imageCache.object(forKey: urlString as NSString) {
                images.append(cachedImage)
                group.leave()
                continue
            }
            
            guard let url = URL(string: urlString) else {
                group.leave()
                continue
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                defer { group.leave() }
                
                if let data = data,
                   let image = UIImage(data: data) {
                    // Cache the image
                    Self.imageCache.setObject(image, forKey: urlString as NSString)
                    images.append(image)
                }
            }
            
            imageTasks.append(task)
            task.resume()
        }
        
        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    private func navigateToDetails(for indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "ItemDetailsScreenVC") as? ItemDetailsScreenVC else {
            return
        }
        vc.apartment = apartments[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetails(for: indexPath)
    }
    
    // MARK: - UITableViewDataSourcePrefetching
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard indexPath.row < apartments.count else { continue }
            
            let apartment = apartments[indexPath.row]
            let urls = apartment.imageUrls.flatMap { $0.split(separator: " ").map(String.init) }
            
            for urlString in urls {
                // Skip if image is already cached
                if Self.imageCache.object(forKey: urlString as NSString) != nil {
                    continue
                }
                
                guard let url = URL(string: urlString) else { continue }
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data,
                       let image = UIImage(data: data) {
                        Self.imageCache.setObject(image, forKey: urlString as NSString)
                    }
                }
                
                imageTasks.append(task)
                task.resume()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        // Optional: Implement if you want to cancel specific prefetch tasks
    }
}

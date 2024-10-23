import UIKit

class HomeScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        // Register the cell class if you're not using a prototype cell
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HomeScreenCell")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeScreenCell", for: indexPath)
        
        configureCell(cell, indexpath: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    private func configureCell(_ cell: UITableViewCell, indexpath: IndexPath) {
        if let containerView = cell.viewWithTag(1) {
            containerView.backgroundColor = UIColor(hex: "#F9FAFB")
            containerView.clipsToBounds = true
            containerView.roundCorners(UIRectCorner.allCorners, radius: 20)
        }
        
        setupCarouselView(in: cell)
        
        if let titleLabel = cell.viewWithTag(3) as? UILabel {
            titleLabel.text = "Studio in Damac Maison Prive"
            titleLabel.font = CustomFont.semiBoldFont(size: 20)
            titleLabel.textColor = UIColor(hex: "#0A0908")
        }
        
        if let subtitleLabel = cell.viewWithTag(4) as? UILabel {
            subtitleLabel.text = "Business Bay - Fully Furnished"
            subtitleLabel.textColor = UIColor(hex: "#999999")
            subtitleLabel.font = CustomFont.semiBoldFont(size: 13)
        }
        
        if let priceButton = cell.viewWithTag(5) as? UIButton {
            priceButton.setTitle("One time: $25k", for: .normal)
            priceButton.roundCorners(UIRectCorner.allCorners, radius: 33/2)
            priceButton.setTitleColor(UIColor(hex: "#A9A9A9"), for: .normal)
            priceButton.titleLabel?.font = CustomFont.semiBoldFont(size: 13)
            priceButton.applyGradient(colors: [(UIColor(hex:"#040404") ?? .black).cgColor, (UIColor(hex:"#636363") ?? .gray).cgColor])
        }
        
        if let monthlyLabel = cell.viewWithTag(6) as? UILabel {
            monthlyLabel.text = "and 1,000$ monthly"
            monthlyLabel.textColor = UIColor(hex: "#999999")
            monthlyLabel.font = CustomFont.semiBoldFont(size: 13)
        }
    }
    
    private func setupCarouselView(in cell: UITableViewCell) {
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
        
        let images = [UIImage(named: "onb_one_bg"), UIImage(named: "onb_two_bg"), UIImage(named: "onb_one_bg")].compactMap { $0 }
        carouselView.configure(with: images, topLeftText: "5 units left")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 428
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ItemDetailsScreenVC") as! ItemDetailsScreenVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

import UIKit
import Lottie
import FirebaseAuth
import FirebaseFirestore

class MyHomeVC: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var pageTitle: UILabel!
    
    // Main content view outlets
    @IBOutlet weak var mainContentView: UIView! // Add this container view in storyboard
    @IBOutlet weak var element_one_title: UILabel!
    @IBOutlet weak var element_one_subtitle: UILabel!
    @IBOutlet weak var element_one_progress_view: UIView!
    @IBOutlet weak var element_one_view: UIView!
    
    @IBOutlet weak var progres_one_view: UIView!
    @IBOutlet weak var progres_one_title: UILabel!
    @IBOutlet weak var progres_one_subtitle: UILabel!
    @IBOutlet weak var progres_one_number_label: UILabel!
    
    @IBOutlet weak var progres_two_view: UIView!
    @IBOutlet weak var progres_two_title: UILabel!
    @IBOutlet weak var progres_two_subtitle: UILabel!
    @IBOutlet weak var progres_two_number_label: UILabel!
    
    @IBOutlet weak var progres_three_view: UIView!
    @IBOutlet weak var progres_three_title: UILabel!
    @IBOutlet weak var progres_three_subtitle: UILabel!
    @IBOutlet weak var progres_three_number_label: UILabel!
    
    @IBOutlet weak var steps_label: UILabel!
    
    @IBOutlet weak var element_two_title: UILabel!
    @IBOutlet weak var element_two_subtitle: UILabel!
    @IBOutlet weak var element_two_button: UIButton!
    @IBOutlet weak var element_two_view: UIView!
    
    @IBOutlet weak var element_three_title: UILabel!
    @IBOutlet weak var element_three_subtitle: UILabel!
    @IBOutlet weak var element_three_button: UIButton!
    @IBOutlet weak var element_three_view: UIView!
    
    @IBOutlet weak var element_four_title: UILabel!
    @IBOutlet weak var element_four_subtitle: UILabel!
    @IBOutlet weak var element_four_view: UIView!
    
    @IBOutlet weak var learnMoreLabel: UILabel!
    @IBOutlet weak var learnMoreButton: UIButton!
    
    @IBOutlet weak var whatsappView: UIView!
    
    // MARK: - Properties
    private var progressBarView: ProgressBarView!
    
    // Lazy loaded empty state views
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var animationView: LottieAnimationView = {
        let animation = LottieAnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.contentMode = .scaleAspectFill
        return animation
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No home yet? Yara makes\nowning easier than ever."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = CustomFont.semiBoldFont(size: 15)
        label.textColor = .init(hex: "9D9D9D")
        return label
    }()
    
    private lazy var buyHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Buy Home", for: .normal)
        button.titleLabel?.font = CustomFont.boldFont(size: 14)
        button.setTitleColor(.init(hex: "222222"), for: .normal)
        button.backgroundColor = .init(hex: "F8F8FA")
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(buyHomeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEmptyStateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkApplicationStatus()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        setupMainContent()
        setupProgressView()
        
        TapGestureRecognizer.addTapGesture(to: whatsappView) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "BottomUpViewController") as! BottomUpViewController
//            vc.modalTransitionStyle = .coverVertical
            
            self.present(vc, animated: true)
        }
    }
    
    private func setupMainContent() {
        // Page title
        pageTitle.font = CustomFont.boldFont(size: 22)
        
        // Element one
        element_one_view.layer.cornerRadius = 20
        element_one_title.font = CustomFont.semiBoldFont(size: 15)
        element_one_title.text = "Current Status"
        element_one_title.textColor = .init(hex: "999999")
        element_one_subtitle.font = CustomFont.boldFont(size: 25)
        element_one_subtitle.text = "Waiting for Pre-Approval"
        element_one_subtitle.textColor = .init(hex: "222222")
        element_one_progress_view.layer.cornerRadius = 21/2
        
        // Progress one
        progres_one_view.layer.cornerRadius = 23/2
        progres_one_view.backgroundColor = .init(hex: "FDF5E6")
        progres_one_title.text = "Pre-Approval"
        progres_one_title.font = CustomFont.semiBoldFont(size: 8)
        progres_one_title.textColor = .init(hex: "222222")
        progres_one_subtitle.text = "2-3 weeks"
        progres_one_subtitle.font = CustomFont.semiBoldFont(size: 8)
        progres_one_subtitle.textColor = .init(hex: "999999")
        progres_one_number_label.text = "1"
        progres_one_number_label.font = CustomFont.semiBoldFont(size: 10)
        progres_one_number_label.textColor = .init(hex: "999999")
        
        // Progress two
        progres_two_view.layer.cornerRadius = 23/2
        progres_two_view.backgroundColor = .init(hex: "4690F7")?.withAlphaComponent(0.22)
        progres_two_title.text = "View Property"
        progres_two_title.font = CustomFont.semiBoldFont(size: 8)
        progres_two_title.textColor = .init(hex: "222222")
        progres_two_subtitle.text = "1 week"
        progres_two_subtitle.font = CustomFont.semiBoldFont(size: 8)
        progres_two_subtitle.textColor = .init(hex: "999999")
        progres_two_number_label.text = "2"
        progres_two_number_label.font = CustomFont.semiBoldFont(size: 10)
        progres_two_number_label.textColor = .init(hex: "999999")
        
        // Progress three
        progres_three_view.layer.cornerRadius = 23/2
        progres_three_view.backgroundColor = .init(hex: "35B17B")?.withAlphaComponent(0.5)
        progres_three_title.text = "Purchase"
        progres_three_title.font = CustomFont.semiBoldFont(size: 8)
        progres_three_title.textColor = .init(hex: "222222")
        progres_three_subtitle.text = "1 week"
        progres_three_subtitle.font = CustomFont.semiBoldFont(size: 8)
        progres_three_subtitle.textColor = .init(hex: "999999")
        progres_three_number_label.text = "3"
        progres_three_number_label.font = CustomFont.semiBoldFont(size: 10)
        progres_three_number_label.textColor = .init(hex: "999999")
        
        // Steps label
        steps_label.text = "Step"
        steps_label.font = CustomFont.boldFont(size: 16)
        steps_label.textColor = .init(hex: "9D9D9D")
        
        // Element two
        element_two_view.layer.cornerRadius = 20
        element_two_view.addLightShadow()
        element_two_title.text = "1- Pre-Approval"
        element_two_title.font = CustomFont.semiBoldFont(size: 18)
        element_two_title.textColor = .init(hex: "222222")
        element_two_subtitle.text = "Mortgage pre-approval means getting approved for a loan from the bank to buy a property."
        element_two_subtitle.font = CustomFont.semiBoldFont(size: 13)
        element_two_subtitle.textColor = .init(hex: "999999")
        element_two_button.setTitle("View Terms", for: .normal)
        element_two_button.titleLabel?.font = CustomFont.semiBoldFont(size: 12)
        element_two_button.layer.cornerRadius = 33/2
        element_two_button.backgroundColor = .init(hex: "F9FAFB")
        element_two_button.setTitleColor(UIColor(hex: "999999"), for: .normal)
        
        // Element three
        element_three_view.layer.cornerRadius = 20
        element_three_view.addLightShadow()
        element_three_title.text = "2- View Property"
        element_three_title.font = CustomFont.semiBoldFont(size: 18)
        element_three_title.textColor = .init(hex: "222222")
        element_three_subtitle.text = "Our agent will contact you to schedule a viewing and finalize the purchase process."
        element_three_subtitle.font = CustomFont.semiBoldFont(size: 13)
        element_three_subtitle.textColor = .init(hex: "999999")
        element_three_button.setTitle("Schedule", for: .normal)
        element_three_button.titleLabel?.font = CustomFont.semiBoldFont(size: 12)
        element_three_button.layer.cornerRadius = 33/2
        element_three_button.backgroundColor = .init(hex: "F9FAFB")
        element_three_button.setTitleColor(UIColor(hex: "999999"), for: .normal)
        
        // Element four
        element_four_view.layer.cornerRadius = 20
        element_four_view.addLightShadow()
        element_four_title.text = "3- Purchase"
        element_four_title.font = CustomFont.semiBoldFont(size: 18)
        element_four_title.textColor = .init(hex: "222222")
        element_four_subtitle.text = "After purchase, you pay the monthly mortgage directly to the bank instead of rent. You can sell the property and close the mortgage at any time."
        element_four_subtitle.font = CustomFont.semiBoldFont(size: 13)
        element_four_subtitle.textColor = .init(hex: "999999")
        
        // Learn more section
        learnMoreLabel.text = "100% Free. No hidden fees."
        learnMoreLabel.textColor = UIColor(hex: "#999999")
        learnMoreLabel.font = CustomFont.semiBoldFont(size: 10)
        learnMoreButton.setTitle("Learn more", for: .normal)
        learnMoreButton.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        learnMoreButton.titleLabel?.font = CustomFont.semiBoldFont(size: 10)
        learnMoreButton.backgroundColor = UIColor(hex: "#F9FAFB")
        
        // Initially hide main content
        mainContentView.isHidden = true
    }
    
    private func setupEmptyStateView() {
        // Add empty state view
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(animationView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(buyHomeButton)
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 20),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            animationView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -130),
            animationView.widthAnchor.constraint(equalToConstant: 344),
            animationView.heightAnchor.constraint(equalToConstant: 233),
            
            emptyStateLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            buyHomeButton.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 20),
            buyHomeButton.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            buyHomeButton.widthAnchor.constraint(equalToConstant: 110),
            buyHomeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupProgressView() {
        element_one_progress_view.subviews.forEach { $0.removeFromSuperview() }
        
        progressBarView = ProgressBarView(frame: CGRect(x: 0, y: 0, width: element_one_progress_view.bounds.width, height: 21))
        progressBarView.translatesAutoresizingMaskIntoConstraints = false
        element_one_progress_view.addSubview(progressBarView)
        
        NSLayoutConstraint.activate([
            progressBarView.leadingAnchor.constraint(equalTo: element_one_progress_view.leadingAnchor),
            progressBarView.trailingAnchor.constraint(equalTo: element_one_progress_view.trailingAnchor),
            progressBarView.centerYAnchor.constraint(equalTo: element_one_progress_view.centerYAnchor),
            progressBarView.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    // MARK: - Status Methods
    private func checkApplicationStatus() {
        guard let userId = Auth.auth().currentUser?.uid else {
            showEmptyState()
            return
        }
        
        let db = Firestore.firestore()
        db.collection("applications")
            .whereField("userID", isEqualTo: userId)
            .limit(to: 1)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error getting documents: \(error)")
                    self.showEmptyState()
                    return
                }
                
                if let documents = snapshot?.documents, !documents.isEmpty {
                    // Application exists, show main content
                    self.showMainContent()
                    
                    // Update progress based on status if needed
                    if let status = documents.first?.data()["status"] as? String {
                        switch status {
                        case "1":
                            self.updateProgress(to: 1)
                        case "2":
                            self.updateProgress(to: 2)
                        case "3":
                            self.updateProgress(to: 3)
                        default:
                            self.updateProgress(to: 1)
                        }
                    }
                } else {
                    // No application found, show empty state
                    self.showEmptyState()
                }
            }
    }
    
    private func showEmptyState() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Hide main content first
            self.mainContentView.isHidden = true
            self.emptyStateView.isHidden = false
            
            // Setup and play animation only if needed
            if self.animationView.animation == nil {
                self.animationView.animation = LottieAnimation.named("lottie_empty_esim")
                self.animationView.loopMode = .loop
                self.animationView.play()
            }
        }
    }
    
    private func showMainContent() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Stop and clear animation to free memory
            self.animationView.stop()
            self.animationView.animation = nil
            
            self.emptyStateView.isHidden = true
            self.mainContentView.isHidden = false
            
            // Initialize progress if needed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.progressBarView?.animateProgress(to: 1)
            }
        }
    }
    
    func updateProgress(to stage: Int) {
        progressBarView?.animateProgress(to: stage)
        
        // Update UI to reflect current stage
        switch stage {
        case 1:
            element_one_subtitle.text = "Pre-Approval"
        case 2:
            element_one_subtitle.text = "View Property"
        case 3:
            element_one_subtitle.text = "Purchase"
        default:
            break
        }
    }
    
    @objc private func buyHomeButtonTapped() {
        self.toMain(index: 0)
    }
    
    // MARK: - Memory Management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Clear animation if not visible
        if emptyStateView.isHidden {
            animationView.animation = nil
        }
    }
    
    deinit {
        // Clean up animations and views
        animationView.stop()
        animationView.animation = nil
        progressBarView = nil
    }
}

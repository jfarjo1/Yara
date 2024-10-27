import UIKit

class ImageCarouselView: UIView {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "#D9D9D9")
        pageControl.pageIndicatorTintColor = UIColor(hex: "#D9D9D9")?.withAlphaComponent(0.2)
        
        if #available(iOS 14.0, *) {
            let dotSize = CGSize(width: 6, height: 6)
            let spacing: CGFloat = 0 // Adjust this value to control spacing
            
            // Create dot images with built-in spacing
            let normalDot = UIImage.circularImage(
                size: CGSize(width: dotSize.width + spacing, height: dotSize.height),
                dotSize: dotSize,
                color: UIColor(hex: "#D9D9D9")?.withAlphaComponent(0.8) ?? .gray
            )
            
            let selectedDot = UIImage.circularImage(
                size: CGSize(width: dotSize.width + spacing, height: dotSize.height),
                dotSize: dotSize,
                color: UIColor(hex: "#D9D9D9") ?? .white
            )
            
            pageControl.preferredIndicatorImage = normalDot
            pageControl.preferredCurrentPageIndicatorImage = selectedDot
        }
        
        return pageControl
    }()
    
    private let topLeftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = CustomFont.semiBoldFont(size: 13)
        label.textColor = UIColor(hex: "#000000")?.withAlphaComponent(0.22)
        label.backgroundColor = UIColor(hex: "#FFFFFF")?.withAlphaComponent(0.33)
        label.layer.cornerRadius = 13.5
        label.clipsToBounds = true
        return label
    }()
    
    private var imageViews: [UIImageView] = []
    private var topLeftLabelConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        addSubview(pageControl)
        addSubview(topLeftLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        topLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        topLeftLabelConstraints = [
            topLeftLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            topLeftLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topLeftLabel.widthAnchor.constraint(equalToConstant: 79),
            topLeftLabel.heightAnchor.constraint(equalToConstant: 27)
        ]
        NSLayoutConstraint.activate(topLeftLabelConstraints)
        
        scrollView.delegate = self
    }
    
    func configure(with images: [UIImage], topLeftText: String?) {
        // Remove existing image views
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        
        // Add new image views
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)
            imageViews.append(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            ])
            
            if index == 0 {
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            } else {
                imageView.leadingAnchor.constraint(equalTo: imageViews[index - 1].trailingAnchor).isActive = true
            }
            
            if index == images.count - 1 {
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            }
        }
        
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(images.count)).isActive = true
        
        // Set the content size explicitly
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(images.count), height: scrollView.frame.height)
        
        pageControl.numberOfPages = images.count
        
        if let topLeftText = topLeftText {
            topLeftLabel.text = topLeftText
            showTopLeftLabel()
        } else {
            hideTopLeftLabel()
        }
        
        layoutIfNeeded()
    }
    
    func showTopLeftLabel() {
        topLeftLabel.isHidden = false
        NSLayoutConstraint.activate(topLeftLabelConstraints)
    }
    
    func hideTopLeftLabel() {
        topLeftLabel.isHidden = true
        NSLayoutConstraint.deactivate(topLeftLabelConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure content size is correct after layout
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(imageViews.count), height: scrollView.frame.height)
    }
}

extension ImageCarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        // Force horizontal-only scrolling
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
}

extension UIImage {
    static func circularImage(size: CGSize, dotSize: CGSize, color: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.setStrokeColor(UIColor.clear.cgColor)
            let rect = CGRect(x: 0, y: 0, width: dotSize.width, height: dotSize.height)
            context.cgContext.addEllipse(in: rect)
            context.cgContext.drawPath(using: .fill)
        }
    }
}

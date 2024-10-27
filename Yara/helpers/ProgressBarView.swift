import UIKit

class ProgressBarView: UIView {
    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    
    // Define colors to match the outlet views
    private let stageOneColor = UIColor(hex: "FDF5E6") ?? .orange
    private let stageTwoColor = UIColor(hex: "4690F7")?.withAlphaComponent(0.22) ?? .blue
    private let stageThreeColor = UIColor(hex: "35B17B")?.withAlphaComponent(0.5) ?? .green
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        // Background track - now white
        backgroundLayer.strokeColor = UIColor.white.cgColor
        backgroundLayer.fillColor = nil
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)
        
        // Progress layer - start with stage one color
        progressLayer.strokeColor = stageOneColor.cgColor
        progressLayer.fillColor = nil
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0 // Start at 0
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth: CGFloat = 21
        let pathInset = lineWidth / 2
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: pathInset, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.width - pathInset, y: bounds.midY))
        
        backgroundLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        
        backgroundLayer.lineWidth = lineWidth
        progressLayer.lineWidth = lineWidth
    }
    
    func animateProgress(to stage: Int) {
        let progress: CGFloat
        let color: UIColor
        
        switch stage {
        case 1:
            progress = 0.33
            color = stageOneColor
        case 2:
            progress = 0.66
            color = stageTwoColor
        case 3:
            progress = 1.0
            color = stageThreeColor
        default:
            progress = 0
            color = stageOneColor
        }
        
        // Reset progress to start if going backwards
        if progressLayer.strokeEnd > progress {
            progressLayer.strokeEnd = 0
        }
        
        // Animate progress from current position
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        progressAnimation.duration = 0.8
        progressAnimation.fromValue = progressLayer.strokeEnd // Start from current position
        progressAnimation.toValue = progress
        progressAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.strokeEnd = progress
        
        // Animate color
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.duration = 0.8
        colorAnimation.fromValue = progressLayer.strokeColor
        colorAnimation.toValue = color.cgColor
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        progressLayer.strokeColor = color.cgColor
        
        // Add animations to layer
        progressLayer.add(progressAnimation, forKey: "progressAnimation")
        progressLayer.add(colorAnimation, forKey: "colorAnimation")
    }
    
    // Add method to reset progress
    func resetProgress() {
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = stageOneColor.cgColor
    }
}

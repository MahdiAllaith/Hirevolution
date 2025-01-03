import UIKit

class AnimatedBlobView: UIView {
    
    private let blobLayer = CAShapeLayer()
    private var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    private var rotationAngle: CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlobLayer()
        startBlobAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBlobLayer()
        startBlobAnimation()
    }
    
    private func setupBlobLayer() {
        // Set up gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor(named: "Blue")?.cgColor ?? UIColor.yellow.cgColor,
                                UIColor(named: "BaseApp")?.cgColor ?? UIColor.gray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, 1]

        // Mask the gradient layer with the blob shape
        blobLayer.lineWidth = 0
        blobLayer.frame = bounds
        gradientLayer.mask = blobLayer
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        blobLayer.frame = bounds
        blobLayer.path = createBlobPath(angle1: 1.0, angle2: 1.0).cgPath
    }
    
    private func createBlobPath(angle1: CGFloat, angle2: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let width = 390.0
        let height = 414.0
        
        path.move(to: CGPoint(x: 0.9923 * width, y: 0.42593 * height))
        path.addCurve(to: CGPoint(x: 0.6355 * width * angle2, y: height),
                      controlPoint1: CGPoint(x: 0.92554 * width * angle2, y: 0.77749 * height * angle2),
                      controlPoint2: CGPoint(x: 0.91864 * width * angle2, y: height))
        path.addCurve(to: CGPoint(x: 0.08995 * width, y: 0.60171 * height),
                      controlPoint1: CGPoint(x: 0.35237 * width * angle1, y: height),
                      controlPoint2: CGPoint(x: 0.2695 * width, y: 0.77304 * height))
        path.addCurve(to: CGPoint(x: 0.34086 * width, y: 0.06324 * height * angle1),
                      controlPoint1: CGPoint(x: -0.0896 * width, y: 0.43038 * height),
                      controlPoint2: CGPoint(x: 0.00248 * width, y: 0.23012 * height * angle1))
        path.addCurve(to: CGPoint(x: 0.9923 * width, y: 0.42593 * height),
                      controlPoint1: CGPoint(x: 0.67924 * width, y: -0.10364 * height * angle1),
                      controlPoint2: CGPoint(x: 1.05906 * width, y: 0.07436 * height * angle2))
        path.close()
        
        return path
    }
    
    // Function to start the animation explicitly
    func startBlobAnimation() {
        startTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(updateBlobPath))
        displayLink?.add(to: .main, forMode: .default)
        
        // Set the anchorPoint to the center for rotation around the blob's center
        blobLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        blobLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        // Set up a 360-degree continuous rotation animation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2 // 360 degrees in radians
        rotationAnimation.duration = 20.0 // 20 seconds for a full rotation
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        blobLayer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    @objc private func updateBlobPath() {
        let elapsedTime = CACurrentMediaTime() - startTime
        // Correct the angles to match the animation
        let angle1 = CGFloat(cos((elapsedTime.remainder(dividingBy: 3) * 60) * .pi / 180))
        let angle2 = CGFloat(cos((elapsedTime.remainder(dividingBy: 6) * 10) * .pi / 180))
        
        // Update the blob shape path
        blobLayer.path = createBlobPath(angle1: angle1, angle2: angle2).cgPath
    }

    deinit {
        displayLink?.invalidate()
    }
}

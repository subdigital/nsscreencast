//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

extension UIImage {
    func tintedImageUsingColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: drawRect)
        
        tintColor.set()
        UIRectFillUsingBlendMode(drawRect, CGBlendMode.sourceAtop)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return tintedImage
    }
}


class CircularProgressLayer : CAShapeLayer {
    
    var progress: CGFloat = 0 {
        didSet {
            update()
        }
    }
    
    var fillLayer: CAShapeLayer!
    var color: UIColor = .lightGray {
        didSet {
            strokeColor = color.cgColor
            fillLayer.fillColor = color.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setupLayer()
    }
    
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        _setupLayer()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    private func _setupLayer() {
        isOpaque = false
        lineWidth = 2
        strokeColor = color.cgColor
        fillColor = UIColor.clear.cgColor
        
        fillLayer = CAShapeLayer()
        fillLayer.fillColor = color.cgColor
        addSublayer(fillLayer)
        update()
    }
    
    func update() {
        path = UIBezierPath(ovalIn: bounds).cgPath
        
        let fillPath = UIBezierPath()
        let radius = frame.size.height/2
        let center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        fillPath.move(to: center)
        
        //  |
        //  O -
        //
        
        let startAngle: CGFloat = -.pi/2
        let endAngle: CGFloat = (2 * .pi ) * progress + startAngle
        fillPath.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        fillLayer.path = fillPath.cgPath
    }
}

let cpl = CircularProgressLayer(frame: CGRect(x: 10, y: 10, width: 100, height: 100))


class DownloadButton : UIControl {
    lazy var downloadImage = UIImage(named: "Download")!
    lazy var completedImage = UIImage(named: "Checkmark")!
    
    var imageStates: [UInt : UIImage] = [:]
    
    var imageView: UIImageView!
    var progressLayer: CircularProgressLayer!
    
    var progress: CGFloat {
        get { return progressLayer.progress }
        set { progressLayer.progress = newValue }
    }
    
    enum RenderState {
        case Pending
        case Downloading
        case Completed
        
        func configureUI(button: DownloadButton) {
            switch self {
            case .Downloading:
                UIView.animate(withDuration: 0.5) {
                    button.imageView.alpha = 0
                    button.imageView.transform = button.imageView.transform.scaledBy(x: 0.5, y: 0.5)
                    button.progressLayer.opacity = 1
                }
            case .Completed:
                button.animate(to: button.completedImage)
            case .Pending:
                button.animate(to: button.downloadImage)
            }
        }
    }
    
    private func animate(to image: UIImage) {
        imageView.image = image
        UIView.animate(withDuration: 0.5) {
            self.imageView.alpha = 1
            self.imageView.transform = .identity
            self.progressLayer.opacity = 0
        }
    }
    
    var renderState: RenderState = .Pending {
        didSet {
            renderState.configureUI(button: self)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setupButton()
    }
    
    private func _setupButton() {
        imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFit
        set(image: downloadImage)
        addSubview(imageView)
        
        progressLayer = CircularProgressLayer(frame: bounds.insetBy(dx: 3, dy: 3))
        progressLayer.color = .black
        progressLayer.opacity = 0
        layer.addSublayer(progressLayer)
        
        addTarget(self, action: #selector(DownloadButton.addHighlight), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(DownloadButton.removeHighlight), for: [.touchUpInside, .touchDragExit])
        addTarget(self, action: #selector(DownloadButton.tap), for: [.touchUpInside])
    }
    
    func tap() {
        switch renderState {
        case .Pending:
            progress = 0
            renderState = .Downloading
            tick()
        case .Downloading: fallthrough
        case .Completed:
            renderState = .Pending
        }
    }
    
    
    func tick() {
        guard renderState == .Downloading else {
            return
        }
        guard progress <= 1.0 else {
            renderState = .Completed
            return
        }
        progress += 0.018
        DispatchQueue.main.async {
            Thread.sleep(forTimeInterval: 0.01)
            self.tick()
        }
    }

    
    private func set(image: UIImage) {
        imageStates[UIControlState.normal.rawValue] = image
        imageStates[UIControlState.highlighted.rawValue] = highlighted(image: image)
        imageView.image = image
    }
    
    private func highlighted(image: UIImage) -> UIImage {
        return image.tintedImageUsingColor(tintColor: .darkGray)
    }
    
    func addHighlight() {
        imageView.image = imageStates[UIControlState.highlighted.rawValue]
        imageView.transform = imageView.transform.scaledBy(x: 0.95, y: 0.95)
    }
    
    func removeHighlight() {
        imageView.image = imageStates[UIControlState.normal.rawValue]
        imageView.transform = .identity
    }
}

let button = DownloadButton(frame: CGRect(x: 10, y: 10, width: 320, height: 320))

let view = UIView(frame: button.bounds.insetBy(dx: -10, dy: -10))
view.backgroundColor = UIColor.white
view.addSubview(button)

let page = PlaygroundPage.current
page.liveView = view

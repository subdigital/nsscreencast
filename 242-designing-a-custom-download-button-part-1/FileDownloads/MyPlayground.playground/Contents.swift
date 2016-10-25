//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

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
    lazy var downloadImage = UIImage(named: "Download")
    lazy var completedImage = UIImage(named: "Checkmark")
    
    var imageView: UIImageView!
    
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
        imageView.image = downloadImage
        addSubview(imageView)
        
        addTarget(self, action: #selector(DownloadButton.addHighlight), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(DownloadButton.removeHighlight), for: [.touchUpInside, .touchDragExit])
    }
    
    func addHighlight() {
        backgroundColor = .red
    }
    
    func removeHighlight() {
        backgroundColor = .clear
    }
}

let button = DownloadButton(frame: CGRect(x: 10, y: 10, width: 32, height: 32))

let view = UIView(frame: button.bounds.insetBy(dx: -10, dy: -10))
view.backgroundColor = UIColor.white
view.addSubview(button)
// view.layer.addSublayer(cpl)

func tick() {
    guard cpl.progress <= 1.0 else { return }
    cpl.progress += 0.018
    DispatchQueue.main.async {
        Thread.sleep(forTimeInterval: 0.01)
        tick()
    }
}


let page = PlaygroundPage.current
page.liveView = view

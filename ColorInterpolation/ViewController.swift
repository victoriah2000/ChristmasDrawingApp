//
//  ViewController.swift
//  ColorInterpolation
//
//  Created by Joshua Homann on 12/3/17.
//  Copyright © 2017 Joshua Homann. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // MARK: Snowflakes & Sounds
    
    @IBOutlet weak var Tree: UIButton!
     var treeSound = AVPlayer(name: "Tree", extension: "m4a")!
    
    @IBOutlet weak var Christmas: UIButton!
      var christmasSound = AVPlayer(name: "Christmas", extension: "m4a")!
    
    @IBOutlet weak var Linus: UIButton!
      var linusSound = AVPlayer(name: "Linus", extension: "m4a")!
    
    // MARK: Snowflake Actions
    
    @IBAction func tapTree(_ sender: UIButton) {
        treeSound.play()

    }
    
    
    @IBAction func tapChristmas(_ sender: UIButton) {
       christmasSound.play()
    }
    
    
    @IBAction func tapLinus(_ sender: UIButton) {
        linusSound.play()
    }
    
    
    
    // MARK: - Variables
  private lazy var imageRenderer: UIGraphicsImageRenderer = {
    return UIGraphicsImageRenderer(bounds: view.bounds)
  }()
  private var views: [UIView] = []
  private var viewIndex = 0
  private var previousPoint: CGPoint = .zero
  private var colorIndex = 0
  private var deltaColor: CGFloat = 0
  private var timer = Timer()

  // MARK: - Constants
  private let repeatLength: CGFloat = 1000
  private let minimumStrokeWidth: CGFloat = 10
  private let maximumStrokeWidth: CGFloat = 100
  private let colors: [UIColor] = [.cyan, .blue, .purple, .magenta, .red, .orange, .yellow]

  // MARK: - UIViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    views = (0..<10).map { _ in UIView() }
    views.forEach { view in
      self.view.addSubview(view)
      view.isUserInteractionEnabled = false
      view.translatesAutoresizingMaskIntoConstraints = false
      let attributes: [NSLayoutAttribute] = [.top,.bottom, .leading, .trailing]
      NSLayoutConstraint.activate( attributes.map {NSLayoutConstraint(item: view, attribute: $0, relatedBy: .equal, toItem: self.view, attribute: $0, multiplier: 1, constant: 0)})
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    timer.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      UIView.animate(withDuration: 10) {
        self.views[self.viewIndex].alpha = 0
      }
      self.viewIndex = (self.viewIndex + 1) % self.views.count
      self.views[self.viewIndex].layer.contents = nil
      self.views[self.viewIndex].alpha = 1
    }
  }

  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    guard motion == .motionShake else {
      return
    }
    UIView.animate(withDuration: 0.25, animations: {
      self.view.alpha = 0
    }, completion: { _ in
      self.views.forEach{ $0.layer.contents = nil }
      self.view.alpha = 1
    })

  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let location = touches.first?.location(in: view) else {
      return
    }
    previousPoint = location
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let destinationView = views[viewIndex]
    let strokeWidth: CGFloat
    if view.traitCollection.forceTouchCapability == .available {
      strokeWidth = minimumStrokeWidth.lerp(to: maximumStrokeWidth, alpha: touch.force / touch.maximumPossibleForce)
    } else {
      strokeWidth = minimumStrokeWidth * 2
    }
    let point = touch.location(in: view)
    let distance = hypot(point.x - previousPoint.x, point.y - previousPoint.y)
    deltaColor = CGFloat(fmod(Double(deltaColor + distance), Double(repeatLength)))
    let color = colorFor(proportion: deltaColor / repeatLength)
    let image = imageRenderer.image { imageContext in
      let context = imageContext.cgContext
      destinationView.layer.render(in: context)
      let path = CGMutablePath()
      path.move(to: previousPoint)
      path.addLine(to: point)
      context.addPath(path)
      context.setLineWidth(strokeWidth)
      context.setLineCap(.round)
      color.setStroke()
      context.strokePath()
      previousPoint = point
    }
    destinationView.layer.contents = image.cgImage
    view.bringSubview(toFront: destinationView)
  }

  // MARK: Instance Methods
  private func colorFor(proportion: CGFloat) -> UIColor {
    let count = CGFloat(colors.count)
    let lowerIndex = Int(proportion * count)
    let upperIndex = (lowerIndex + 1) % colors.count
    let remainder = proportion * count - CGFloat(lowerIndex)
    return colors[lowerIndex].mix(with: colors[upperIndex], proportion: remainder)
  }

}


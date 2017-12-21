//
//  ViewController.swift
//  ColorInterpolation
//
//  Created by Joshua Homann on 12/3/17.
//  Copyright © 2017 Joshua Homann. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
  
  @IBOutlet weak var lineView: LineView!
  @IBOutlet weak var tree: UIButton!
  @IBOutlet weak var christmas: UIButton!
  @IBOutlet weak var linus: UIButton!
  
  let rainbow: [UIColor] = [.cyan, .blue, .purple, .magenta, .red, .orange, .yellow, .green]
  let unicorn: [UIColor] = [#colorLiteral(red: 0.5904536247, green: 0.9067943692, blue: 0.8544989228, alpha: 1), #colorLiteral(red: 1, green: 0.9334384799, blue: 0.6482861638, alpha: 1), #colorLiteral(red: 0.9999960065, green: 0.7974424958, blue: 0.6593983173, alpha: 1), #colorLiteral(red: 1, green: 0.6714395881, blue: 1, alpha: 1), #colorLiteral(red: 0.9993742108, green: 0.6679262519, blue: 0.6711266041, alpha: 1)]
  let charlieBrown: [UIColor] = [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)]
  let treeSound = AVPlayer(name: "Tree", extension: "m4a")!
  let christmasSound = AVPlayer(name: "Christmas", extension: "m4a")!
  let linusSound = AVPlayer(name: "Linus", extension: "m4a")!
  
  
  @IBAction func tapButton(_ sender: UIButton) {
    treeSound.pause()
    christmasSound.pause()
    linusSound.pause()
    switch sender {
    case tree:
      treeSound.playFromStart()
      lineView.colors = rainbow
    case christmas:
      christmasSound.playFromStart()
      lineView.colors = unicorn
    case linus:
      linusSound.playFromStart()
      lineView.colors = charlieBrown
    default:
      break
    }
  }
  
}



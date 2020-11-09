//
//  ViewControllerDetail.swift
//  LifeDistance
//
//  Created by Marino Schmid on 08.11.20.
//

import UIKit
import SpriteKit
import Hero

class ViewControllerDetail: UIViewController {

    @IBOutlet weak var skview: SKView!
    var id : Int = 0;
    var scene : SKScene = SKScene(size: CGSize(width: 5, height: 5));
    var colors : [UIColor] = [UIColor.red, .green, .gray, .black, .brown, .yellow]
    override func viewDidLoad() {
        self.hero.isEnabled = true

        super.viewDidLoad()
        scene.scaleMode = .aspectFit
        skview.presentScene(scene)
        skview.hero.id = "transition\(id)";

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func closeme(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

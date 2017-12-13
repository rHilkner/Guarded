//
//  CustomTabBarController.swift
//  Guarded
//
//  Created by Filipe Marques on 25/10/17.
//  Copyright © 2017 Rodrigo Hilkner. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let items = self.tabBar.items {
            let button = items[2]
            let color = UIColor(red: 232.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            
            let titleItem: NSDictionary = [NSAttributedStringKey.foregroundColor: color]
            
            button.image = button.image?.tabBarImageWithCustomTint(tintColor:color)
            button.selectedImage = button.selectedImage?.tabBarImageWithCustomTint(tintColor: color)
            
            button.setTitleTextAttributes(titleItem as? [NSAttributedStringKey : Any], for: .normal)
            button.setTitleTextAttributes(titleItem as? [NSAttributedStringKey : Any], for: .selected)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage {
    func tabBarImageWithCustomTint(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode(rawValue: 1)!)
        let rect: CGRect = CGRect(x: 0, y: 0, width:  self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        newImage = newImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        return newImage
    }
}

extension CustomTabBarController:UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.tabBar.selectedItem == tabBarController.tabBar.items![2] {
            let storyboard = UIStoryboard(name: "Help", bundle: nil)
            if let controller = storyboard.instantiateViewController(withIdentifier: "helpScreen") as? HelpViewController {
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .crossDissolve
                self.present(controller, animated: true, completion: nil)
            }
            return false
        } else {
            return true
        }
    }
}


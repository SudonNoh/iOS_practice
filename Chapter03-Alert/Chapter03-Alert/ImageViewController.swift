//
//  ImageViewController.swift
//  Chapter03-Alert
//
//  Created by Sudon Noh on 2023/01/11.
//

import UIKit

class ImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let icon = UIImage(named: "rating5")
        let iconV = UIImageView(image: icon)
        
        iconV.frame = CGRect(
            x: 0,
            y: 0,
            width: (icon?.size.width)!,
            height: (icon?.size.height)!
        )
        
        self.view.addSubview(iconV)
        
        self.preferredContentSize = CGSize(
            width: (icon?.size.width)!,
            height: (icon?.size.height)!+10
        )
        
    }

}

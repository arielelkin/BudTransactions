//
//  DefaultNavController.swift
//  BudTransactions
//
//  Created by Ariel Elkin on 20/05/2019.
//  Copyright © 2019 ariel. All rights reserved.
//

import UIKit

class DefaultNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.barTintColor = .black
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

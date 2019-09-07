//
//  DetailViewController.swift
//  Cachy
//
//  Created by sadman samee on 9/5/19.
//  Copyright © 2019 sadman samee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        print("~~~~~~~~~~~~~~~~~~DetailViewController 1")
        // dump(CachyManager.shared.maxConcurrentOperationCount)
        print("~~~~~~~~~~~~~~~~~~ DetailViewController 2")
        // CachyManager.shared.configure(maxConcurrentOperationCount: 25, diskPath: "image")
        print("~~~~~~~~~~~~~~~~~~ DetailViewController 3")
        // dump(CachyManager.shared.maxConcurrentOperationCount)
        print("~~~~~~~~~~~~~~~~~~ DetailViewController 4")
    }
}

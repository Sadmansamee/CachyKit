//
//  Extension+Cell.swift
//  CachyDemo
//
//  Created by sadman samee on 9/7/19.
//  Copyright © 2019 sadman samee. All rights reserved.
//

import UIKit

extension UITableViewCell: XIBIdentifiable {}

extension UICollectionViewCell: XIBIdentifiable {}

protocol XIBIdentifiable {
    static var id: String { get }
    static var nib: UINib { get }
}

extension XIBIdentifiable {
    static var id: String {
        return String(describing: Self.self)
    }

    static var nib: UINib {
        return UINib(nibName: id, bundle: nil)
    }
}

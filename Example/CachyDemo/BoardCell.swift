//
//  BoardCell.swift
//  CachyDemo
//
//  Created by sadman samee on 9/7/19.
//  Copyright © 2019 sadman samee. All rights reserved.
//

import UIKit

class BoardCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }

    var board: Board? {
        didSet {
            if let board = board, let urls = board.urls, let thumb = urls.thumb, let url = URL(string: thumb) {
                imageView.cachyImageLoad(url, isShowLoading: true, completionBlock: { _, _ in })
            }
        }
    }
}

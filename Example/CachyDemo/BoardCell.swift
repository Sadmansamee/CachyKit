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
    let cachy = CachyLoader()

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
    }

    var board: Board? {
        didSet {
            if let board = board, let urls = board.urls, let thumb = urls.regular, let url = URL(string: thumb) {
                let request = URLRequest(url: url)
                cachy.loadWithURLRequest(request) { [weak self] data, _ in
                    self?.imageView.image = UIImage(data: data, scale: 1.0)
                }
                // imageView.cachyImageLoad(url, isShowLoading: true, completionBlock: { _, _ in })
            }
        }
    }
}

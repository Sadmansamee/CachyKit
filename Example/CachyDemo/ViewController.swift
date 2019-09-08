//
//  ViewController.swift
//  Cachy
//
//  Created by sadman samee on 9/4/19.
//  Copyright © 2019 sadman samee. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    let cachy = CachyLoader()

    var boards: [Board] = [Board]()
    let cellSizes: [CGFloat] = [180, 200, 220,240,260]
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.darkGray

        return refreshControl
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        fetchData()
    }

    private func fetchData(isRefresh _: Bool = false) {
        cachy.load(url: URL(string: Constant.Url.base)!) { [weak self] data, _ in
            let decoder = JSONDecoder()
            do {
                let boards = try decoder.decode([Board].self, from: data)
                if let _self = self {
                    _self.boards = boards
                    _self.collectionView?.reloadData()
                }

            } catch {
                debugPrint("Error occurred")
            }
        }
    }

    private func setUI() {
        title = "Minderest"
        collectionView?.register(BoardCell.nib, forCellWithReuseIdentifier: BoardCell.id)

        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 16, left: 8, bottom: 8, right: 8)
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView?.addSubview(refreshControl)
    
    }

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchData(isRefresh: true)
        refreshControl.endRefreshing()
    }
}

extension ViewController {
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return boards.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCell.id, for: indexPath) as? BoardCell else { return UICollectionViewCell() }

        cell.board = boards[indexPath.item]

        return cell
    }
}

// MARK: - PINTEREST LAYOUT DELEGATE

extension ViewController: PinterestLayoutDelegate {
    func collectionView(_: UICollectionView, heightForPhotoAtIndexPath _: IndexPath) -> CGFloat {
        guard let size = cellSizes.randomElement() else {
            return 120
        }

        return size
    }
}

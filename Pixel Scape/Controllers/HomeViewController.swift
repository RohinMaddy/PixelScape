//
//  HomeViewController.swift
//  Pixel Scape
//
//  Created by Rohin Madhavan on 18/03/2025.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    private let viewModel = HomeViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private let layout = PixelFlowLayout()
    private let refreshControl = UIRefreshControl()
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupImageCollectionView()
        searchView.layer.cornerRadius = 10
        applyBindings(in: &subscriptions)
        setupTextField()
        
        refreshControl.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        imageCollectionView.alwaysBounceVertical = true
        imageCollectionView.refreshControl = refreshControl
    }
    
    func setupTextField() {
        searchTextField.placeholder = "Looking for anything specific?"
        if let placeholder = searchTextField.placeholder {
            
            searchTextField.attributedPlaceholder = NSAttributedString(string:placeholder,
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.textShade])
        }
    }
    
    func applyBindings(in subscriptions: inout Set<AnyCancellable>) {
        viewModel.$imageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.imageCollectionView.reloadData()
            }
            .store(in: &subscriptions)
        viewModel.$searchText
            .assign(to: \.text, on: searchTextField)
            .store(in: &subscriptions)
    }
    
    private func setupImageCollectionView() {
        imageCollectionView.collectionViewLayout = layout
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        imageCollectionView.layer.cornerRadius = 10
    }
    
    @objc
    private func didPullToRefresh(_ sender: Any) {
        viewModel.fetchPixel()
        refreshControl.endRefreshing()
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        viewModel.fetchPixel(query: searchTextField?.text)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        cell.configure(with: viewModel.imageData?.photos[indexPath.row].src.portrait ?? "")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageData?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            layout.updateLayout(for: CGFloat.random(in: 250...350))
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let editVC = storyboard?.instantiateViewController(identifier: "EditViewController") as? EditViewController {
            editVC.imageUrl = viewModel.imageData?.photos[indexPath.row].src.portrait ?? ""
            show(editVC, sender: self)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - scrollViewHeight - 100 { // Threshold
            page+=1
            viewModel.loadMore(page: page, query: searchTextField?.text)
            imageCollectionView.reloadData()
        }
    }
    
}


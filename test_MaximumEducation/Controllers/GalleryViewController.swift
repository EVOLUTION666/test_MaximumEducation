//
//  GalleryViewController.swift
//  test_MaximumEducation
//
//  Created by Andrey on 16.11.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
    var newsImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.flashScrollIndicators()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        configureItems()
        setLayoutConstraints()
        addBarButton()
    }
    
    func configureItems() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(newsImageView)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            newsImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            newsImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            newsImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            newsImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
        ])
    }
    
    func addBarButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(closeImage))
    }
    
    @objc func closeImage() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

extension GalleryViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        newsImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = newsImageView.image {
                let ratioW = newsImageView.frame.width / image.size.width
                let ratioH = newsImageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > newsImageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - newsImageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight*scrollView.zoomScale > newsImageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - newsImageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
                
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}

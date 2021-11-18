//
//  ViewController.swift
//  test_MaximumEducation
//
//  Created by Andrey on 16.11.2021.
//

import UIKit

class NewsViewController: UIViewController {
    
    var tableView = UITableView()
    
    var service = Service()
    
    var news = [Article]()
    
    let refreshControll: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        return refreshControll
    }()
    
    let frontView = UIView()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        frontView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        frontView.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.frontView.removeFromSuperview()
            self.navigationController?.navigationBar.isHidden = false
        }
        configureTableView()
        title = "News"
        getData()
        view.addSubview(frontView)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.pin(to: view)
        tableView.register(CellTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControll
    }
    
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getData() {
        service.fetchData { (data) in
            self.news = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc private func pullToRefresh(sender: UIRefreshControl) {
        getData()
        refreshControll.endRefreshing()
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellTableViewCell
        let newsInCell = news[indexPath.row]
        cell.set(news: newsInCell)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rootVC = DetailsViewController()
        
        rootVC.selectedNews = news[indexPath.row]
        rootVC.articleImage = (tableView.cellForRow(at: indexPath) as? CellTableViewCell)?.newsImageView.image
        
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.modalPresentationStyle = .fullScreen
        
        self.present(navVC, animated: true)
    }
    
}

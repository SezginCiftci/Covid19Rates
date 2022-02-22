//
//  ViewController.swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 7.02.2022.
//

import UIKit

enum Cell_ID: String {
    case mainCell = "mainCell"
}

class MainViewController: UIViewController {

    private var mainView = UIView()
    private var countrySearchBar = UISearchBar()
    
    private var countryCV : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MainCell.self, forCellWithReuseIdentifier: Cell_ID.mainCell.rawValue)
        return cv
    }()
    
    fileprivate var mainVM = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showCountryBar(shouldShow: true)
        countrySearchBar.text = ""
    }
    
    @objc func handleSearchBar() {
        countryBar(shouldShow: true)
        countrySearchBar.becomeFirstResponder()
    }
    
    private func configureUI() {
        
        countrySearchBar.delegate = self
        countryCV.delegate = self
        countryCV.dataSource = self
        
        view.backgroundColor = .systemBlue
        title = "SARS-CoV-2 Rates"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
            
        showCountryBar(shouldShow: true)
        countrySearchBar.sizeToFit()
        countrySearchBar.placeholder = "Write a country name"
        
        view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainView.backgroundColor = .secondarySystemBackground

        mainView.addSubview(countryCV)
        countryCV.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        countryCV.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        countryCV.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        countryCV.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        countryCV.backgroundColor = .secondarySystemBackground
        
    }
    
    private func showCountryBar(shouldShow: Bool) {
        if shouldShow {
            countryCV.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(handleSearchBar))
        } else {
            countryCV.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        
    }
    
    private func countryBar(shouldShow: Bool) {
        showCountryBar(shouldShow: !shouldShow)
        countrySearchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? countrySearchBar : nil

    }

}

// UICollectionView Delegate Methods

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: collectionView.frame.width, height: collectionView.frame.height/15)
      }
      
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.mainVM.numberOfItems() != 0) ? self.mainVM.numberOfItems() : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell_ID.mainCell.rawValue, for: indexPath) as! MainCell
        cell.nameLabel.text = self.mainVM.cellForItem(indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController()
        detailVC.title = self.mainVM.cellForItem(indexPath.row)
        detailVC.country = self.mainVM.cellForItem(indexPath.row)
        detailVC.isLoading = true
        
        let navVC = UINavigationController(rootViewController: detailVC)
        navVC.modalTransitionStyle = .crossDissolve
        navVC.modalPresentationStyle = .fullScreen
        
        present(navVC, animated: true, completion: nil)
        
    }
    
}

// UISearchBar Delegate Methods

extension MainViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        countryBar(shouldShow: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        countrySearchBar.resignFirstResponder()

        guard let searchText = searchBar.text else { return }
        
        let detailVC = DetailViewController()
        detailVC.country = searchText
        detailVC.title = searchText
        detailVC.isLoading = true
        
        let navVC = UINavigationController(rootViewController: detailVC)
        navVC.modalTransitionStyle = .crossDissolve
        navVC.modalPresentationStyle = .fullScreen
        
        present(navVC, animated: true, completion: nil)
    }
}


//
//  SearchUserVC.swift
//  Ask For It
//
//  Created by Hakan Türkmen on 27.07.2024.
//

import UIKit

class SearchUserVC: UIViewController {
    
    var collectionview: UICollectionView!
    
    var vm = SearchUserViewModel()
    
    lazy var searchBar : UISearchBar = UISearchBar()
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task{
            try await vm.getAllUsers()
            collectionview.reloadData()
            
        }
        
        setUI()
        
        self.view.addSubview(collectionview)
        
        collectionview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                // Görünümünüze ekleyin (view veya belirli bir view)
        tapGesture.cancelsTouchesInView = false

                view.addGestureRecognizer(tapGesture)
        
    }
    @objc func dismissKeyboard() {
        searchBar.endEditing(true)
    }
    @objc func refresh(_ sender: AnyObject) {
        Task{
            try await vm.getAllUsers()
            collectionview.reloadData()
            
            refreshControl.endRefreshing()
            
        }
    }
    
    func setUI()
    {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.register(SearchUserTableCell.self, forCellWithReuseIdentifier: SearchUserTableCell.identifier)
        collectionview.showsVerticalScrollIndicator = false
        collectionview.alwaysBounceVertical = true
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search for user"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionview.addSubview(refreshControl)
    }
}

extension SearchUserVC : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout ,UICollectionViewDelegate,UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        vm.filterUsers(searchText: textSearched)
        collectionview.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = VisitProfileVC()
        vc.vm.userID = vm.filteredUsers[indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100    , height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: SearchUserTableCell.identifier, for: indexPath) as! SearchUserTableCell
        
        cell.user = vm.filteredUsers[indexPath.row]
        cell.set()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.filteredUsers.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10
        )
    }
    
    
}

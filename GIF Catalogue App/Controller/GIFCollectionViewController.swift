//
//  GIFCollectionViewController.swift
//  GIF Catalogue App
//
//  Created by liga.griezne on 27/03/2024.
//

import UIKit

class GIFCollectionViewController: UIViewController {
    let apiService = APIService()
    var gifs: [GIFData] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noGifLabel: UILabel!
    
    let cellSize = CGSize(width: 150, height: 150) // Adjust size as needed
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Browse gif Images"
        let nib = UINib(nibName: "GIFCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "GIFCollectionViewCell")
        noGifLabel.text = "There are no GIF images to display"
        noGifLabel.isHidden = true
        fetchTrendingGIFs()
    }
    func fetchTrendingGIFs() {
        apiService.fetchTrendingGIFs { [weak self] (fetchedGIFs, error) in
            if let fetchedGIFs = fetchedGIFs {
                self?.gifs = fetchedGIFs
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }
}
// MARK: - UICollectionViewDataSource
extension GIFCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gifItemCollectionViewCell", for: indexPath) as? GIFCollectionViewCell else {
            return UICollectionViewCell()
        }
        let gif = gifs[indexPath.item]
        if let gifURLString = gif.images?.original?.url {
            cell.configure(with: gifURLString)
        }
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension GIFCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let device = UIDevice.current.userInterfaceIdiom
        let collectionViewWidth = collectionView.bounds.width
        var cellWidth: CGFloat = 0.0
        var spacing: CGFloat = 0.0
        if device == .pad {
            spacing = 10
        } else {
            spacing = 5
        }
        let totalSpacing = spacing * 3 // 2 spaces between cells, 1 space at each side
        let availableWidth = collectionViewWidth - totalSpacing
        cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: cellWidth) // Square cells
    }
}
// MARK: - UISearchBarDelegate
extension GIFCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()        // Start a new timer for 0.5 seconds
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.performSearch(with: searchText)
        }
    }
    func performSearch(with searchText: String) {
        guard let query = searchBar.text, !query.isEmpty else {
            fetchTrendingGIFs()
            return
        }
        apiService.searchGIFs(query: query) { [weak self] (searchedGIFs, error) in
            if let searchedGIFs = searchedGIFs {
                self?.gifs = searchedGIFs
                DispatchQueue.main.async {
                    self?.collectionView.reloadData() 
                    self?.noGifLabel.isHidden = !searchedGIFs.isEmpty
                }
            }
        }
    }
}

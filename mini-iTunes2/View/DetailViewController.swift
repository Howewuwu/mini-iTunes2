//
//  DetailViewController.swift
//  mini-iTunes2
//
//  Created by Howe on 2023/4/2.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    var selectedItem: iTunesItem?
    
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var artistPreviewButton: UIButton!
    @IBOutlet weak var albumPreviewButton: UIButton!
    @IBOutlet weak var trackPreviewButton: UIButton!
    @IBOutlet weak var trackIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButtonColor()
        
        if let item = selectedItem{
            collectionNameLabel.text = item.collectionName
            artistNameLabel.text = item.artistName
            trackNameLabel.text = item.trackName
            let releaseDate = formatDate(item.releaseDate)
            releaseDateLabel.text = "發行日期 : \(releaseDate)"
            
            Search.shared.searchImage(from: item.artworkUrl100) { result in
                switch result {
                case.success(let image):
                    DispatchQueue.main.async {
                        self.artworkImageView.image = image
                    }
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        if let artistName = selectedItem?.artistName {
            artistPreviewButton.setTitle("歌手預覽：\(artistName) >", for: .normal)
        }
        
        if let albumName = selectedItem?.collectionName {
            albumPreviewButton.setTitle("專輯預覽：\(albumName) >", for: .normal)
        }
        
        if let trackName = selectedItem?.trackName {
            trackPreviewButton.setTitle("歌曲預覽：\(trackName) >", for: .normal)
        }
        
        fetchSongTrackId(trackId: selectedItem!.trackId)
        
        
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy/MM/dd"
            return dateFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    func fetchSongTrackId(trackId: Int) {
        Search.shared.lookup(trackId: trackId) { result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    let trackIdNum = String(item.trackId)
                    self.trackIdLabel.text = "ID:\(trackIdNum)"
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.trackIdLabel.text = "未查找到歌曲ID"
                }
            }
        }
    }
    
    func updateButtonColor() {
        if traitCollection.userInterfaceStyle == .dark {
            // 按鈕顏色為深色模式
            albumPreviewButton.tintColor = .lightGray
            artistPreviewButton.tintColor = .lightGray
            trackPreviewButton.tintColor = .lightGray
        } else {
            // 按鈕顏色為亮色模式
            albumPreviewButton.tintColor = .darkGray
            artistPreviewButton.tintColor = .darkGray
            trackPreviewButton.tintColor = .darkGray
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateButtonColor()
    }

    
    @IBAction func artistPreviewButtonTapped(_ sender: UIButton) {
        if let urlString = selectedItem?.artistViewUrl {
            openUrlInSafari(urlString: urlString)
        }
    }
    
    @IBAction func albumPreviewButtonTapped(_ sender: UIButton) {
        if let urlString = selectedItem?.collectionViewUrl {
            openUrlInSafari(urlString: urlString)
        }
    }
    
    @IBAction func trackPreviewButtonTapped(_ sender: UIButton) {
        if let urlString = selectedItem?.previewUrl {
            openUrlInSafari(urlString: urlString)
        }
    }
    
    func openUrlInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    
}

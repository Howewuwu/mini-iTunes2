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
        
        if let item = selectedItem{
            collectionNameLabel.text = item.collectionName
            artistNameLabel.text = item.artistName
            trackNameLabel.text = item.trackName
            releaseDateLabel.text = formatDate(item.releaseDate)
            
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
            artistPreviewButton.setTitle("\(artistName)預覽", for: .normal)
        }
        
        if let albumName = selectedItem?.collectionName {
            albumPreviewButton.setTitle("\(albumName)預覽", for: .normal)
        }
        
        if let trackName = selectedItem?.trackName {
            trackPreviewButton.setTitle("\(trackName)預覽", for: .normal)
        }
        
        fetchSongDetails(trackId: selectedItem!.trackId)
        
        
    }
    
    func formatDate(_ dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy/MM/dd"
            return dateFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    func fetchSongDetails(trackId: Int) {
        Search.shared.lookup(trackId: trackId) { result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    // 更新 UI 以顯示取得的歌曲信息
                    print("TTTTTHHHHIIIIISSSS IIIIISSSS\(item)")
                    self.trackIdLabel.text = String(item.trackId)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func artistPreviewButtonTapped(_ sender: UIButton){
        if let urlString = selectedItem?.artistViewUrl {
            performSegue(withIdentifier: "showPreview", sender: urlString)
        }
    }
    
    @IBAction func albumPreviewButtonTapped(_ sender: UIButton) {
        if let urlString = selectedItem?.collectionViewUrl {
            performSegue(withIdentifier: "showPreview", sender: urlString)
        }
    }
    
    @IBAction func trackPreviewButtonTapped(_ sender: UIButton) {
        if let urlString = selectedItem?.previewUrl {
            performSegue(withIdentifier: "showPreview", sender: urlString)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPreview",
           let previewVC = segue.destination as? PreviewViewController,
           let urlString = sender as? String {
            previewVC.urlString = urlString
        }
    }
    
    
}

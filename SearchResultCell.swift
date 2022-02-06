//
//  TableViewCell.swift
//  RedditCloneApp
//
//  Created by Tolga Sayan on 1.02.2022.
//

import UIKit

class SearchResultCell: UITableViewCell {
  
  var downloadedTask: URLSessionDownloadTask?
  
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var thumbnail: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func configure(for result: Post){
    titleLabel.text = result.title
    
    descriptionLabel.text = result.selftext
    
    thumbnail.image = UIImage(systemName: "bookmark.circle")
    if let smallUrl = result.preview?.images.first?.resolutions.first?.url{
      let decodedUrl = String(htmlEncodedString: smallUrl)
      thumbnail.downloaded(from: decodedUrl ?? "")
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    downloadedTask?.cancel()
    downloadedTask = nil
  }
  
}

extension String {

    init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)

    }

}

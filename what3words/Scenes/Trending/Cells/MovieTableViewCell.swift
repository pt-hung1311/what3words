//
//  MovieTableViewCell.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit
import Reusable
import SDWebImage

class MovieTableViewCell: UITableViewCell, NibReusable {

    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    let transformer = SDImageResizingTransformer(size: CGSize(width: 160, height: 240), scaleMode: .aspectFit)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configView(movie: Movie) {
        if let imageUrl = movie.imageUrl {
            thumbnailView.sd_setImage(with: URL(string: imageUrl),
                                      placeholderImage: UIImage(named: "placeholder"),
                                      context: [.imageTransformer: transformer])
        }
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release date: \(movie.releaseDate)"
        rateLabel.text = "Rate: \(movie.voteAverage)"
    }
}

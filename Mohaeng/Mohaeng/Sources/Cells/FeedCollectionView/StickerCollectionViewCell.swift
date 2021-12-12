//
//  StickerCollectionViewCell.swift
//  Journey
//
//  Created by 윤예지 on 2021/09/09.
//

import UIKit

class StickerCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet Properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stickerIconImageView: UIImageView!
    @IBOutlet weak var stickerCountingLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initViewRounding()
    }
    
    // MARK: - Functions
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)

        var frame = layoutAttributes.frame
        frame.size.height = ceil(30)
        frame.size.width = ceil(size.width)

        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    func initViewRounding() {
        containerView.makeRoundedWithBorder(radius: 15, color: CGColor.init(red: 1.0, green: 0.95, blue: 0.82, alpha: 1.0))
    }
    
    func setData(data: Emoji) {
        switch data.id {
        case 1:
            stickerIconImageView.image = Const.Image.sticker1
        case 2:
            stickerIconImageView.image = Const.Image.sticker2
        case 3:
            stickerIconImageView.image = Const.Image.sticker3
        case 4:
            stickerIconImageView.image = Const.Image.sticker4
        case 5:
            stickerIconImageView.image = Const.Image.sticker5
        case 6:
            stickerIconImageView.image = Const.Image.sticker6
        default:
            return
        }
        stickerCountingLabel.text = "\(data.count)"
    }

}

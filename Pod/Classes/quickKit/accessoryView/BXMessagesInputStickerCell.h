//
//  BXMessagesInputStickerCell.h
//  Pods
//
//  Created by Xiang Li on 10/29/15.
//
//

@import UIKit;

@interface BXMessagesInputStickerCell : UICollectionViewCell

/**
 *  preview image of this sticker
 */
@property (nonatomic, strong) UIImageView *stickerImageView;

/**
 *  name label of this sticker
 */
@property (nonatomic, strong) UILabel *nameLabel;

- (void)highlight;
- (void)unhighlight;

@end

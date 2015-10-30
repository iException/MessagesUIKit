//
//  BXQuickMessagesStickerChatCell.h
//  Pods
//
//  Created by Xiang Li on 10/28/15.
//
//

#import "BXQuickMessagesBaseChatCell.h"
#import "FLAnimatedImageView.h"

@interface BXQuickMessagesStickerChatCell : BXQuickMessagesBaseChatCell

@property (nonatomic, strong) UIImageView *staticImageView;
@property (nonatomic, strong) FLAnimatedImageView *dynamicImageView;

@end

//
//  BXQuickMessagesStickerChatCell.h
//  Pods
//
//  Created by Xiang Li on 10/28/15.
//
//

#import "BXQuickMessagesBaseChatCell.h"

@interface BXQuickMessagesStickerChatCell : BXQuickMessagesBaseChatCell

@property (nonatomic, strong) UIImageView *stickerImageView;

- (void)setupCellWithMessage:(BXQuickMessage *)message;

@end

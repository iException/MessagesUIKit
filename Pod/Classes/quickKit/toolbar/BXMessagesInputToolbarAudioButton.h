//
//  BXMessagesInputToolbarAudioButton.h
//  Baixing
//
//  Created by hyice on 15/3/19.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputToolbar.h"

@class BXMessagesInputToolbarAudioButton;

@protocol BXMessagesInputToolbarAudioButtonDelegate <NSObject>

- (void)bxMessagesAudioButtonStartRecord:(BXMessagesInputToolbarAudioButton *)audioButton;
- (void)bxMessagesAudioButtonFinishRecord:(BXMessagesInputToolbarAudioButton *)audioButton;
- (void)bxMessagesAudioButtonCancelRecord:(BXMessagesInputToolbarAudioButton *)audioButton;

@end

@interface BXMessagesInputToolbarAudioButton : UIButton <BXMessagesInputToolbarItem>

@property (assign, nonatomic) BOOL flexibleWidth;
@property (assign, nonatomic) BOOL flexibleHeight;

@property (assign, nonatomic) CGFloat height;

@property (weak, nonatomic) id<BXMessagesInputToolbarAudioButtonDelegate> delegate;

- (void)updateVolumnRate:(CGFloat)rate;

@end

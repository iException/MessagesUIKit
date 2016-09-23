//
//  BXQuickMessageAudioMedia.h
//  Baixing
//
//  Created by hyice on 15/4/1.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessageMedia.h"

@class BXQuickMessageAudioMedia;

@protocol BXQuickMessageAudioMediaDelegate <NSObject>

- (void)bxQuickMessageAudioMediaDidStopPlay:(BXQuickMessageAudioMedia *)audioMedia;

@end

@interface BXQuickMessageAudioMedia : NSObject <BXQuickMessageMedia>

@property (strong, nonatomic) NSData *audioData;

@property (assign, nonatomic) NSInteger audioLength;

@property (assign, nonatomic) BOOL displayOnLeft;

@property (nonatomic, readonly) BOOL isPlaying;

@property (assign, nonatomic) BOOL listened;

@property (weak, nonatomic) id<BXQuickMessageAudioMediaDelegate> delegate;

- (void)play;

- (void)stop;

@end

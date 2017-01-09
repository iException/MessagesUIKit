//
//  BXQuickMessageAudioMedia.m
//  Baixing
//
//  Created by hyice on 15/4/1.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessageAudioMedia.h"
#import <AVFoundation/AVFoundation.h>
#import "NSBundle+MessagesUIKit.h"
#import "UIImage+MessagesUIKit.h"

@interface BXQuickMessageAudioMedia() <AVAudioPlayerDelegate>

@property (strong, nonatomic) UIImageView *audioView;
@property (strong, nonatomic) AVAudioPlayer *player;

@property (assign, nonatomic, readwrite) BOOL isPlaying;


@end

@implementation BXQuickMessageAudioMedia

- (BOOL)displayWithBubleMask
{
    return NO;
}

- (BOOL)displayUnreadBadgeBeforeTap
{
    return !self.listened && self.displayOnLeft;
}

- (NSString *)contentDescription
{
    return [NSString stringWithFormat:@"%ld\"", (long)self.audioLength];
}

- (UIView *)mediaView
{
    [self setupAudioView];
    
    return self.audioView;
}

- (CGSize)displaySize
{
    CGFloat width = 30.0;
    if (self.audioLength > 0) {
        width += log(self.audioLength) * 30.0;
        width = fmin(200.0, width);
    }
    return CGSizeMake(width, 20);
}

- (UIImageView *)audioView
{
    if (!_audioView) {
        _audioView = [[UIImageView alloc] init];
    }
    
    return _audioView;
}

- (void)setupAudioView
{
    if (self.isPlaying) {
        if (self.displayOnLeft) {
            self.audioView.animationImages = @[[UIImage buk_imageNamed:@"ReceiverVoiceNodePlaying001"],
                                               [UIImage buk_imageNamed:@"ReceiverVoiceNodePlaying002"],
                                               [UIImage buk_imageNamed:@"ReceiverVoiceNodePlaying003"]];
        }else {
            self.audioView.animationImages = @[[UIImage buk_imageNamed:@"SenderVoiceNodePlaying001"],
                                               [UIImage buk_imageNamed:@"SenderVoiceNodePlaying002"],
                                               [UIImage buk_imageNamed:@"SenderVoiceNodePlaying003"]];
        }
    }else {
        if (self.displayOnLeft) {
            [self.audioView setImage:[UIImage buk_imageNamed:@"ReceiverVoiceNodePlaying"]];
            self.audioView.contentMode = UIViewContentModeLeft;
        }else {
            [_audioView setImage:[UIImage buk_imageNamed:@"SenderVoiceNodePlaying"]];
            self.audioView.contentMode = UIViewContentModeRight;
        }
    }
}

- (void)play
{
    if (self.isPlaying) {
        return;
    }
    
    [self enableProximityMonitor];
    
    self.isPlaying = YES;
    
    [self setupAudioView];
    
    self.audioView.animationDuration = 1.0f;
    self.audioView.animationRepeatCount = 0;
    
    [self.audioView startAnimating];
    
    [self.player play];
}

- (void)stop
{
    if (!self.isPlaying) {
        return;
    }
    
    [self disableProximityMonitor];
    
    self.isPlaying = NO;
    
    [self.audioView stopAnimating];

    self.audioView.animationImages = nil;
    
    [self.player stop];
    
    self.player = nil;
}

#pragma mark - audio player
- (AVAudioPlayer *)player
{
    if (!_player) {
        _player = [[AVAudioPlayer alloc] initWithData:self.audioData error:nil];
        [_player prepareToPlay];
        _player.delegate = self;
    }
    
    return _player;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self stop];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bxQuickMessageAudioMediaDidStopPlay:)]) {
        [self.delegate bxQuickMessageAudioMediaDidStopPlay:self];
    }
}

#pragma mark - proximity monitor
- (void)enableProximityMonitor
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityMOnitorStateChanged) name:UIDeviceProximityStateDidChangeNotification object:nil];
}

- (void)disableProximityMonitor
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while ([UIDevice currentDevice].proximityState == YES) {}
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
            
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            
        });
    });
}

- (void)proximityMOnitorStateChanged
{
    if ([UIDevice currentDevice].proximityState == YES) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}
@end

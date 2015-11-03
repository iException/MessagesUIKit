//
//  BXMessagesInputStickerCell.m
//  Pods
//
//  Created by Xiang Li on 10/29/15.
//
//

#import "BXMessagesInputStickerCell.h"

@interface BXMessagesInputStickerCell ()

@end

@implementation BXMessagesInputStickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

#pragma mark - private -
- (void)initialize
{
    [self.contentView addSubview:self.stickerImageView];
    
    self.stickerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_stickerImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickerImageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_stickerImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickerImageView)]];
}

#pragma mark - getters -
- (UIImageView *)stickerImageView
{
    if (!_stickerImageView) {
        _stickerImageView = [[UIImageView alloc] init];
    }
    return _stickerImageView;
}

@end

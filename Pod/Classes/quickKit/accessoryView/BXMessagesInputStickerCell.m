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
    [self.contentView addSubview:self.nameLabel];
    
    self.stickerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_stickerImageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickerImageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_stickerImageView]-[_nameLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stickerImageView,_nameLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_nameLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)]];
}

#pragma mark - getters -
- (UIImageView *)stickerImageView
{
    if (!_stickerImageView) {
        _stickerImageView = [[UIImageView alloc] init];
        _stickerImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _stickerImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"";
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:9];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

#pragma mark - public -
- (void)highlight
{
    self.stickerImageView.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
}

- (void)unhighlight
{
    self.stickerImageView.backgroundColor = [UIColor clearColor];
}

@end

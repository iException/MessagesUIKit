//
//  BXMessagesInputEmojiCell.m
//  Baixing
//
//  Created by hyice on 15/3/20.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputEmojiCell.h"

@interface BXMessagesInputEmojiCell ()

@property (nonatomic, strong) UILabel *emojiLabel;

@end

@implementation BXMessagesInputEmojiCell

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
    [self.contentView addSubview:self.emojiLabel];
    
    self.emojiLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_emojiLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_emojiLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_emojiLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_emojiLabel)]];
}

#pragma mark - getters -
- (UILabel *)emojiLabel
{
    if (!_emojiLabel) {
        _emojiLabel = [[UILabel alloc] init];
        _emojiLabel.font = [UIFont systemFontOfSize:28];
        _emojiLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _emojiLabel;
}

@end

//
//  BXMessagesInputMoreChoiceCell.m
//  Baixing
//
//  Created by hyice on 15/3/20.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXMessagesInputMoreChoiceCell.h"

@interface BXMessagesInputMoreChoiceCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BXMessagesInputMoreChoiceCell

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
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    
    [self addLayoutConstraints];
}

- (void)addLayoutConstraints
{
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-3-[_titleLabel(12)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView, _titleLabel)]];

     [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
}


#pragma mark - getters -
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
    }
     
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:0xae/255.0 green:0xae/255.0 blue:0xae/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

@end

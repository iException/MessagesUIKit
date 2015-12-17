//
//  BXMessagesInputStickersGalleryViewCell.m
//  Pods
//
//  Created by Xiang Li on 10/27/15.
//
//

#import "BXMessagesInputStickersGalleryViewCell.h"

@implementation BXMessagesInputStickersGalleryViewCell

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
    // image view
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:self.previewImageView];
    self.previewImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_previewImageView]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_previewImageView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_previewImageView]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_previewImageView)]];
    
    // cutting line
    UIView *cuttingLine = [[UIView alloc] init];
    cuttingLine.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.000];
    
    [self.contentView addSubview:cuttingLine];
    cuttingLine.translatesAutoresizingMaskIntoConstraints = NO;
    [cuttingLine addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cuttingLine(==1)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cuttingLine)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[cuttingLine]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cuttingLine)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[cuttingLine]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cuttingLine)]];
}

#pragma mark - getters -
- (UIImageView *)previewImageView
{
    if (!_previewImageView) {
        _previewImageView = [[UIImageView alloc] init];
    }
    return _previewImageView;
}

@end

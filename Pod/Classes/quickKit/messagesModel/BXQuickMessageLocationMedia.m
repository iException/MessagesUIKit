//
//  BXQuickMessageLocationMedia.m
//  Baixing
//
//  Created by hyice on 15/3/30.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessageLocationMedia.h"
#import "NSBundle+MessagesUIKit.h"
#import "UIImage+MessagesUIKit.h"

@interface BXQuickMessageLocationMedia()

@property (strong, nonatomic) UIView *locationView;

@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation BXQuickMessageLocationMedia

- (instancetype)initWithAddress:(NSString *)address
{
    self = [super init];
    
    if (self) {
        self.address = address;
    }
    
    return self;
}

- (BOOL)displayWithBubleMask
{
    return YES;
}

- (UIColor *)borderColorForBubleMask
{
    return [UIColor colorWithRed:0xcf/255.0 green:0xcf/255.0 blue:0xcf/255.0 alpha:1.0];
}

- (BOOL)displayUnreadBadgeBeforeTap
{
    return NO;
}

- (NSString *)contentDescription
{
    return nil;
}

- (UIView *)mediaView
{
    self.addressLabel.text = _address;
    
    return self.locationView;
}

- (UIView *)locationView
{
    if (!_locationView) {
        _locationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 120)];
        
        [_locationView addSubview:self.imageView];
        self.imageView.frame = _locationView.bounds;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.translatesAutoresizingMaskIntoConstraints = YES;
        
        [_locationView addSubview:self.addressLabel];
        self.addressLabel.frame = CGRectMake(0, 90, 200, 30);
        self.addressLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.addressLabel.translatesAutoresizingMaskIntoConstraints = YES;
    }
    
    return _locationView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.image = [UIImage buk_imageNamed:@"buk-media-location-mapholder.jpg"];
    }
    
    return _imageView;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.backgroundColor = [UIColor blackColor];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.alpha = 0.5;
        _addressLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _addressLabel;
}

- (CGSize)displaySize
{
    return CGSizeMake(200.0f, 120.0f);
}

@end

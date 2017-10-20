//
//  BXQuickMessagePhotoMedia.m
//  Baixing
//
//  Created by hyice on 15/3/30.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessagePhotoMedia.h"
#import <SDWebImage/SDWebImageDownloader.h>

@interface BXQuickMessagePhotoMedia()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation BXQuickMessagePhotoMedia

- (instancetype)initWithImageUrl:(NSString *)imageUrl
{
    self = [super init];
    
    if (self) {
        self.imageUrl = imageUrl;
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    
    if (self) {
        self.image = image;
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
    [self.imageView setImage:[self largestImage]];
    return self.imageView;
}

- (CGSize)displaySize
{
    UIImage *smallestImage = [self smallestImage];
    
    if (smallestImage && smallestImage.size.width != 0) {
        CGFloat width = MIN(smallestImage.size.width, 400);
        
        return CGSizeMake(width, smallestImage.size.height*width/smallestImage.size.width);
    }
    
    return CGSizeMake(200, 150);
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    
    return _imageView;
}

#pragma mark - images
- (UIImage *)largestImage
{
    if (self.image) {
        return self.image;
    }
    
    if (self.thumbnailImage) {
        return self.thumbnailImage;
    }
    
    return nil;
}

- (UIImage *)smallestImage
{
    if (self.thumbnailImage) {
        return self.thumbnailImage;
    }
    
    if (self.image) {
        return self.image;
    }
    
    return nil;
}

- (UIImage *)image
{
    if (_image) {
        return _image;
    }
    
    if (!self.imageUrl || self.imageUrl.length == 0) {
        return nil;
    }
    
    if ([self.imageUrl hasPrefix:@"http://"]) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.imageUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = image;
                [self.imageView setImage:self.image];
            });
        }];
        return nil;
    }else {
        self.image = [UIImage imageWithContentsOfFile:self.imageUrl];
        return _image;
    }
}

- (UIImage *)thumbnailImage
{
    if (_thumbnailImage) {
        return _thumbnailImage;
    }
    
    if (!self.thumbnailImageUrl || self.thumbnailImageUrl.length == 0) {
        return nil;
    }
    
    if ([self.thumbnailImageUrl hasPrefix:@"http://"]) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.thumbnailImageUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.thumbnailImage = image;
                if (!self.image) {
                    [self.imageView setImage:self.thumbnailImage];
                }
            });
        }];
        return nil;
    }else {
        self.thumbnailImage = [UIImage imageWithContentsOfFile:self.imageUrl];
        return _thumbnailImage;
    }
}

- (void)setImageUrl:(NSString *)imageUrl
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(imageUrl))];
    _imageUrl = imageUrl;
    [self didChangeValueForKey:NSStringFromSelector(@selector(imageUrl))];
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_imageUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
            [self.imageView setImage:self.image];
        });
    }];
}

- (void)setThumbnailImageUrl:(NSString *)thumbnailImageUrl
{
    [self willChangeValueForKey:NSStringFromSelector(@selector(thumbnailImageUrl))];
    _thumbnailImageUrl = thumbnailImageUrl;
    [self didChangeValueForKey:NSStringFromSelector(@selector(thumbnailImageUrl))];
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:_thumbnailImageUrl] options:SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbnailImage = image;
            if (!self.image) {
                [self.imageView setImage:self.thumbnailImage];
            }
        });
    }];
}

@end

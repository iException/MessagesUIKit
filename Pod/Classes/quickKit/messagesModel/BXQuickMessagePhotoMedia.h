//
//  BXQuickMessagePhotoMedia.h
//  Baixing
//
//  Created by hyice on 15/3/30.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import "BXQuickMessageMedia.h"

@interface BXQuickMessagePhotoMedia : NSObject <BXQuickMessageMedia>

@property (copy, nonatomic) NSString *thumbnailImageUrl;
@property (strong, nonatomic) UIImage *thumbnailImage;

@property (copy, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) UIImage *image;

/**
 *  @param imageUrl If url is not start with "http://", url will be regard as local file path
 */
- (instancetype)initWithImageUrl:(NSString *)imageUrl;

- (instancetype)initWithImage:(UIImage *)image;

@end

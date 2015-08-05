//
//  BXQuickMessageLocationMedia.h
//  Baixing
//
//  Created by hyice on 15/3/30.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXQuickMessageMedia.h"

@interface BXQuickMessageLocationMedia : NSObject <BXQuickMessageMedia>

@property (strong, nonatomic) NSString *address;

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

- (instancetype)initWithAddress:(NSString *)address;

@end

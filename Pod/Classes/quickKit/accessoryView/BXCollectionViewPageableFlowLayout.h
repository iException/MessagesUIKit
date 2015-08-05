//
//  BXCollectionViewPageableFlowLayout.h
//  Baixing
//
//  Created by hyice on 15/3/20.
//  Copyright (c) 2015年 baixing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BXCollectionViewPageableFlowLayout : UICollectionViewLayout

@property (assign, nonatomic) CGSize itemSize;

@property (assign, nonatomic) UIEdgeInsets pageContentInsets;

@property (assign, nonatomic) CGFloat itemMinimalVerticalPadding;

@property (assign, nonatomic) CGFloat itemMinimalHorizontalPadding;

@end

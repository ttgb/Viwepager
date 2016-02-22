//
//  YGADView.h
//  YGAdvertise
//
//  Created by tao on 16/2/20.
//  Copyright © 2016年 tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YGADView : UIView

/**
 *  图片网址数组
 */

@property (strong, nonatomic) NSArray *urlArray;

/**
 *  pageControl颜色
 */

@property (strong, nonatomic) UIColor *currentPageColor;

@property (strong, nonatomic) UIColor *pageIndicatorColor;

/**
 *  pageControlframe
 */
@property (assign, nonatomic)  CGRect pageControlFrame;

@property (strong, nonatomic) UIImage *pageImage;

@property (strong, nonatomic) UIImage *currentPageImage;


@end













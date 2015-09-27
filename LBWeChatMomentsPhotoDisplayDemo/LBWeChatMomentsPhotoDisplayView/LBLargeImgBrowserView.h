//
//  LBLargeImgBrowserView.h
//  LBWeChatMomentsPhotoDisplayDemo
//
//  Created by aios on 15/9/22.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

//  就是一个很简单的一个scrollView 搭配一个pageControl 组合在一起组成一个View

#import <UIKit/UIKit.h>

@interface LBLargeImgBrowserView : UIView
/* 内置的scrollView */
@property (strong, nonatomic) UIScrollView*  scrollView;
/* 内置的pageControl */
@property (strong, nonatomic) UIPageControl* pageControl;
@end

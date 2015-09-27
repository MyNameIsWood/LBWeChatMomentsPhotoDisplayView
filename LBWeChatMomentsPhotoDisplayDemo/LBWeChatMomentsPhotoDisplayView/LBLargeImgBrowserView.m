//
//  LBLargeImgBrowserView.m
//  LBWeChatMomentsPhotoDisplayDemo
//
//  Created by aios on 15/9/22.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

#import "LBLargeImgBrowserView.h"

@implementation LBLargeImgBrowserView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        // 添加一个scrollView
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:self.scrollView];
        
        // 添加一个pageControl
        self.pageControl = [[UIPageControl alloc]init];
        self.pageControl.center = CGPointMake(self.center.x, 0.9*self.frame.size.height);
        [self addSubview:self.pageControl];
    }
    return self;
}
@end

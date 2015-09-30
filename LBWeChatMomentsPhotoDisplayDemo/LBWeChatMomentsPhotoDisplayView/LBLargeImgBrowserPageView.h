//
//  LBLargeImgBrowserPageView.h
//  LBWeChatMomentsPhotoDisplayDemo
//
//  Created by aios on 15/9/25.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//
// 这是每个分页的类 就是一个view加上一个scrollView里面再加上一个ScrollView
#import <UIKit/UIKit.h>

@interface LBLargeImgBrowserPageView : UIView
/* 需要显示的图片 */
@property (weak, nonatomic) UIImage* image;
/* 图片显示的模式 */
@property (assign, nonatomic) UIViewContentMode contentMode;
/* 用于设置内部imageView的frame 用于设置动画 */
@property (assign, nonatomic) CGRect imageViewFrame;
/* 最大的放大比例 */
@property (assign, nonatomic) CGFloat maximumZoomScale;
/* 当前的缩放比例 */
@property (assign, nonatomic) CGFloat zoomScale;
/* 表明菊花是否在转的一个标志 */
@property (assign, readonly, nonatomic) BOOL isWaiting;
/* 使等待（菊花转） */
- (void)wait;
/* 结束等待 （去掉菊花） */
- (void)endWaiting;
@end

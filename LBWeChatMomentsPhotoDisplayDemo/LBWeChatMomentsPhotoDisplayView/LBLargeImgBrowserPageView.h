//
//  LBLargeImgBrowserPageView.h
//  LBWeChatMomentsPhotoDisplayDemo
//
//  Created by aios on 15/9/25.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBLargeImgBrowserPageView : UIView
@property (weak, nonatomic) UIImage* image;
@property (assign, nonatomic) UIViewContentMode contentMode;
@property (assign, nonatomic) CGFloat maximumZoomScale;
@property (assign, nonatomic) CGFloat zoomScale;
@end

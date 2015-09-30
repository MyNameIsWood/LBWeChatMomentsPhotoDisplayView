//
//  LBLargeImgBrowserPageView.m
//  LBWeChatMomentsPhotoDisplayDemo
//
//  Created by aios on 15/9/25.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

#import "LBLargeImgBrowserPageView.h"
@interface LBLargeImgBrowserPageView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) UIActivityIndicatorView* indicator;
@end
@implementation LBLargeImgBrowserPageView

// 懒加载
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}

// 懒加载
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = self.bounds;
        _scrollView.contentSize = self.bounds.size;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

// 懒加载
- (UIActivityIndicatorView *)indicator {
    if (_indicator == nil) {
        _indicator = [[UIActivityIndicatorView alloc]init];
        _indicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    return _indicator;
}

// zoomScale 的 setter 和 getter 方法
- (void)setZoomScale:(CGFloat)zoomScale {
    self.scrollView.zoomScale = zoomScale;
}

- (CGFloat)zoomScale {
   
    return self.scrollView.zoomScale;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 添加一个scrollView 里面添加一个imageView
        [self.scrollView addSubview:self.imageView];
        [self addSubview:self.scrollView];
        
        // 设置一些属性
        self.backgroundColor = [UIColor clearColor];
    
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = self.bounds.size;
    
    if (self.indicator) {
        self.indicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    
    [self setNeedsLayout];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = self.bounds.size;
    
    if (self.indicator) {
        self.indicator.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    }
    
    [self setNeedsLayout];
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    self.imageView.contentMode = contentMode;
}

// imageViewFrame的setter和getter方法
- (void)setImageViewFrame:(CGRect)imageViewFrame {
    if (self.imageView) {
        [self.imageView setFrame:imageViewFrame];
        
    }
}

- (CGRect)imageViewFrame {
    if (self.imageView) {
        return self.imageView.frame;
    }
    return CGRectZero;
}

- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale {
    _maximumZoomScale = maximumZoomScale;
    self.scrollView.maximumZoomScale = maximumZoomScale;
}

// image的set方法
- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

// image的get方法
- (UIImage *)image {
    return self.imageView.image;
}

// isWaiting标志的获取方法
- (BOOL)isWaiting {
    if (self.indicator) {
        if ([self.indicator isAnimating]) {
            return YES;
        }
    }
    return NO;
}

// 使等待
- (void)wait {
    [self addSubview:self.indicator];
    [self.indicator startAnimating];
}

// 结束等待
- (void)endWaiting {
    [self.indicator stopAnimating];
    [self.indicator removeFromSuperview];
    self.indicator = nil;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

// 使保持在中间
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
    
}


@end

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
@end
@implementation LBLargeImgBrowserPageView

// 懒加载
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.frame = self.bounds;
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
        
        _scrollView.delegate = self;
    }
    return _scrollView;
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
    self.imageView.frame = self.bounds;
    [self setNeedsLayout];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.scrollView.frame = self.bounds;
    self.imageView.frame = self.bounds;
    [self setNeedsLayout];
}

- (void)setContentMode:(UIViewContentMode)contentMode {
    self.imageView.contentMode = contentMode;
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

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

// 使保持在中间
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.contentSize.width <= scrollView.bounds.size.width) {
        [self.imageView setCenter:CGPointMake(0.5*scrollView.bounds.size.width, 0.5*scrollView.bounds.size.height)];
    }
    
}

@end

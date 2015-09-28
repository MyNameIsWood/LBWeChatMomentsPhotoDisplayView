//
//  LBWeChatMomentsPhotoDisplayView.m
//  LBWeChatMomentsPhotoDisplayDemo
//
//  Created by aios on 15/9/21.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

#import "LBWeChatMomentsPhotoDisplayView.h"
#import "LBLargeImgBrowserView.h"
#import "SDWebImagePrefetcher.h"
#import "UIImageView+WebCache.h"
#import "LBLargeImgBrowserPageView.h"

#define LBWidth  [UIScreen mainScreen].bounds.size.width
#define LBHeight [UIScreen mainScreen].bounds.size.height
#define zoomDuration 0.35
#define photoViewScaleWhenOnePhoto 2

@interface LBWeChatMomentsPhotoDisplayView()<UIScrollViewDelegate>
/* 记录下载完成了多少张小图片 */
@property (assign, atomic) int photosDownloadDoneNumber;
/* 大图浏览器 */
@property (strong, nonatomic) LBLargeImgBrowserView* browser;
/* 保存每一个大图的引用 */
@property (strong, nonatomic) NSMutableArray* largeImgPageViews;
@end

@implementation LBWeChatMomentsPhotoDisplayView
{
    NSInteger _previousPage;// 用来保存翻页前 前一页的页数
}

- (NSMutableArray *)largeImgPageViews {
    if (_largeImgPageViews == nil) {
        _largeImgPageViews = [NSMutableArray array];
    }
    return _largeImgPageViews;
}

// 大图浏览器的懒加载
- (LBLargeImgBrowserView *)browser {
    if (_browser == nil) {
        _browser = [[LBLargeImgBrowserView alloc]initWithFrame:CGRectMake(0, 0, LBWidth, LBHeight)];
        
        // 设置scrollView
        _browser.scrollView.contentSize = CGSizeMake(self.thumbnailUrls.count*_browser.bounds.size.width, _browser.bounds.size.height);
        _browser.scrollView.backgroundColor = [UIColor blackColor];
        _browser.scrollView.showsHorizontalScrollIndicator = NO;
        _browser.scrollView.pagingEnabled = YES;
        _browser.scrollView.delegate = self;
        
        // 设置pageControl
        _browser.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _browser.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _browser.pageControl.numberOfPages = self.thumbnailUrls.count;
    }
    return _browser;
}

- (instancetype)init {
    if (self = [super init]) {
        self.marginInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.spacing     = 10;
        self.largeViewMargin = 5;
        self.maximumZoomScale = 1.8;
    }
    return  self;
}

// origin属性的设置方法
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

// origin属性的获取方法
- (CGPoint)origin
{
    return self.frame.origin;
}

// width属性的设置方法
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

// width属性的获取方法
- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setThumbnailUrls:(NSArray *)thumbnailUrls completed:(photosDownloadAllDoneBlock)photosDownloadAllDoneBlock {
    _thumbnailUrls = thumbnailUrls;
    // 每行有多少张图片
    int columnCount;
    if (thumbnailUrls.count == 4) {
        columnCount = 2;
    }else {
        columnCount = 3;
    }
    
    // 有多少行
    int rowCount;
    if (thumbnailUrls.count%columnCount==0) {
        rowCount = (int)thumbnailUrls.count/columnCount;
    }else {
        rowCount = (int)thumbnailUrls.count/columnCount+1;
    }
    
    // 计算并设置自己的高度
    CGFloat photoWidth = (self.width-self.marginInset.left-self.marginInset.right-2*self.spacing)/3;
    CGRect rect = self.frame;
    
    CGSize onePhotoSize;// 只有一张图片时 算出这一张图片的imageView的size
    
    if (self.thumbnailUrls.count == 1) {// 只有一张时 显示大图 并按比例显示
        if (self.aspectRatio<=0) {// 没设置 宽高比 属性
            
            onePhotoSize = CGSizeMake(photoViewScaleWhenOnePhoto*photoWidth, photoViewScaleWhenOnePhoto*photoWidth);
            
        }else {
            if (self.aspectRatio>=1) {// 宽>高
                onePhotoSize = CGSizeMake(photoViewScaleWhenOnePhoto*photoWidth, self.aspectRatio*photoViewScaleWhenOnePhoto*photoWidth);
                
            }else {// 宽<高
                onePhotoSize = CGSizeMake(photoViewScaleWhenOnePhoto*photoWidth/self.aspectRatio, photoViewScaleWhenOnePhoto*photoWidth);
            }
        }
        
        rect.size.height = self.marginInset.top+onePhotoSize.height+self.marginInset.bottom;
    }else {
        rect.size.height = self.marginInset.top+rowCount*photoWidth+(rowCount-1)*self.spacing+self.marginInset.bottom;
    }
    
    self.frame = rect;
    
    // 创建并添加imageView
    for (int i=0; i<thumbnailUrls.count; i++) {
        // 布局
        int row  = i/columnCount;
        int line = i%columnCount;
        CGFloat photoX = self.marginInset.left + line*(self.spacing+photoWidth);
        CGFloat photoY = self.marginInset.top  + row*(self.spacing+photoWidth);
        UIImageView* photoView = [[UIImageView alloc]init];
        
        if (thumbnailUrls.count == 1) {// 只有一张图时
            photoView.frame = CGRectMake(photoX, photoY, onePhotoSize.width, onePhotoSize.height);
            photoView.contentMode = UIViewContentModeScaleAspectFit;
            
        }else {// 不止一张图时
            photoView.frame = CGRectMake(photoX, photoY, photoWidth, photoWidth);
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.clipsToBounds = YES;
        }
        
        photoView.tag  = i;
        [self addSubview:photoView];
        
        // 下载
        [photoView sd_setImageWithURL:[NSURL URLWithString:thumbnailUrls[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {// 下载完成
            if (error) {// 下载图片出错 需做容错处理
#warning 需加上如果小图下载出错 处理错误的代码
                
            }
            
            self.photosDownloadDoneNumber++;
            
            if (self.photosDownloadDoneNumber == thumbnailUrls.count) {// 全部图片下载完成
                
                photosDownloadAllDoneBlock();
            }
        }];
        
        // 给每个imageView添加tap手势
        UITapGestureRecognizer* tap      = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(thumbnailTapped:)];
        [photoView addGestureRecognizer:tap];
        photoView.userInteractionEnabled = YES;
        
    }
}

// 小图被点击了
- (void)thumbnailTapped:(UITapGestureRecognizer*)tap {// 处理图片点击事件：放大图片
    
    // 先预下载图片
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:self.largeImgUrls];
    
    // 放大图片
    [self zoomInWithImageView:(UIImageView*)tap.view];
    
}

// 图片放大
- (void)zoomInWithImageView:(UIImageView*)tappedView {
    
    
    // 先显示小图
    LBLargeImgBrowserPageView* largeView = [[LBLargeImgBrowserPageView alloc]init];
    largeView.image = tappedView.image;
    largeView.maximumZoomScale = self.maximumZoomScale;
    
    [self.largeImgPageViews addObject:largeView];
    
    // 加上一朵菊花
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]init];
    indicator.center = CGPointMake(CGRectGetMidX(largeView.bounds), CGRectGetMidY(largeView.bounds));
    [largeView addSubview:indicator];
    
    NSURL* URL = [NSURL URLWithString:(NSString*)self.largeImgUrls[tappedView.tag]];
    [[SDWebImageManager sharedManager]downloadImageWithURL:URL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // 还未下载完 会多次调用
        if (!indicator.isAnimating) {// 如果菊花没转
            
            // 计算小图在scrollView中的frame
            largeView.bounds = tappedView.bounds;
            largeView.center = CGPointMake(tappedView.tag*LBWidth+0.5*LBWidth, 0.5*LBHeight);
            
            // 显示在window上
            [self.browser.scrollView setContentOffset:CGPointMake(tappedView.tag*LBWidth, 0)];
            [self.browser.scrollView addSubview:largeView];
            [self.window addSubview:self.browser];
            
            // 菊花转
            [indicator startAnimating];
        }
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {// 下载完
        if (error) {// 下载完成 但是失败 需做容错处理
            
#warning 需添加处理下载出错的代码
            
        }else {// 下载成功
            
            if (indicator.isAnimating) {// 转过菊花
                [indicator stopAnimating];
                [indicator removeFromSuperview];
               
                
            }else {// 没转过菊花 直接下载完成
                [indicator removeFromSuperview];
                
                // 计算小图在scrollView中的frame
                CGRect rect = [self convertRect:tappedView.frame toView:self.window];
                rect.origin.x += tappedView.tag*LBWidth;
                largeView.frame = rect;
                
                // largeView添加到scrollView上
                [self.browser.scrollView addSubview:largeView];
                [self.browser.scrollView setContentOffset:CGPointMake(tappedView.tag*LBWidth, 0)];
                [self.window addSubview:self.browser];
            }
            
            largeView.image = image;
            [UIView animateWithDuration:zoomDuration animations:^{
                // 设置放大后的frame
                largeView.frame = CGRectMake(tappedView.tag*LBWidth+self.largeViewMargin, self.largeViewMargin, LBWidth-2*self.largeViewMargin, LBHeight-2*self.largeViewMargin);
                largeView.contentMode = UIViewContentModeScaleAspectFit;
            
            } completion:^(BOOL finished) {
                [largeView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImgViewTapped:)]];
                largeView.userInteractionEnabled = YES;
            }];
        }
        
    }];
    
    // 把未显示的图片补上 从已经显示的后面一张开始 循环到前面一张
    for (NSInteger i = tappedView.tag+1; i<tappedView.tag+self.largeImgUrls.count; i++) {
        NSInteger index;
        if (i < self.largeImgUrls.count) {
            index = i;
        }else {
            index = i%self.largeImgUrls.count;
        }
        
        // 下面的跟上面的代码差不多
        
        // 先显示小图
        LBLargeImgBrowserPageView* largeView = [[LBLargeImgBrowserPageView alloc]init];
        largeView.image = ((UIImageView*)self.subviews[index]).image;
        largeView.maximumZoomScale = self.maximumZoomScale;
        
        if (index > tappedView.tag) {// 放在self.largeImgPageViews数组的后面
            [self.largeImgPageViews addObject:largeView];
        }else {// 放在self.largeImgPageViews数组的前面
            [self.largeImgPageViews insertObject:largeView atIndex:index];
        }
        
        // 加上一朵菊花
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]init];
        indicator.center = CGPointMake(CGRectGetMidX(largeView.bounds), CGRectGetMidY(largeView.bounds));
        [largeView addSubview:indicator];
        
        NSURL* URL = [NSURL URLWithString:(NSString*)self.largeImgUrls[index]];
        [[SDWebImageManager sharedManager]downloadImageWithURL:URL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            // 还未下载完 会多次调用
            if (!indicator.isAnimating) {// 如果菊花没转
                
                // 计算小图在scrollView中的frame
                largeView.bounds = tappedView.bounds;
                largeView.center = CGPointMake(index*LBWidth+0.5*LBWidth, 0.5*LBHeight);
                
                // 添加在browser
                [self.browser.scrollView addSubview:largeView];
               
                
                // 菊花转
                [indicator startAnimating];
            }
            
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {// 下载完
            
            if (error) {// 下载完成 但是失败 需做容错处理
                
#warning 添加处理下载出错的代码
                
            }else {// 下载成功
                if (indicator.isAnimating) {// 转过菊花
                    [indicator stopAnimating];
                    [indicator removeFromSuperview];
                    
                    // 动画
                    largeView.image = image;
                    [UIView animateWithDuration:zoomDuration animations:^{
                        // 设置放大后的frame
                        largeView.frame = CGRectMake(((UIImageView*)self.subviews[index]).tag*LBWidth+self.largeViewMargin, self.largeViewMargin, LBWidth-2*self.largeViewMargin, LBHeight-2*self.largeViewMargin);
                        largeView.contentMode = UIViewContentModeScaleAspectFit;
                        
                    } completion:^(BOOL finished) {
                        [largeView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImgViewTapped:)]];
                        largeView.userInteractionEnabled = YES;
                    }];
                }else {// 没转过菊花 直接下载完成
                    [indicator removeFromSuperview];
                    
                    // largeView添加到scrollView上
                    largeView.image = image;
                    largeView.frame = CGRectMake(((UIImageView*)self.subviews[index]).tag*LBWidth+self.largeViewMargin, self.largeViewMargin, LBWidth-2*self.largeViewMargin, LBHeight-2*self.largeViewMargin);
                    largeView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    [self.browser.scrollView addSubview:largeView];
                    
                    
                    [largeView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(largeImgViewTapped:)]];
                    largeView.userInteractionEnabled = YES;
                }
            }
        }];
    }
}

// 大图被点击了
- (void)largeImgViewTapped:(UITapGestureRecognizer*)tap {
    [self zoomOutWithImageView:(LBLargeImgBrowserPageView*)tap.view];
}

// 大图缩小
- (void)zoomOutWithImageView:(LBLargeImgBrowserPageView*)tappedView {
    
    // 如果图片正在被缩放 则还原
    if (tappedView.zoomScale != 1) {
        tappedView.zoomScale = 1;
    }
    
    // 背景变透明
    self.browser.scrollView.backgroundColor = [UIColor clearColor];
    self.browser.pageControl.hidden = YES;

    // 得到缩小后最终的frame值
    CGRect rect = [self convertRect:((UIView*)self.subviews[self.browser.pageControl.currentPage]).frame toView:self.window];
    rect.origin.x += self.browser.pageControl.currentPage*LBWidth;
    
    // 缩小
    [UIView animateWithDuration:zoomDuration animations:^{
        tappedView.frame = rect;
    } completion:^(BOOL finished) {
        [self.browser removeFromSuperview];
        self.browser = nil;
        self.largeImgPageViews = nil;
        _previousPage = 0;
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // pageControl随动
    NSInteger tempPage = scrollView.contentOffset.x/scrollView.bounds.size.width;
    if (tempPage != _previousPage) {
        if (scrollView.contentOffset.x == tempPage*scrollView.bounds.size.width) {
            self.browser.pageControl.currentPage = tempPage;
            
            [self.largeImgPageViews enumerateObjectsUsingBlock:^(LBLargeImgBrowserPageView* page, NSUInteger idx, BOOL *stop) {
                NSLog(@"page%ld.zoomScale:%f",idx,page.zoomScale);
            }];
        }
    }
    
    if (self.browser.pageControl.currentPage != _previousPage) {// 说明已经翻页了
        
        LBLargeImgBrowserPageView* largeView = self.largeImgPageViews[_previousPage];
        
        if (largeView.zoomScale != 1) {
            largeView.zoomScale = 1;
        }
        
        
        _previousPage = self.browser.pageControl.currentPage;
    }
}

@end

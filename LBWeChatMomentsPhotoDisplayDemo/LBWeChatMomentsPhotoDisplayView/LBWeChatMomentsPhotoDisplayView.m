//
//  LBWeChatMomentsPhotoDisplayView.m
//  LBWeChatMomentsPhotoDisplayDemo
//
//  Created by aios on 15/9/21.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

#import "LBWeChatMomentsPhotoDisplayView.h"
#import "UIImageView+WebCache.h"

#define LBWidth  [UIScreen mainScreen].bounds.size.width
#define LBHeight [UIScreen mainScreen].bounds.size.height

@interface LBWeChatMomentsPhotoDisplayView()
/* 记录下载完成了多少张图片 */
@property (assign, atomic) int photosDownloadDoneNumber;
/* 大图浏览器 */
@property (strong, nonatomic) UIView* browser;

@end

@implementation LBWeChatMomentsPhotoDisplayView
// 大图浏览器的懒加载
- (UIView *)browser {
    if (_browser == nil) {
        
    }
    return _browser;
}

- (instancetype)init {
    if (self = [super init]) {
        self.marginInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.spacing     = 10;
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
    rect.size.height = self.marginInset.top+rowCount*photoWidth+(rowCount-1)*self.spacing+self.marginInset.bottom;
    self.frame = rect;
    
    
    // 创建并添加imageView
    for (int i=0; i<thumbnailUrls.count; i++) {
        // 布局
        int row  = i/columnCount;
        int line = i%columnCount;
        CGFloat photoX = self.marginInset.left + line*(self.spacing+photoWidth);
        CGFloat photoY = self.marginInset.top  + row*(self.spacing+photoWidth);
        UIImageView* photoView = [[UIImageView alloc]initWithFrame:CGRectMake(photoX, photoY, photoWidth, photoWidth)];
        [self addSubview:photoView];
        
        // 下载
        [photoView sd_setImageWithURL:[NSURL URLWithString:thumbnailUrls[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {// 下载完成
            self.photosDownloadDoneNumber++;
            if (self.photosDownloadDoneNumber == thumbnailUrls.count) {// 全部图片下载完成
                
                photosDownloadAllDoneBlock();
            }
        }];
        
        // 给每个imageView添加tap手势
        UITapGestureRecognizer* tap      = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoTapped:)];
        [photoView addGestureRecognizer:tap];
        photoView.userInteractionEnabled = YES;
        photoView.tag                    = i;
    }
}

// 图片被点击了
- (void)photoTapped:(UITapGestureRecognizer*)tap {// 处理图片点击事件：放大图片
    [self zoomInWithIndex:tap.view.tag];
}

// 图片放大
- (void)zoomInWithIndex:(NSInteger)index {







}














@end

//
//  LBWeChatMomentsPhotoDisplayView.h
//  LBWeChatMomentsPhotoDisplayDemo
//
//  Created by aios on 15/9/21.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^photosDownloadAllDoneBlock)();

@interface LBWeChatMomentsPhotoDisplayView : UIView
/* 字符串数组 存放小图的url */
@property (strong, nonatomic) NSArray* thumbnailUrls;
/* 字符串数组 存放大图的url (设置的时候需与小图的url一一对应)*/
@property (strong, nonatomic) NSArray* largeImgUrls;
/* 内容的边距 默认是(10,10,10,10) */
@property (assign, nonatomic) UIEdgeInsets marginInset;
/* 图片之间的间距 默认是10 */
@property (assign, nonatomic) CGFloat spacing;
/* 起始点 */
@property (assign, nonatomic) CGPoint origin;
/* 宽度(高度根据高度自动计算) */
@property (assign, nonatomic) CGFloat width;
/* 大图时图片距离屏幕边的距离 默认是5 */
@property (assign, nonatomic) CGFloat largeViewMargin;
/* 当只显示一张图片时 需设置非0宽高比 否则显示图片的View得不到正确的bounds 默认是0*/
@property (assign, nonatomic) CGFloat aspectRatio;
/* 设置每张大图的放大比例 默认是1.2 */
@property (assign, nonatomic) CGFloat maximumZoomScale;
/* thumbnailUrls属性的设置方法 及回调block */
- (void)setThumbnailUrls:(NSArray *)thumbnailUrls completed:(photosDownloadAllDoneBlock)photosDownloadAllDoneBlock;
@end

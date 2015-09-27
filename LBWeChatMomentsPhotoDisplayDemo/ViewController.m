//
//  ViewController.m
//  LBWeChatMomentsPhotoDisplayDemo
//
//  Created by aios on 15/9/21.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//



#import "ViewController.h"
#import "LBWeChatMomentsPhotoDisplayView.h"

#define thumbnailUrls @[@"http://ww4.sinaimg.cn/square/681018a0gw1ewbe2e6b7uj21vz1vz1kx.jpg",@"http://ww1.sinaimg.cn/square/681018a0gw1ewbe2mqzrqj21vz1vz4qp.jpg",@"http://ww1.sinaimg.cn/square/681018a0gw1ewbe2ur77jj21vz1vz4qp.jpg",@"http://ww3.sinaimg.cn/square/005ZWQyIjw1ewbcyntoylj30c80c8myw.jpg"/*,@"http://ww2.sinaimg.cn/square/5669bca6jw1ewb93pafqqj20c80c8wfr.jpg"*/]

#define largeImgUrls @[@"http://ww4.sinaimg.cn/bmiddle/681018a0gw1ewbe2e6b7uj21vz1vz1kx.jpg",@"http://ww1.sinaimg.cn/bmiddle/681018a0gw1ewbe2mqzrqj21vz1vz4qp.jpg",@"http://ww1.sinaimg.cn/bmiddle/681018a0gw1ewbe2ur77jj21vz1vz4qp.jpg",@"http://ww3.sinaimg.cn/bmiddle/005ZWQyIjw1ewbcyntoylj30c80c8myw.jpg"/*,@"http://ww2.sinaimg.cn/bmiddle/5669bca6jw1ewb93pafqqj20c80c8wfr.jpg"*/]

#define testImgUrls @[@"http://img.daimg.com/uploads/allimg/150918/3-15091Q63R1.jpg",@"http://img.daimg.com/uploads/allimg/150918/3-15091QF125.jpg",@"http://img.daimg.com/uploads/allimg/150918/3-15091QA429.jpg",@"http://img.daimg.com/uploads/allimg/150918/3-15091Q64934.jpg",@"http://img.daimg.com/uploads/allimg/150918/3-15091Q64530.jpg"]

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加一个LBWeChatMomentsPhotoDisplayView
    LBWeChatMomentsPhotoDisplayView* showView = [[LBWeChatMomentsPhotoDisplayView alloc]init];
    showView.origin = CGPointMake(20, 300);
    showView.width  = 300;
    [showView setThumbnailUrls:thumbnailUrls completed:^{
        NSLog(@"done");
    }];
    
    [showView setLargeImgUrls:largeImgUrls];
//    [showView setLargeImgUrls:testImgUrls];
    
    [self.contentView addSubview:showView];
}

@end

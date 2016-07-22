//
//  ViewController.m
//  CollectionBannerView
//
//  Created by YueWen on 16/7/21.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "ViewController.h"
#import "RITLBannerView.h"
#import "YWebFileManager.h"

@interface ViewController ()<RITLBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //导航Label
    UILabel * localText = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 30)];
    localText.text = @"本地轮播";
    UILabel * networkText = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, self.view.bounds.size.width, 30)];
    networkText.text = @"网络轮播";
    
    [self.view addSubview:localText];
    [self.view addSubview:networkText];
    
    //删除本地
//    [[YWebFileManager shareInstance]deleteAllCaches];
    
    /* 本地图数据 */
    NSArray * localImages = @[
                              [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YZZBanner1" ofType:@"png"]],
                              [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YZZBanner2" ofType:@"png"]],
                              [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YZZBanner3" ofType:@"png"]]];
    
    RITLBannerView * localBannerView = [RITLBannerView bannerViewWithFrame:CGRectMake(0, 94, self.view.bounds.size.width, 150)
                                                                 LocalDate:localImages];
    [self.view addSubview:localBannerView];
    
    
    

    /* 网络图数据 */
    NSArray * imageUrls = @[
                            @"http://www.fzlbase.com/uploads/allimg/2011-07/131S613-1-116434.jpg",
                            @"http://pic39.nipic.com/20140320/6608733_082915184000_2.jpg",
                            @"https://tse1-mm.cn.bing.net/th?id=OIP.Mf66ad299d2e307d99e6266ff6a8a5ad3o0&pid=15.1",
                            @"http://f.hiphotos.baidu.com/zhidao/wh%3D450%2C600/sign=9bffaa325543fbf2c579ae27854ee6b6/1e30e924b899a90111abd40c1b950a7b0208f56a.jpg"];
    RITLBannerView * bannerView = [RITLBannerView bannerViewWithFrame:CGRectMake(0, 280, self.view.bounds.size.width, 150)
                                                          networkDate:imageUrls
                                                     PlaceHolderImage:localImages.firstObject];
    bannerView.delegate = self;
    
    [self.view addSubview:bannerView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - <RITLBannerViewDelegate>
- (void)RITLBannnerView:(RITLBannerView *)bannerView viewDidTap:(NSURL *)tapURL
{
    NSLog(@"url = %@",tapURL.absoluteString);
}

@end

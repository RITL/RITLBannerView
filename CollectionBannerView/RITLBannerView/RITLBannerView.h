//
//  RITLBannerView.h
//  CollectionBannerView
//
//  Created by YueWen on 16/7/21.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RITLBannerView;

NS_ASSUME_NONNULL_BEGIN

@protocol RITLBannerViewDelegate <NSObject>

@optional

/** 网络轮播图执行的点击回调 */
- (void)RITLBannnerView:(RITLBannerView *)bannerView viewDidTap:(NSURL *)tapURL;

@end

@interface RITLBannerView : UIView

@property (nullable, nonatomic, weak)id <RITLBannerViewDelegate> delegate;

/** 便利构造器 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame LocalDate:(NSArray <UIImage *> *)images;
+ (instancetype)bannerViewWithFrame:(CGRect)frame networkDate:(NSArray <NSString *> *)urls PlaceHolderImage:(nullable UIImage *)placeholderImage;


/*相关属性*/

/// @brief 是否显示pageControl,默认为true
@property (nonatomic, assign, getter = shouldShowControl) BOOL showPageControl;

@end

NS_ASSUME_NONNULL_END

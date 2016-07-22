//
//  RITLBannerCell.h
//  CollectionBannerView
//
//  Created by YueWen on 16/7/21.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,CellReuseType){
    
    CellReuseTypeTrue = 0, /**<cell重用*/
    CellReuseTypeFalse = 1,/**<cell不重用*/
    
};



NS_ASSUME_NONNULL_BEGIN

@interface RITLBannerCell : UICollectionViewCell

@property (nonatomic, assign)CellReuseType reuseType;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END

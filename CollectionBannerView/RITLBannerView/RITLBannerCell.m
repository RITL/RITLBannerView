//
//  RITLBannerCell.m
//  CollectionBannerView
//
//  Created by YueWen on 16/7/21.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLBannerCell.h"

@implementation RITLBannerCell

-(void)prepareForReuse
{
    if (self.reuseType == CellReuseTypeTrue)
    {
        self.imageView.image = nil;
    }
    
    NSLog(@"重用啦!");
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

//
//  UIImageView+YWebImage.m
//  WebImageDemo
//
//  Created by YueWen on 16/3/20.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "UIImageView+YWebImage.h"
#import "YWebDownManager.h"
#import "YWebFileManager.h"


@implementation UIImageView (YWebImage)


//根据url设置图片
-(void)RITL_setImageWithUrl:(NSString *)url
{
    [self RITL_setImageWithUrl:url
          withProgressHandle:^(CGFloat didFinish, CGFloat didFinishTotal, CGFloat Total) {}];
}


//根据url设置图片，并支持默认占位图
- (void)RITL_setImageWithUrl:(NSString *)url
          placeHolderImage:(UIImage *)placeHodlerImage
{
    [self RITL_setImageWithUrl:url
            placeHolderImage:placeHodlerImage
          withProgressHandle:^(CGFloat didFinish, CGFloat didFinishTotal, CGFloat Total) {}];
}


//根据url设置图片，支持默认占位图并进行过程回调
- (void)RITL_setImageWithUrl:(NSString *)url
          placeHolderImage:(UIImage *)placeHodlerImage
        withProgressHandle:(DownManagerProgressBlock)progresshandle
{

    
    if (![[YWebFileManager shareInstance] fileIsExist:url]) {//只有不存在的时候才赋值占位图
        //设置占位图
        self.image = placeHodlerImage;
    }
    
    //开始设置图片
    [self RITL_setImageWithUrl:url withProgressHandle:progresshandle];

}


//根据url设置图片并支持过程回调
-(void)RITL_setImageWithUrl:(NSString *)url
       withProgressHandle:(DownManagerProgressBlock)progresshandle
{
    
    //开始下载
    [self downImage:url withProgressHandle:progresshandle];
}



#pragma mark - Start Down Picture
//开始下载图片
- (void)downImage:(NSString *)url
{
    [self downImage:url withProgressHandle:^(CGFloat didFinish, CGFloat didFinishTotal, CGFloat Total) {}];
}



//开始下载图片操作
- (void)downImage:(NSString *)url
withProgressHandle:(DownManagerProgressBlock)progresshandle
{
    
    __weak typeof(self) weakSelf = self;
    
    YWebDownManager * webDownManager = [[YWebDownManager alloc]init];
    
    //开始下载
    [webDownManager startDownImagePath:url];
    
    
    //设置下载完毕的回调
    [webDownManager downManagerFinishBlockHandle:^(NSString *path) {
        
        //获得当前的图片对象
        UIImage * image = [UIImage imageWithContentsOfFile:path];
        
        [UIView animateWithDuration:1.0 animations:^{
           
            weakSelf.image = image;
            
        }];

        
    }];
    
    //设置下载过程的回调
    [webDownManager downManagerProgressBlockHandle:^(CGFloat didFinish, CGFloat didFinishTotal, CGFloat Total) {
       
        //进行回调
        progresshandle(didFinish,didFinishTotal,Total);
    }];
}

@end

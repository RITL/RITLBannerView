//
//  RITLBannerView.m
//  CollectionBannerView
//
//  Created by YueWen on 16/7/21.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLBannerView.h"
#import "RITLBannerCell.h"
#import "RITLBannerTimer.h"
#import "UIImageView+YWebImage.h"

typedef  NS_ENUM(NSUInteger, RITLBannerType)
{
    RITLBannerTypeNetWork = 0,      /** <网路的轮播图*/
    RITLBannerTypeLocal = 1,        /** <本地的轮播图*/
};


static NSString * reuseIdentifier = @"Cell";
static NSString * firstReuseIdentifier = @"FirstCell";
static NSString * lastReuseIdentifier = @"LastCell";

@interface RITLBannerView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) RITLBannerType bannerType;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIPageControl * pageControl;
@property (nonatomic, strong) NSTimer * timer;

/* 用作本地图片轮播 */
@property (nonatomic, copy)   NSArray < UIImage * > * images;
@property (nonatomic, strong) NSMutableArray <UIImage *> * handleImages;

/* 用作网络图片轮播 */
@property (nonatomic, strong) UIImage * placeholderImage;
@property (nonatomic, copy)   NSArray < NSString * > * imageUrls;
@property (nonatomic, strong) NSMutableArray <NSString *> * handleImageUrls;



@end

@implementation RITLBannerView

@synthesize images = _images;
@synthesize imageUrls = _imageUrls;


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
       
        [self loadBannerView];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [self loadBannerView];
}


- (void)loadBannerView
{
    //设置默认属性
    _showPageControl = true;

}



-(void)layoutSubviews
{
    [self addCollectionView];
    [self addPageControl];
    
    //开始进行滚动
    if ([self numberOfPages] > 1)
    {
        [self startTimer];
    }
}

-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    NSLog(@"RITLBannerView dealloc");
}

#pragma mark - 便利构造器
//本地
+(instancetype)bannerViewWithFrame:(CGRect)frame LocalDate:(NSArray<UIImage *> *)images
{
    RITLBannerView * bannerView = [[RITLBannerView alloc]initWithFrame:frame];
    
    [bannerView setValue:images forKey:@"images"];
    
    return bannerView;
}

//网络
+(instancetype)bannerViewWithFrame:(CGRect)frame networkDate:(nonnull NSArray<NSString *> *)urls PlaceHolderImage:(nullable UIImage *)placeholderImage
{
    RITLBannerView * bannerView = [[RITLBannerView alloc]initWithFrame:frame];
    
    [bannerView setValue:urls forKey:@"imageUrls"];
    [bannerView setValue:placeholderImage forKey:@"placeholderImage"];
    
    return bannerView;
}


#pragma mark - addSubviews Function
-(void)addCollectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = true;
        _collectionView.backgroundColor = [UIColor blueColor];
        
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
        
        [self registerCell:@[firstReuseIdentifier,reuseIdentifier,lastReuseIdentifier]];
        
        [self addSubview:_collectionView];
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:false];
    }
}

- (void)registerCell:(NSArray <NSString *> *)reuseIdentifiers
{
    for (NSString * reuseIdentifier in reuseIdentifiers)
    {
        [_collectionView registerNib:[UINib nibWithNibName:@"RITLBannerCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    }
}


-(void)addPageControl
{
    if (_pageControl == nil)
    {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.bounds.size.height - 15, self.bounds.size.width, 15)];
        _pageControl.hidden = !_showPageControl;
        _pageControl.numberOfPages = [self numberOfPages];
        [self addSubview:_pageControl];
    }
}
//
//-(NSArray<UIImage *> *)images
//{
//    if (_images == nil)
//    {
//        _images = @[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YZZBanner1" ofType:@"png"]],
//                    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YZZBanner2" ofType:@"png"]],
//                    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"YZZBanner3" ofType:@"png"]]];
//    }
//    
//    return _images;
//}


-(NSMutableArray<UIImage *> *)handleImages
{
    if (_handleImages == nil)
    {
        _handleImages = [NSMutableArray arrayWithArray:self.images];
        
        //进行处理
        [_handleImages insertObject:self.images.lastObject atIndex:0];
        [_handleImages addObject:self.images.firstObject];
    }
    
    return _handleImages;
}

//
//-(NSArray<NSString *> *)imageUrls
//{
//    if (_imageUrls == nil)
//    {
//        _imageUrls = @[@"http://www.fzlbase.com/uploads/allimg/2011-07/131S613-1-116434.jpg",
//                       @"http://pic39.nipic.com/20140320/6608733_082915184000_2.jpg",
//                       @"https://tse1-mm.cn.bing.net/th?id=OIP.Mf66ad299d2e307d99e6266ff6a8a5ad3o0&pid=15.1"];
//    }
//    
//    return _imageUrls;
//}



-(NSMutableArray<NSString *> *)handleImageUrls
{
    if (_handleImageUrls == nil)
    {
        _handleImageUrls = [NSMutableArray arrayWithArray:self.imageUrls];
        
        //进行处理
        [_handleImageUrls insertObject:self.imageUrls.lastObject atIndex:0];
        [_handleImageUrls addObject:self.imageUrls.firstObject];
    }
    
    return _handleImageUrls;
}



- (void)startTimer
{
    if (_timer == nil)
    {
        __weak typeof(self) weakSelf = self;
        
        _timer = [RITLBannerTimer scheduledTimerWithTimeInterval:3.0f userInfo:nil repeats:true BlockHandle:^(id  _Nonnull info) {
            
            //获取当前的偏移量
            CGFloat offSet = weakSelf.collectionView.contentOffset.x;
            CGFloat spanDistance = weakSelf.collectionView.bounds.size.width;
            
            //进行偏差处理
            NSInteger index = (NSInteger)(offSet / spanDistance);
    
            
            [weakSelf.collectionView setContentOffset:CGPointMake((index + 1) * spanDistance, 0 ) animated:true];
        }];
    }
}

#pragma mark - Setter Function

-(void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    
    _pageControl.hidden = !showPageControl;
}


-(void)setImages:(NSArray<UIImage *> *)images
{
    _images = images;
    _handleImages = nil;
    _bannerType = RITLBannerTypeLocal;
    _pageControl.numberOfPages = images.count;
    
}


-(void)setImageUrls:(NSArray<NSString *> *)imageUrls
{
    _imageUrls = imageUrls;
    _handleImageUrls = nil;
    _bannerType = RITLBannerTypeNetWork;
    _pageControl.numberOfPages = imageUrls.count;
}


#pragma mark - Getter Function
- (NSUInteger)numberOfPages
{
    switch (self.bannerType)
    {
        case RITLBannerTypeNetWork:return _imageUrls.count;
        case RITLBannerTypeLocal:return _images.count;
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (self.bannerType)
    {
        case RITLBannerTypeLocal:return self.handleImages.count;

        case RITLBannerTypeNetWork:return self.handleImageUrls.count;
    }
    
    return self.handleImages.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RITLBannerCell * cell;
    
    NSUInteger index = indexPath.item;
    
    if (index == 1 || index == [self numberOfPages] - 1)
    {
        if (index == 1)
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstReuseIdentifier forIndexPath:indexPath];
        
        else
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:lastReuseIdentifier forIndexPath:indexPath];
        
        cell.reuseType = CellReuseTypeFalse;
    }
    
    else
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
 
    
    switch (self.bannerType)//根据类型设置相关图片
    {
        case RITLBannerTypeLocal:
            cell.imageView.image = self.handleImages[indexPath.item];break;
            
        case RITLBannerTypeNetWork:
            [cell.imageView RITL_setImageWithUrl:self.handleImageUrls[indexPath.item] placeHolderImage:self.placeholderImage];break;
    }

    return cell;
}



#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}


#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bannerType == RITLBannerTypeNetWork)
    {
        if ([self.delegate respondsToSelector:@selector(RITLBannnerView:viewDidTap:)] && self.delegate != nil)
        {
            [self.delegate RITLBannnerView:self viewDidTap:[NSURL URLWithString:self.handleImageUrls[indexPath.item] ]];
        }
        
        NSLog(@"响应了!%@",@(indexPath.item));
    }
    
    
}

#pragma mark - <UIScrollViewDelegate>

//手动滑开始
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //关闭timer
    [self.timer invalidate];
    self.timer = nil;
}

//手动滑结束
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    //开始启动timer
    [self startTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //获得当前CollectionView
    UICollectionView * collection = (UICollectionView *)scrollView;

    //获得当前的偏移量X
    CGFloat originX = collection.contentOffset.x;
    
    //当前pageControld的当前位置
    NSUInteger pageControlIndex = originX / collection.frame.size.width;
    
    //获得当前的数组
    NSArray <NSObject *> * currentArray = (self.bannerType == RITLBannerTypeNetWork ? self.imageUrls : self.images);
    
    //表示到最后一个
    if (originX / collection.frame.size.width <= 0)
    {
        CGFloat contentOffset = currentArray.count * collection.bounds.size.width;
        [collection setContentOffset:CGPointMake(contentOffset, 0)];
        
        
        pageControlIndex = self.images.count - 1;
        
    }
    
    //表示显示的第一个
    else if(originX / collection.frame.size.width >= currentArray.count + 1)
    {
        [collection setContentOffset:CGPointMake(collection.bounds.size.width, 0)];
        
        pageControlIndex = 0;
    }
    
    self.pageControl.currentPage = pageControlIndex - 1;

}



@end

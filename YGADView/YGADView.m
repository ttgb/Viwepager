//
//  YGADView.m
//  YGAdvertise
//
//  Created by tao on 16/2/20.
//  Copyright © 2016年 tao. All rights reserved.
//

#import "YGADView.h"
#import "UIImageView+WebCache.h"
@interface YGADView()<UICollectionViewDelegate,UICollectionViewDataSource>
//typedef YGADCell @"YGADViewControllerCell"
#define YGADCell @"YGADViewControllerCell"
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic)  NSInteger currentPage;
@property (strong, nonatomic) UIImageView *turnImageView;
@property (strong, nonatomic) UIPageControl *pageControl;
//是否是默认值,默认为NO
@property (assign, nonatomic)  BOOL  isDefaultFrame;
@end

@implementation YGADView

//创建定时器
- (void)creadTimer{
    //定时器自动滚动
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(continueScroll) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


//实现滚动

- (void)continueScroll{
    //NSLog(@"定时器期作用了吗");
    //让图片滚动
    
    if (self.currentPage == 5) {
        // self.currentPage = 0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentPage inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
    self.currentPage ++;
    
}


#pragma mark collectionView的代理方法
//滚动结束后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //NSLog(@"scrollViewDidEndDecelerating");
    CGPoint point = scrollView.contentOffset;
    // NSLog(@"%f",point.x);
    self.currentPage = point.x / self.turnImageView.bounds.size.width;
    //NSLog(@")
    if (self.currentPage == 5) {
        self.currentPage = 1;
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        self.currentPage++;
    }
    if (self.currentPage == 0) {
        self.currentPage = self.urlArray.count;
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        self.currentPage++;
    }
    
}

//开始滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //让定时器关闭
    //self.timer.valid = NO;
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //后的当前是第几页
    //CGSize size = scrollView.contentSize;
    
    //结束拖拽重新创建定时器
    [self creadTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (self.currentPage == 6) {
        self.currentPage = 1;
        
        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:self.currentPage inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        self.currentPage++;
    }
  self.pageControl.currentPage = self.currentPage - 2;
}

- (void)setUpUIWithPageControlFrame:(BOOL)pageControlFrameDefault andpageImage:(UIImage *)pageImage andcurrentImage:(UIImage *)currentImage{
    //在view上添加一个collectionView
    self.currentPage = 2;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = self.bounds.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    //注册cell
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:YGADCell];
    [self addSubview:collectionView];
    //创建pageView
    //UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width - pageControl.bounds.size.width - 20, 10, 20, 30)];
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    
    if (!pageControlFrameDefault) {
        //默认位置
        CGRect pageframe = pageControl.frame;
        pageframe.origin.x = self.bounds.size.width - pageControl.bounds.size.width - 50;
        pageframe.origin.y = self.bounds.size.height - pageControl.bounds.size.height - 20;
        pageControl.frame = pageframe;
    }else{
        //自定义位置
        pageControl.frame = self.pageControlFrame;
    }
    pageControl.numberOfPages = self.urlArray.count;
     // pageControl.currentPage = 3;
    self.pageControl = pageControl;
    //颜色
    if (self.currentPageColor != nil) {
        pageControl.currentPageIndicatorTintColor = self.currentPageColor;
    }else{
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    if (self.pageIndicatorColor != nil) {
        pageControl.pageIndicatorTintColor = self.pageIndicatorColor;
    }else{
      pageControl.pageIndicatorTintColor = [UIColor blueColor];
    }

    //都有图片时才替换
    if (![pageImage isEqual:nil] && ![currentImage isEqual:nil]) {
         [pageControl setValue:pageImage forKey:@"_pageImage"];
        [pageControl setValue:currentImage forKey:@"_currentPageImage"];
    }
  
    [self addSubview:pageControl];
   
}

#pragma mark 实现CollectionView数据源

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.urlArray.count == 0) {
        return 0;
    }else{
      return self.urlArray.count + 2;  
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:YGADCell forIndexPath:indexPath];
    //cell.backgroundColor = indexPath.row%2 ? [UIColor redColor] : [UIColor grayColor];
    //创建一个imageView
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];
    self.turnImageView = imageView;
    imageView.backgroundColor = [UIColor greenColor];
    //设置图片
    [cell addSubview:imageView];
    //设置图片
    //imageView
    //http://e.hiphotos.baidu.com/image/pic/item/8d5494eef01f3a29913f38ca9b25bc315c607c3b.jpg
    //http://e.hiphotos.baidu.com/image/pic/item/2934349b033b5bb5d5f4232f32d3d539b600bc3b.jpg
    //http://h.hiphotos.baidu.com/image/pic/item/72f082025aafa40f4c001d0faf64034f79f01919.jpg
    //http://d.hiphotos.baidu.com/image/pic/item/9825bc315c6034a89ded59a7ce1349540923768d.jpg
    //
    if (indexPath.row == 5) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[0]] placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }else if(indexPath.row == 0 ){
        
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.urlArray lastObject]] placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
    }else{
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[indexPath.item - 1]] placeholderImage:nil options:SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
    
    //    NSURL *url = [NSURL URLWithString:@"http://e.hiphotos.baidu.com/image/pic/item/2934349b033b5bb5d5f4232f32d3d539b600bc3b.jpg"];
    //
    //    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:nil];
    //    UIImage *image = [UIImage imageWithData:data];
    //
    //    imageView.image = image;
    //    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return cell;
}

//重写数组的set方法
- (void)setUrlArray:(NSArray *)urlArray{
    _urlArray = urlArray;
    if (urlArray.count == 0) {
        [self setUpUIWithPageControlFrame:self.isDefaultFrame andpageImage:nil andcurrentImage:nil];
        return;
    }else{
        [self setUpUIWithPageControlFrame:self.isDefaultFrame andpageImage:nil andcurrentImage:nil];
        [self.collectionView reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [self creadTimer];
        
        if (self.pageImage != nil ) {
            [self setPageImage:self.pageImage];
        }
        
    }
   
}

- (void)setCurrentPageColor:(UIColor *)currentPageColor{
    _currentPageColor = currentPageColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}

- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor{
    _pageIndicatorColor = pageIndicatorColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorColor;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame{
    _pageControlFrame = pageControlFrame;
    self.pageControl.frame = pageControlFrame;
    self.isDefaultFrame = YES;
    
}

- (void)setPageImage:(UIImage *)pageImage{
    _pageImage = pageImage;
    
    if (self.urlArray.count != 0) {
        if (self.currentPageImage != nil) {
            [self.collectionView removeFromSuperview];
            [self.pageControl removeFromSuperview];
            [self setUpUIWithPageControlFrame:self.isDefaultFrame andpageImage:pageImage andcurrentImage:self.currentPageImage];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
 
}
//
- (void)setCurrentPageImage:(UIImage *)currentPageImage{
    _currentPageImage = currentPageImage;
    //[self.pageControl setValue:currentPageImage forKey:@"_currentPageImage"];
    if (self.urlArray.count != 0) {
        if (self.pageImage != nil) {
            [self.collectionView removeFromSuperview];
            [self.pageControl removeFromSuperview];
            [self setUpUIWithPageControlFrame:self.isDefaultFrame andpageImage:self.pageImage andcurrentImage:currentPageImage];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
    
}
@end










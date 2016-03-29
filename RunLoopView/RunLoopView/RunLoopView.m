//
//  RunLoopView.m
//  RunLoopView
//
//  Created by tanchao on 16/3/28.
//  Copyright © 2016年 谈超. All rights reserved.
//

#import "RunLoopView.h"
#import "UIImageView+WebCache.h"
#define RUNLOOP_VIEW_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
static CGFloat const chageImageTime = 2.0;
@interface RunLoopView ()<UIScrollViewDelegate>
// 轮播器
@property (nonatomic ,strong) UIScrollView *scrollView;
// pageControl
@property (nonatomic ,strong) UIPageControl *pageControl;
// 标记是否拖拽
@property (nonatomic ,assign) BOOL isDragView;
// 定时器
@property (nonatomic ,strong) NSTimer *timer;

@property (nonatomic ,strong) UIImageView *leftView;

@property (nonatomic ,strong) UIImageView *centerView;

@property (nonatomic ,strong) UIImageView *rightView;

@property (nonatomic ,assign) NSInteger currIndex;

@property (nonatomic ,assign) NSInteger count;
@end
@implementation RunLoopView
- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.scrollView=({
            UIScrollView *view = [[UIScrollView alloc]initWithFrame:frame];
            view.pagingEnabled=YES;
            view.delegate=self;
            view.showsHorizontalScrollIndicator=NO;
            view.contentSize=CGSizeMake(RUNLOOP_VIEW_SCREEN_WIDTH*3, 0);
            [self addSubview:view];
            view;
        });
        self.pageControl=({
            UIPageControl *view = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-30, RUNLOOP_VIEW_SCREEN_WIDTH, 20)];
            view.currentPageIndicatorTintColor=[UIColor  redColor];
            [view addTarget:self action:@selector(pageAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:view];
            view;
        });
    }
    return self;
}
#pragma mark pageControl 手势
- (void)pageAction{
    self.isDragView=NO;
    NSInteger page =self.pageControl.currentPage;
    [self.pageControl setCurrentPage:page];
}
#pragma mark 加载轮播器
- (void)initImageViews{
    CGFloat width=RUNLOOP_VIEW_SCREEN_WIDTH;
    CGFloat height=CGRectGetHeight(self.frame);
    self.leftView = ({
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,width, height)];
        [_scrollView addSubview:view];
        view;
    });
    self.centerView =({
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0,width, height)];
        [_scrollView addSubview:view];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
        view;
    });
    self.rightView =({
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(width * 2, 0,width, height)];
        [_scrollView addSubview:view];
        view;
    });
}
- (void)tapAction{
    if ([self.delegate respondsToSelector:@selector(runLoopView:didClickImageWithIndex:)]) {
        [self.delegate runLoopView:self didClickImageWithIndex:self.currIndex];
    }
}
#pragma mark 启动
- (void)run{
    if (_count<2) return;
    NSRunLoop *runLoop=[NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
}
#pragma mark 暂停
- (void)stop{
    if (_count<2) return;
    [self.timer invalidate];
    _timer=nil;
}
#pragma mark- timer
- (NSTimer *)timer{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)timerAction{
    if (_count<2) return;
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +RUNLOOP_VIEW_SCREEN_WIDTH, 0) animated:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stop];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self run];
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self loadImageWithOffset:scrollView.contentOffset.x];
}
- (void)loadImageWithOffset:(CGFloat)offx{
    if (offx>=RUNLOOP_VIEW_SCREEN_WIDTH*2)
    {
        _currIndex++;
        if (_currIndex==_count-1)
        {
            [self loadImageLeft:_currIndex-1 center:_currIndex right:0];
        }
        else if (_currIndex==[_imgUrls count])
        {
            _currIndex=0;
            [self loadImageLeft:_count-1 center:_currIndex right:_currIndex+1];
        }
        else
        {
            [self loadImageLeft:_currIndex-1 center:_currIndex right:_currIndex+1];
        }
        _pageControl.currentPage=_currIndex;
    }
    
    if (offx<=0)
    {
        _currIndex--;
        if (_currIndex==0)
        {
            [self loadImageLeft:_count-1 center:0 right:1];
        }else if (_currIndex==-1)
        {
            _currIndex=_count-1;
            [self loadImageLeft:_currIndex-1 center:_currIndex right:0];
        }else
        {
            [self loadImageLeft:_currIndex-1 center:_currIndex right:_currIndex+1];
        }
        _pageControl.currentPage = _currIndex;
    }
}

- (void)setImgUrls:(NSArray *)imgUrls{
    _imgUrls = imgUrls;
    self.count=[imgUrls count];
    self.pageControl.numberOfPages=_count;
    
    if (_count<2) {
        CGFloat width=RUNLOOP_VIEW_SCREEN_WIDTH;
        CGFloat height=CGRectGetHeight(self.frame);
        [_scrollView setContentSize:CGSizeMake(RUNLOOP_VIEW_SCREEN_WIDTH, 0)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,width, height)];
        imageView.userInteractionEnabled=YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgUrls.firstObject] placeholderImage:nil];
        _pageControl.hidden=YES;
        [_scrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [imageView addGestureRecognizer:tap];
    }else{
        [self initImageViews];
        [self run];
        [self loadImageLeft:_count-1 center:0 right:1];
    }

}
#pragma mark 设置图片
- (void)loadImageLeft:(NSInteger)left center:(NSInteger)center right:(NSInteger)right {
    NSString *item1=_imgUrls[left];
    NSString *item2=_imgUrls[center];
    NSString *item3=_imgUrls[right];
    [_leftView sd_setImageWithURL:[NSURL URLWithString:item1] placeholderImage:nil];
    [_centerView sd_setImageWithURL:[NSURL URLWithString:item2] placeholderImage:nil];
    [_rightView sd_setImageWithURL:[NSURL URLWithString:item3] placeholderImage:nil];
    [_scrollView setContentOffset:CGPointMake(RUNLOOP_VIEW_SCREEN_WIDTH, 0)];
}


@end

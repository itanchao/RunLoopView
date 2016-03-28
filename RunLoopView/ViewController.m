//
//  ViewController.m
//  RunLoopView
//
//  Created by tanchao on 16/3/28.
//  Copyright © 2016年 谈超. All rights reserved.
//

#import "ViewController.h"
#import "RunLoopView.h"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
@interface ViewController ()<RunLoopViewdelegate>
@property (nonatomic, strong) RunLoopView *runloopView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.runloopView = ({
        RunLoopView *view = [[RunLoopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
        view.backgroundColor = [UIColor redColor];
        view.delegate = self;
        [self.view addSubview:view];
        view;
    });
    self.runloopView.imgUrls = @[@"http://ww1.sinaimg.cn/mw1024/473df571jw1f2aq06o3ltj20qo0ur79o.jpg",
                                 @"http://ww3.sinaimg.cn/mw1024/473df571jw1f24p6b71lhj20m80m841x.jpg",
                                 @"http://ww2.sinaimg.cn/mw1024/473df571jw1f1p8u1kf0hj20q50yvn3z.jpg",
                                 @"http://ww3.sinaimg.cn/mw1024/473df571jw1f17waawibmj20rs15o1kx.jpg",
                                 @"http://ww2.sinaimg.cn/mw1024/473df571jw1f0s5nq609zg20ku0kutbg.gif"];                  
}
#pragma mark <RunLoopViewdelegate>
- (void)runLoopView:(RunLoopView *)view didClickImageWithIndex:(NSInteger)index{
    NSLog(@"点击了%ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

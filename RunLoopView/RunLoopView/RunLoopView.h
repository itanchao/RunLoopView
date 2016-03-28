//
//  RunLoopView.h
//  RunLoopView
//
//  Created by tanchao on 16/3/28.
//  Copyright © 2016年 谈超. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RunLoopView;
@protocol RunLoopViewdelegate <NSObject>
@optional
- (void) runLoopView:(RunLoopView *)view didClickImageWithIndex:(NSInteger)index;
@end
@interface RunLoopView : UIView
@property (nonatomic, strong) NSArray *imgUrls;
@property (nonatomic, weak) id<RunLoopViewdelegate> delegate;
- (void)run;
- (void)stop;
@end

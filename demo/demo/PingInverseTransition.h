//
//  PingInverseTransition.h
//  demo
//
//  Created by zhangyi on 16/5/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondViewController.h"

@interface PingInverseTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

@property (nonatomic, readonly) BOOL interactive;

- (void)panToDismiss:(SecondViewController *)viewController;

@end

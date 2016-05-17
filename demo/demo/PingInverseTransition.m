//
//  PingInverseTransition.m
//  demo
//
//  Created by zhangyi on 16/5/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "PingInverseTransition.h"

@interface PingInverseTransition ()

@property (nonatomic, strong) SecondViewController *viewController;

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation PingInverseTransition

- (void)panToDismiss:(SecondViewController *)viewController {
    self.viewController = viewController;
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgeGesture:)];
    gesture.edges = UIRectEdgeLeft;
    [viewController.view addGestureRecognizer:gesture];
}

- (void)edgeGesture:(UIGestureRecognizer *)gesture {
    CGFloat progress = [gesture locationInView:gesture.view].x / CGRectGetWidth(gesture.view.frame);
    progress = MIN(MAX(0, progress), 1);
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            _interactive = YES;
            [self.viewController.navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            [self updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if (progress > 0.3) {
                [self finishInteractiveTransition];
            }
            else {
                [self cancelInteractiveTransition];
            }
            
            _interactive = NO;
            break;
        default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    SecondViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC       = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];
    
    UIButton *button = fromVC.button;
    
    CGPoint startPoint = CGPointMake(button.center.x, button.center.y - CGRectGetHeight(fromVC.view.frame));
    CGFloat radius = sqrt(startPoint.x * startPoint.x + startPoint.y * startPoint.y);
    UIBezierPath *maskStartPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    UIBezierPath *maskFinalPath = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalPath.CGPath;
    fromVC.view.layer.mask = maskLayer;
    
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartPath.CGPath);
    maskLayerAnimation.toValue = (__bridge id)(maskFinalPath.CGPath);
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    
    maskLayerAnimation.delegate = self;
    
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
}

@end

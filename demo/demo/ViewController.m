//
//  ViewController.m
//  demo
//
//  Created by zhangyi on 16/5/16.
//  Copyright © 2016年 zhangyi. All rights reserved.
//

#import "ViewController.h"
#import "PingTransition.h"
#import "PingInverseTransition.h"

@interface ViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong) PingInverseTransition *inverseTransition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.inverseTransition = [PingInverseTransition new];
    [self.inverseTransition panToDismiss:segue.destinationViewController];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        return [PingTransition new];
    }
    else if (operation == UINavigationControllerOperationPop) {
        return self.inverseTransition;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[PingInverseTransition class]] && self.inverseTransition.interactive) {
        return self.inverseTransition;
    }
    
    return nil;
}

@end

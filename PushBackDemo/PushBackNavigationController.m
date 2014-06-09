//
//  PushBackNavigationController.m
//  PushBackDemo
//
//  Created by shan xu on 14-4-1.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import "PushBackNavigationController.h"
#import "XXViewController.h"

#define screenWidth self.view.bounds.size.width
#define screenHeight self.view.bounds.size.height
#define moveProportion 0.7

@interface PushBackNavigationController (){
    float startX;
    NSMutableArray *capImageArr;
    UIImageView *backGroundImg;
    UIView *maskCover;
    UIView *backGroundView;
    int pushNum;
    BOOL isMoving;
}
@end

@implementation PushBackNavigationController
@synthesize captureType;
@synthesize disablePushBack;
@synthesize isPopToRoot;
@synthesize pushBackType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        capImageArr = [[NSMutableArray alloc] initWithCapacity:100];
        captureType = CaptureTypeWithWindow;
        pushBackType = PushBackWithSlowMove;
        pushNum = 0;
        isMoving = NO;
    }
    return self;
}
- (void)dealloc{
    capImageArr = nil;
    [backGroundView removeFromSuperview];
    backGroundView = nil;
    [maskCover removeFromSuperview];
    maskCover = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    UIImageView *shadowImageView = [[UIImageView alloc] init];
    shadowImageView.image = [UIImage imageNamed:@"leftside_shadow_bg.png"];
    shadowImageView.frame = CGRectMake(-10, 0, 10, screenHeight);
    [self.view addSubview:shadowImageView];
    
    UIPanGestureRecognizer *panGus = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesReceive:)];
    panGus.delegate = self;
    panGus.delaysTouchesBegan = YES;
    panGus.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:panGus];
}
#pragma mark -pushView
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (isMoving) {
        return;
    }
    isMoving = YES;
    if (pushNum != 0) {
        [capImageArr addObject:[self capture]];
        pushNum += 1;
        return [super pushViewController:viewController animated:YES];
    }else{
        pushNum += 1;
        return [super pushViewController:viewController animated:YES];
    }
}
#pragma mark -popView
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if (isMoving) {
        return nil;
    }
    isMoving = YES;
    if ([capImageArr count] >= 1) {
        [capImageArr removeLastObject];
    }
    return [super popViewControllerAnimated:animated];
}
#pragma mark -popToRootView
-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    [capImageArr removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}
#pragma -mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.disablePushBack = NO;
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    isMoving = NO;
}
-(UIImage *)capture{
    if (captureType == CaptureTypeWithView) {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
    }else if (captureType == CaptureTypeWithWindow){
        UIWindow *screenWindow = [UIApplication sharedApplication].keyWindow;
        UIGraphicsBeginImageContextWithOptions(screenWindow.bounds.size,screenWindow.opaque,0.0);
        
        [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return img;
    }
    return nil;
}

#pragma -mark UIGurstureDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (capImageArr.count < 1 || self.disablePushBack || [touch.view isKindOfClass:[UIButton class]] || isMoving) {
        return NO;
    }
    return YES;
}
-(void)panGesReceive:(UIPanGestureRecognizer *)panGes{
    if (capImageArr.count < 1 || self.disablePushBack || isMoving) return;
    
    UIWindow *screenWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint panPoint = [panGes locationInView:screenWindow];
    
    CGRect frame = self.view.frame;
    
    XXViewController *xxView = (XXViewController *)self.viewControllers.lastObject;
    if (xxView.backType == XXBackTypePopToRoot) {
        self.isPopToRoot = YES;
    }else{
        self.isPopToRoot = NO;
    }
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        startX = panPoint.x;
        if (backGroundView) {
            [backGroundView removeFromSuperview];
            backGroundView = nil;
        }
        backGroundView = [[UIView alloc] initWithFrame:frame];
        [self.view.superview insertSubview:backGroundView belowSubview:self.view];

        if (!maskCover) {
            maskCover = [[UIView alloc] initWithFrame:frame];
            maskCover.backgroundColor = [UIColor blackColor];
            [backGroundView addSubview:maskCover];
        }
        if (backGroundImg) {
            [backGroundImg removeFromSuperview];
            backGroundImg = nil;
        }
        backGroundImg = [[UIImageView alloc] initWithFrame:frame];
        [backGroundImg setImage:[capImageArr lastObject]];
        [backGroundView insertSubview:backGroundImg belowSubview:maskCover];
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        if (panPoint.x - startX > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveToX:320];
            } completion:^(BOOL finished) {
                if (self.isPopToRoot) {
                    [self popToRootViewControllerAnimated:NO];
                }else{
                    [self popViewControllerAnimated:NO];
                }
                
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self moveToX:0];
            } completion:^(BOOL finished) {
            }];
        }
        return;
    }else if (panGes.state == UIGestureRecognizerStateCancelled){
        [UIView animateWithDuration:0.3 animations:^{
            [self moveToX:0];
        } completion:^(BOOL finished) {
        }];
        return;
    }
    
    [self moveToX:panPoint.x - startX];
}

- (void)moveToX:(float)x{
    x = x >= screenWidth ? screenWidth : x;
    x = x < 0 ? 0 : x;
    CGRect frame = self.view.frame;
    float alpha = 0.5 - x/800;
    
    frame.origin.x = x;
    self.view.frame = frame;
    maskCover.alpha = alpha;
    
    if (pushBackType == PushBackWithSlowMove) {
        frame.origin.x = x*(1 - moveProportion) - screenWidth*(1 - moveProportion);
        backGroundView.frame = frame;
    }else{
        float scale = x/(screenWidth*20) + 0.95;
        backGroundView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

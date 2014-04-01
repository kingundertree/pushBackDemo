//
//  PushBackNavigationController.m
//  PushBackDemo
//
//  Created by shan xu on 14-4-1.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import "PushBackNavigationController.h"

@interface PushBackNavigationController (){
    float startX;
    NSMutableArray *capImageArr;
    UIImageView *backGroundImg;
    UIView *maskCover;
    UIView *backGroundView;
}
@end

@implementation PushBackNavigationController
@synthesize captureType;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        capImageArr = [[NSMutableArray alloc] initWithCapacity:1000];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.layer.shadowColor = [[UIColor blackColor]CGColor];
    self.view.layer.shadowOffset = CGSizeMake(5, 5);
    self.view.layer.shadowRadius = 5;
    self.view.layer.shadowOpacity = 1;
    
    UIPanGestureRecognizer *panGus = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesReceive:)];
    panGus.delegate = self;
    panGus.delaysTouchesBegan = YES;
    panGus.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:panGus];
}
#pragma mark -pushView
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [capImageArr addObject:[self capture]];
    return [super pushViewController:viewController animated:YES];
}

#pragma mark -popView
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if ([capImageArr count] >= 1) {
        [capImageArr removeLastObject];
    }
    
    return [super popViewControllerAnimated:animated];
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
    if (capImageArr.count <= 1) {
        return NO;
    }
    return YES;
}
-(void)panGesReceive:(UIPanGestureRecognizer *)panGes{
    if ([capImageArr count] <= 1) return;
    
    UIWindow *screenWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint panPoint = [panGes locationInView:screenWindow];
    
    CGRect frame = self.view.frame;
    
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
        NSLog(@"minus--->>%f",panPoint.x - startX);
        if (panPoint.x - startX > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveToX:320];
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                
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
    x = x > 320 ? 320 : x;
    x = x < 0 ? 0 : x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/6400) + 0.95;
    float alpha = 0.5 - x/500;
    
    backGroundImg.transform = CGAffineTransformMakeScale(scale, scale);
    maskCover.alpha = alpha;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

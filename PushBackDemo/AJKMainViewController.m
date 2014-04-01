//
//  AJKMainViewController.m
//  PushBackDemo
//
//  Created by shan xu on 14-4-1.
//  Copyright (c) 2014年 夏至. All rights reserved.
//

#import "AJKMainViewController.h"

@interface AJKMainViewController ()

@end

@implementation AJKMainViewController
@synthesize indexNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (NSString *)currentVersion {
    return [[UIDevice currentDevice] systemVersion];
}

- (BOOL)isIOS7 {
    if ([[self currentVersion] floatValue] >= 7) {
        return YES;
    }
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MVC";
    self.view.backgroundColor = [UIColor whiteColor];

    if ([self isIOS7]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    lab.text = [NSString stringWithFormat:@"%d",indexNum];
    lab.font = [UIFont systemFontOfSize:100];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 320, 320, 40);
    [btn setTitle:@"Next Page" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)click:(UIButton *)btn{
    AJKMainViewController *MVC = [[AJKMainViewController alloc] init];
    MVC.indexNum = indexNum + 1;
    [self.navigationController pushViewController:MVC animated:YES];
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

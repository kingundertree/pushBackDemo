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
    
    self.backType = XXBackTypePopBack;
    
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"英雄%ld",(long)indexNum];
    self.view.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 + 1)/255.0 green:(arc4random() % 255 + 1)/255.0 blue:(arc4random() % 255 + 1)/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = YES;
    
    if ([self isIOS7]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    lab.text = [NSString stringWithFormat:@"%ld",(long)indexNum];
    lab.font = [UIFont systemFontOfSize:100];
    lab.backgroundColor = [UIColor clearColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 320, 320, 80);
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


@end

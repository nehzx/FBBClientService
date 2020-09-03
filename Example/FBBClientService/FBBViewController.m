//
//  FBBViewController.m
//  FBBClientService
//
//  Created by 阿振 on 09/02/2020.
//  Copyright (c) 2020 阿振. All rights reserved.
//
#import "QMChatRoomViewController.h"
#import "FBBViewController.h"
#import "FBBManager.h"
//#import "QMHomeViewController.h"
@interface FBBViewController ()

@end

@implementation FBBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapClick:)]];
}

- (void)onTapClick:(UIGestureRecognizer *) sender {
    
    [FBBManager pushChatRoomWithAppKey:@"342d4aa0-d20e-11ea-9819-bf0b406c804b" userId:@"10086" userName:@"10086" completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

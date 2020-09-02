//
//  FBBViewController.m
//  FBBClientService
//
//  Created by 阿振 on 09/02/2020.
//  Copyright (c) 2020 阿振. All rights reserved.
//
#import "QMChatRoomViewController.h"
#import "FBBViewController.h"
#import "QMHomeViewController.h"
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
    [self.navigationController pushViewController:[[QMHomeViewController alloc]init] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

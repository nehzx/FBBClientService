//
//  QMQuestionSubController.m
//  IMSDK-OC
//
//  Created by zcz on 2020/1/2.
//  Copyright © 2020 HCF. All rights reserved.
//

#import "QMQuestionSubController.h"
#import <QMLineSDK/QMLineSDK.h>
#import "QMActivityView.h"
#import "QMQuestionCell.h"
#import "QMAlert.h"
#import "MJRefresh.h"
@interface QMQuestionSubController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *rootView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger currentCount;

@end

@implementation QMQuestionSubController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect frm = self.view.bounds;
    frm.size.height = kScreenHeight - kStatusBarAndNavHeight;
    self.rootView = [[UITableView alloc] initWithFrame:frm style:UITableViewStylePlain];
    self.rootView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    self.rootView.tableFooterView = [UIView new];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    header.backgroundColor = UIColor.clearColor;
    self.rootView.tableHeaderView = header;
    self.rootView.estimatedRowHeight = 200;
    self.rootView.rowHeight = UITableViewAutomaticDimension;
    self.rootView.dataSource = self;
    self.rootView.delegate = self;
    //        self.rootView.delegate = self;
    __weak typeof(self)wSelf = self;
    self.currentCount = 1;
    self.rootView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [wSelf getSubCommonQuestion];
    }];

    self.rootView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.rootView];
    self.dataArr = [NSMutableArray array];
    [self getSubCommonQuestion];
}


- (void)getSubCommonQuestion {
    
    NSString *cid = self.groupModel._id;
    [QMActivityView startAnimating];
    
    NSDictionary *parameters = @{
                                 @"Action"       : @"sdkPullQAMsg",
                                 @"qaType"       : @"queryItemListInf",
                                 @"cid"           : cid,
                                 @"page"          : @(self.currentCount),
                                 @"limit"        : [NSNumber numberWithInt:30]
                                 };
    
    [QMConnect sdkGetCommonDataWithParams:parameters completion:^(NSDictionary *data) {
        
        if ([data[@"Succeed"] boolValue] == YES) {
            NSArray *dataArr = data[@"list"];
            if (dataArr.count > 0) {
                [self.dataArr addObjectsFromArray:dataArr];
                [self.rootView.mj_footer endRefreshing];
                self.currentCount++;
                [self.rootView reloadData];
            } else {
                
                [self.rootView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            [self.rootView.mj_footer endRefreshing];
        }

        [QMActivityView stopAnimating];
    } failure:^(NSError *error) {
        [QMActivityView stopAnimating];
        [self.rootView.mj_footer endRefreshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QMQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id"];
    if (!cell) {
        cell = [[QMQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_id"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = self.dataArr[indexPath.row];
    QMQuestionModel *model = [[QMQuestionModel alloc] initWithDictionary:dict error:nil];
    
    [cell setCellData:model.title];
    
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArr[indexPath.row];
    QMQuestionModel *model = [[QMQuestionModel alloc] initWithDictionary:dict error:nil];
    [self senderMsg:model];
}

- (void)senderMsg:(QMQuestionModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"sdkPullQAMsg" forKey:@"Action"];
    [dict setValue:@"getKmDetailInf" forKey:@"qaType"];
    [dict setValue:@"text" forKey:@"contentType"];
    [dict setValue:model._id forKey:@"qaItemInfoId"];
    [dict setValue:model.title forKey:@"content"];

    [QMConnect sdkGetCommonDataWithParams:dict completion:^(NSDictionary *data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.backQuestion) {
                self.backQuestion(model);
            }
            NSInteger count = self.navigationController.viewControllers.count;
            if (count >= 3) {
                [self.navigationController popToViewController:self.navigationController.viewControllers[count - 3] animated:YES];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        });
    } failure:^(NSError *error) {
        [QMAlert showMessage:@"发送失败!"];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

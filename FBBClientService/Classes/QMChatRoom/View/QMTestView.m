//
//  QMTestView.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/6/3.
//  Copyright © 2019年 HCF. All rights reserved.
//

#import "QMTestView.h"
#import "QMTextModel.h"

@implementation QMTestView {
    
    UITableView *_tableView;
    
    NSMutableArray *_peerArr;
    
    UILabel *_titleLabel;
    
    UILabel *_lineLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return  self;
}

- (void)createView {
//    self.backgroundColor = [UIColor magentaColor];
//    [self setUserInteractionEnabled:YES];
    self.coverView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    
    self.coverView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.coverView addGestureRecognizer:tapGesture];
    [self addSubview:self.coverView];
    
    self.cancelButton = [[UIButton alloc] init];
    self.cancelButton.frame = CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50);
    [self.cancelButton setTitle:@"取  消" forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
    [self.cancelButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];

    _tableView = [[UITableView alloc] init];
//    _tableView.frame = self.bounds;
//    _tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _tableView.backgroundColor = [UIColor yellowColor];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleLabel];
    
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    [self addSubview:_lineLabel];

}

- (void)showData:(NSArray *)array title:(NSString *)title {
    
    CGFloat tableViewHeight = 0;
    _peerArr = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        [_peerArr addObject:dic];
        NSLog(@"------%@",[dic objectForKey:@"name"]);
        CGFloat textHeight = [QMTextModel calculateRowHeight:[dic objectForKey:@"name"] fontSize:15 width:30];
        CGFloat height = textHeight > 30 ? textHeight + 30 : 50;
        tableViewHeight += height;
    }
    _tableView.frame = CGRectMake(0, kScreenHeight - tableViewHeight - 60, kScreenWidth, tableViewHeight);
    
    _titleLabel.text = title;
    CGFloat titleHeight = [QMTextModel calculateRowHeight:title fontSize:18 width:30];
    CGFloat titleH = titleHeight > 30 ? titleHeight + 30 : 50;
    _titleLabel.frame = CGRectMake(0, kScreenHeight - tableViewHeight - 60 - titleH, kScreenWidth, titleH);
    _lineLabel.frame = CGRectMake(0, kScreenHeight - tableViewHeight - 60, kScreenWidth, 1);
    [_tableView reloadData];
}

- (void)tapAction{
    [self removeFromSuperview];
}

- (void)cancelAction {
    [self removeFromSuperview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _peerArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"testCell";
    QMTestCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[QMTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dic = _peerArr[indexPath.row];
    [cell showText:[dic objectForKey:@"name"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [QMTextModel calculateRowHeight:[_peerArr[indexPath.row] objectForKey:@"name"] fontSize:15 width:30];
    return height > 30 ? height + 30 : 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"34254354354");
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSDictionary *dic = _peerArr[indexPath.row];
    self.peerSelect(dic);
    [self removeFromSuperview];
}

@end

@implementation QMTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.questionLabel = [[UILabel alloc] init];
    self.questionLabel.frame = CGRectMake(15, 15, kScreenWidth - 30, 20);
    self.questionLabel.text = @"";
    self.questionLabel.numberOfLines = 0;
    self.questionLabel.textAlignment = NSTextAlignmentCenter;
    self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.questionLabel.font = [UIFont systemFontOfSize:15];
    self.questionLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    [self.contentView addSubview:self.questionLabel];
}

- (void)showText:(NSString *)text {
    self.questionLabel.text = text;
    CGFloat textHeight = [QMTextModel calculateRowHeight:text fontSize:15 width:30];
    CGFloat height = textHeight > 30 ? textHeight : 30;
    self.questionLabel.frame = CGRectMake(15, 15, kScreenWidth - 30, height);
}



@end

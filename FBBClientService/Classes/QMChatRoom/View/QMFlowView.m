//
//  testView.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/9/2.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMFlowView.h"
#import "CustormLayout.h"
#import "QMChatRoomRobotFlowCollectionCell.h"
#import "QMTextModel.h"
#import "QMAlert.h"

@interface QMFlowView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) CustormLayout *layout;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

//上下左右的间距
static CGFloat topGap = 10;
static CGFloat leftGap = 10;
static CGFloat rightGap = 10;
static CGFloat lineSpace = 10.f;
static CGFloat InteritemSpace = 10.f;

@implementation QMFlowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return  self;
}

- (void)createUI {
    
    _headerLabel = [[UILabel alloc] init];
    _headerLabel.frame = CGRectMake(10, 6, CGRectGetWidth(self.frame), 20);
    _headerLabel.text = @"";
    _headerLabel.numberOfLines = 0;
    _headerLabel.font = [UIFont systemFontOfSize:15.0f];
    _headerLabel.textColor = [UIColor blackColor];
    [self addSubview:_headerLabel];

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 80, CGRectGetWidth(self.frame), 10)];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self addSubview:_pageControl];

    [self.collectionView registerClass:[QMChatRoomRobotFlowCollectionCell class] forCellWithReuseIdentifier:@"FlowCollectionCell"];

    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [self addSubview:_lineLabel];

}

- (void)setDate {
    self.dataSource = [QMTextModel dictionaryWithJsonString:self.flowList];
    CGFloat number = self.dataSource.count/8;
    if (self.dataSource.count%8 == 0) {
        number = self.dataSource.count/8;
    }else {
        number = self.dataSource.count/8+1;
    }
    
    CGFloat titleHeight = [QMAlert calculateRowHeight:self.flowTip fontSize:15.0f Width:CGRectGetWidth(self.frame) - 20];
    if (titleHeight < 20) {
        titleHeight = 20;
    }
    
    _headerLabel.frame = CGRectMake(10, 12, CGRectGetWidth(self.frame) - 20, titleHeight);
    _headerLabel.text = self.flowTip;
    
    _lineLabel.frame = CGRectMake(10, CGRectGetMaxY(_headerLabel.frame)+12, CGRectGetWidth(self.frame) - 20, 1);

    _collectionView.frame = CGRectMake(0, 25 + titleHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 25 - titleHeight - 20);
    _pageControl.frame = CGRectMake(10,  CGRectGetHeight(self.frame) - 20, CGRectGetWidth(self.frame) - 20, 10);
    _pageControl.numberOfPages = number;
    
    [self.collectionView reloadData];
}

#pragma mark ************* lazy load *************
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        self.layout = [[CustormLayout alloc]init];
        self.layout.minimumLineSpacing = lineSpace;
        self.layout.minimumInteritemSpacing = InteritemSpace;
        self.layout.itemSize = CGSizeMake(115, 40);
        self.layout.sectionInset = UIEdgeInsetsMake(topGap, leftGap, 0, rightGap);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + 44, kScreenWidth, kScreenHeight - [UIApplication sharedApplication].statusBarFrame.size.height - 44) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark ************* collectionView data *************
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMChatRoomRobotFlowCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlowCollectionCell" forIndexPath:indexPath];
    [cell showData:self.dataSource[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectAction(self.dataSource[indexPath.row]);
}

#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(_collectionView.frame);
    NSUInteger page = floor((_collectionView.contentOffset.x - pageWidth/2)/pageWidth) + 1;
    _pageControl.currentPage = page;
}




@end

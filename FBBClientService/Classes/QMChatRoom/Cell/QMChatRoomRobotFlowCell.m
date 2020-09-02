//
//  QMChatRoomRobotFlowCell.m
//  IMSDK-OC
//
//  Created by lishuijiao on 2019/8/29.
//  Copyright © 2019 HCF. All rights reserved.
//

#import "QMChatRoomRobotFlowCell.h"
#import "QMFlowView.h"
#import "QMTextModel.h"
#import "QMAlert.h"

@implementation QMChatRoomRobotFlowCell {
    
    UILabel *_headerLabel;
    
    UIScrollView *_scrollView;
    
    UICollectionView *_collectionView;
    
    QMFlowView *flowView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    flowView = [[QMFlowView alloc] init];
    flowView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, kScreenWidth - 150, 300);
    [self.contentView addSubview:flowView];
    
}

- (void)setData:(CustomMessage *)message avater:(NSString *)avater {
    self.message = message;
    [super setData:message avater:avater];
    if ([message.fromType isEqualToString:@"0"]) {
        
    }else {
        
        message.robotFlowTip = [message.robotFlowTip stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        message.robotFlowTip = [message.robotFlowTip stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        message.robotFlowTip = [message.robotFlowTip stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];

        NSRegularExpression *regularExpretion = [[NSRegularExpression alloc] initWithPattern:@"<[^>]*>" options:NSRegularExpressionCaseInsensitive error:nil];
        message.robotFlowTip = [regularExpretion stringByReplacingMatchesInString:message.robotFlowTip options:NSMatchingReportProgress range:NSMakeRange(0, message.robotFlowTip.length) withTemplate:@""];
        
        NSMutableArray * arr = [QMTextModel dictionaryWithJsonString:self.message.robotFlowList];
        CGFloat messageHeight = 0;
        
        CGFloat titleHeight = [QMAlert calculateRowHeight:self.message.robotFlowTip fontSize:15.0f Width:240];
        if (titleHeight < 20) {
            titleHeight = 20;
        }
        if (arr.count < 7) {
            if (arr.count%2 == 0) {
                messageHeight = 25+titleHeight+30+ceil(arr.count/2)*50;
            }else {
                messageHeight = 25+titleHeight+30+ceil(arr.count/2+1)*50;
            }
        }else {
            messageHeight = 265 + titleHeight;
        }
        
        self.chatBackgroudImage.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, 260, messageHeight);
        self.chatBackgroudImage.image = [self.chatBackgroudImage.image stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        flowView.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.timeLabel.frame)+10, 260, messageHeight);
        flowView.flowList = self.message.robotFlowList;
        flowView.flowTip = self.message.robotFlowTip;
        __weak typeof(self) weakSelf = self;
        flowView.selectAction = ^(NSDictionary * dic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.tapSendMessage(dic[@"text"], @"");
            });
        };
        [flowView setDate];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

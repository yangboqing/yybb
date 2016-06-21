//
//  WYAccountInfoAlertView.m
//  browser
//
//  Created by 王毅 on 15/3/18.
//
//

#import "WYAccountInfoAlertView.h"
#import "AccountInfoTableViewController.h"

@interface WYAccountInfoAlertView (){
    UIImageView *mbImageView;
    UIImageView *bgImageView;
    
    UIImageView *hLine;
    UIButton *bottomBtn;
    
    AccountInfoTableViewController *tableView;
    
}

@end

@implementation WYAccountInfoAlertView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.backgroundColor = hllColor(244, 244, 244, 1);
        
        mbImageView = [UIImageView new];
        mbImageView.backgroundColor = BLACK_COLOR;
        mbImageView.alpha = 0.2;
        
        bgImageView = [UIImageView new];
        bgImageView.layer.cornerRadius = 5;
        bgImageView.clipsToBounds = YES;
        bgImageView.userInteractionEnabled = YES;
        bgImageView.backgroundColor = WHITE_COLOR;

        
        tableView = [[AccountInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        tableView.tableView.showsVerticalScrollIndicator = NO;
        
        
        hLine = [UIImageView new];
        hLine.backgroundColor = hllColor(209, 209, 209, 1);

        
        
        bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.backgroundColor = CLEAR_COLOR;
        [bottomBtn setTitleColor:hllColor(11, 98, 251, 1) forState:UIControlStateNormal];
        [bottomBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [bottomBtn addTarget:self action:@selector(clickaction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [self addSubview:mbImageView];
        [self addSubview:bgImageView];
        [bgImageView addSubview:tableView.view];
        [bgImageView addSubview:hLine];
        [bgImageView addSubview:bottomBtn];

        
        
        
        
    }
    
    return self;
    
}
#define BTN_Y bgImageView.frame.size.height - 44*IPHONE6_XISHU
- (void)layoutSubviews{
    
    mbImageView.frame = self.bounds;
    bgImageView.frame = CGRectMake(25*IPHONE6_XISHU, (self.frame.size.height - 440*IPHONE6_XISHU)/2, self.frame.size.width - 50*IPHONE6_XISHU, 440*IPHONE6_XISHU);
    tableView.view.frame = CGRectMake(0, - 15, bgImageView.frame.size.width, 386*IPHONE6_XISHU);
    
    hLine.frame = CGRectMake(20*IPHONE6_XISHU, tableView.view.frame.origin.y + tableView.view.frame.size.height + 5, bgImageView.frame.size.width - 40*IPHONE6_XISHU, 1);
    bottomBtn.frame = CGRectMake(0, BTN_Y, bgImageView.frame.size.width, 44*IPHONE6_XISHU);
    
}


- (void)clickaction:(UIButton *)sender{

    self.hidden = YES;
    
}
- (void)reloadList{
    [tableView getAccountInfoData];
    [tableView.tableView reloadData];
}

@end

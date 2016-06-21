//
//  AppidAlert.m
//  browser
//
//  Created by caohechun on 15/3/18.
//
//

#import "AppidAlert.h"

//#define width1 20

#define boarder1 200//上
#define boarder2 35//左

#define img_boarder1 14//上
#define img_boarder2 14//左
#define img_width (MainScreen_Width/PHONE_SCALE_PARAMETER - 2*(boarder2 + img_boarder2))
#define img_height (165*img_width/598)

#define label_board 10//上
#define label_height 25

#define button_height 38

#define button_font 13*PHONE_SCALE_PARAMETER
#define label_font 13


#define alert_height    (img_boarder1 + img_height + label_board + 2*label_height +button_height + 10)

@implementation AppidAlert

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor clearColor];
        baseView = [[UIView alloc] initWithFrame:frame];
        baseView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(boarder2*IPHONE6_XISHU, boarder1*IPHONE6_XISHU, MainScreen_Width - 2*boarder2*IPHONE6_XISHU, alert_height*IPHONE6_XISHU)];
        contentView.layer.cornerRadius = 5;
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.clipsToBounds = YES;
        
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width - img_width*IPHONE6_XISHU)/2, img_boarder2*IPHONE6_XISHU, img_width*IPHONE6_XISHU, img_height*IPHONE6_XISHU)];
        imageView.image = [UIImage imageNamed:@"acount_copy.png"];
        [contentView addSubview:imageView];
        
        appid = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height + label_board, imageView.frame.size.width, label_height*PHONE_SCALE_PARAMETER)];
        appid.textAlignment = NSTextAlignmentLeft;
        appid.textColor  = [UIColor grayColor];
        [contentView addSubview:appid];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, appid.frame.origin.y + appid.frame.size.height, contentView.frame.size.width, 0.5)];
        line.backgroundColor  = [UIColor grayColor];
        [contentView addSubview:line];
        
        password = [[UILabel alloc] initWithFrame:CGRectMake(appid.frame.origin.x, appid.frame.origin.y + appid.frame.size.height + 10, appid.frame.size.width, appid.frame.size.height)];
        password.textAlignment = NSTextAlignmentLeft;
        password.textColor = [UIColor grayColor];
        [contentView addSubview:password];
        
        UILabel *line_ = [[UILabel alloc] initWithFrame:CGRectMake(0, password.frame.origin.y + password.frame.size.height, contentView.frame.size.width, 0.5)];
        line_.backgroundColor  = [UIColor grayColor];
        [contentView addSubview:line_];
        
        //获取账号信息
        [self getSavedAppid];
        
        
        UIButton *known = [UIButton buttonWithType:UIButtonTypeCustom];
        [known setTitle:@"我知道了" forState:UIControlStateNormal];
        known.frame = CGRectMake(0, line_.frame.origin.y + 1, contentView.frame.size.width/2 - 0.5, button_height*PHONE_SCALE_PARAMETER);
        known.titleLabel.font = [UIFont systemFontOfSize:button_font];
        [known setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [known addTarget:self action:@selector(known) forControlEvents:UIControlEventTouchUpInside];
        known.titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:known];
        
        UILabel *line__ = [[UILabel alloc] initWithFrame:CGRectMake(known.frame.origin.x + known.frame.size.width, known.frame.origin.y, 0.5, known.frame.size.height + 5)];
        line__.backgroundColor = [UIColor grayColor];
        [contentView addSubview:line__];
        
        UIButton *copy = [UIButton buttonWithType:UIButtonTypeCustom];
        [copy setTitle:@"复制账号和密码" forState:UIControlStateNormal];
        copy.titleLabel.font = [UIFont systemFontOfSize:button_font];
        [copy setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        copy.frame = CGRectMake(line__.frame.origin.x + 0.5, line_.frame.origin.y + 1, contentView.frame.size.width/2 - 0.5, known.frame.size.height);
        [copy addTarget:self action:@selector(copyAppid) forControlEvents:UIControlEventTouchUpInside];
        copy.titleLabel.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:copy];
        
        
        [baseView addSubview:contentView];
        [self addSubview:baseView];
        
    }
    return self;
}

- (void)getSavedAppid{
    //获取保存的appid
    
    NSDictionary *dic = [[FileUtil instance] getAccountPasswordInfo];
    if (dic && [dic objectForKey:SAVE_ACCOUNT] && [dic objectForKey:SAVE_PASSWORD]) {
        savedAppid = [dic objectForKey:SAVE_ACCOUNT];
        savedPassword = [dic objectForKey:SAVE_PASSWORD];
    }else{
        savedAppid = @"---";
        savedPassword = @"---";
    }

    appid.text = savedAppid;
    password.text = savedPassword;
}
- (void)known{
    self.hidden = YES;
    [self beginInstall];
    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:COPY_ACCOUNT_INFOR];
}
- (void)copyAppid{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@ %@",savedAppid,savedPassword]];
    self.hidden = YES;
    [self beginInstall];
}
- (void)setAppDistri:(NSString *)distri{
    currentDistri = distri;
}

- (void)beginInstall{
    if (currentDistri) {
        [[BppDistriPlistManager getManager] installPlistURL:currentDistri];
        currentDistri = nil;
    }
}

@end

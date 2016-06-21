//
//  HeadImageView.m
//  browser
//
//  Created by admin on 13-9-3.
//
//

#import "HeadImageView.h"

@implementation HeadImageView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
        
        allStartImg = [UIImage imageNamed:@"btn-allstart.png"];//LOADIMAGE(@"btn-allstart", @"png");
        allPauseImg = [UIImage imageNamed:@"btn-allPause.png"]; //LOADIMAGE(@"btn-allPause", @"png");
        editImg = [UIImage imageNamed:@"btn-edit.png"]; //LOADIMAGE(@"btn-edit", @"png");
        editCancelImg = [UIImage imageNamed:@"btn-editcance.png"]; //LOADIMAGE(@"btn-editcance", @"png");
        allUpdateImg = [UIImage imageNamed:@"all_update.png"]; //LOADIMAGE(@"all_update", @"png");
        
        // 提示信息label
        lessonTipLabel = [[UITouchLabel alloc]init];
        lessonTipLabel.textAlignment = NSTextAlignmentLeft;
        lessonTipLabel.font = [UIFont systemFontOfSize:12];
        lessonTipLabel.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
        lessonTipLabel.text = @"下载的应用闪退？点我开始修复"; // 下载的应用会闪退或需输账号密码？( 详细 )
        lessonTipLabel.delegate = self;
        [self addSubview:lessonTipLabel];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [LocalImageManager setImageName:@"closeRepair_.png" complete:^(UIImage *image) {
            [closeBtn setImage:image forState:UIControlStateNormal];
        }];
        [closeBtn addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        lessonTipLabel.hidden = YES;
        closeBtn.hidden = YES;
        
        // 全部开始/暂停按钮
//        UIButton *startPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [startPauseBtn setImage:allStartImg forState:UIControlStateNormal];
//        startPauseBtn.hidden = NO;
//        [self addSubview:startPauseBtn];
//        self.allStartPauseBtn = startPauseBtn;
        
        
         UIButton *startPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        startPauseBtn.tag = (NSUInteger)self;
        [startPauseBtn setTitle:@"全部开始" forState:UIControlStateNormal];

        startPauseBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [startPauseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [startPauseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [startPauseBtn setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
        [startPauseBtn setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
                [self addSubview:startPauseBtn];
        self.allStartPauseBtn = startPauseBtn;

        
        
        // 全部更新
        self.allUpdatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.allUpdatBtn setImage:allUpdateImg forState:UIControlStateNormal];
        [self addSubview:_allUpdatBtn];
        self.allUpdatBtn.hidden = YES;
        
        // 编辑
     //   self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       // [self.editBtn setImage:editImg forState:UIControlStateNormal];
        //[self addSubview:_editBtn];
        //self.editBtn.hidden = NO;
        
        
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.editBtn.tag = (NSUInteger)self;
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];

        self.editBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [self.editBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
        [self addSubview:_editBtn];
        self.editBtn.hidden = NO;

        
        [self setCustomFrame];
        
        // 底部分割线
        UIImageView *cuttingLineView = [[UIImageView alloc] init];
        cuttingLineView.frame = CGRectMake(0, 35.5, MainScreen_Width, 0.5);
        cuttingLineView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
        [self addSubview:cuttingLineView];
        
    }
    return self;
}

#pragma mark - Utility

-(void)hideLessonTipView:(BOOL)flag
{// 外露接口
    BOOL hideFlag = isCloseBtnClick?YES:flag;
    lessonTipLabel.hidden = hideFlag;
    closeBtn.hidden = hideFlag;
}

- (void)closeButtonClick:(id)sender
{// 点击closeButton后，再不会出现修复教程提示
    lessonTipLabel.hidden = YES;
    closeBtn.hidden = YES;
    isCloseBtnClick = YES;
}

-(void)changeButtonTitleWithType:(HeadImage_ButtonType)type
{// 改变按钮的title
    switch (type) {
        case allStart_Type:{
//            [self.allStartPauseBtn setImage:allStartImg forState:UIControlStateNormal];
            [self.allStartPauseBtn setTitle:@"全部开始" forState:UIControlStateNormal];

            self.allStartPauseBtn.tag = allStart_Type;
        }
            break;
        case allPause_Type:{
//            [self.allStartPauseBtn setImage:allPauseImg forState:UIControlStateNormal];
            [self.allStartPauseBtn setTitle:@"全部暂停" forState:UIControlStateNormal];

            self.allStartPauseBtn.tag = allPause_Type;
        }
            break;
        case edit_Type:{
//            [self.editBtn setImage:editImg forState:UIControlStateNormal];
            [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];

            self.editBtn.tag = edit_Type;
        }
            break;
        case editCancel_Type:{
//            [self.editBtn setImage:editCancelImg forState:UIControlStateNormal];
            [self.editBtn setTitle:@"取消" forState:UIControlStateNormal];

            self.editBtn.tag = editCancel_Type;
        }
            break;
            
        default:
            break;
    }
}

-(void)setCustomFrame
{
    float tmp = (MainScreen_Width == 320)?0:20;
    
    //my助手不显示
//    lessonTipLabel.frame = CGRectMake(10*PHONE_SCALE_PARAMETER, 0, MainScreen_Width-(140 + tmp)*PHONE_SCALE_PARAMETER, 36);
//    closeBtn.frame = CGRectMake(lessonTipLabel.frame.size.width, 10, 16, 16);
    
    self.allStartPauseBtn.frame = CGRectMake(10, 6, 65, 24);
    self.allUpdatBtn.frame = CGRectMake(MainScreen_Width-65-10, 6, 130/2, 48/2);
    self.editBtn.frame = CGRectMake(MainScreen_Width-(45 + 10), 6, 45, 24);
}

#pragma mark - UITouchLabelDelegate

-(void)tapTouchLabel:(UILabel *)touchLabel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_REPAIRAPP_ALL object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:OPEN_REPAIRAPP_DOWNLOAD object:@"open"];
}

@end

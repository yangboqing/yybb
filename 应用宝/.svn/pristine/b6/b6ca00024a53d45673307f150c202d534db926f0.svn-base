//
//  UtilityViewController.m
//  MyHelper
//
//  Created by liguiyang on 15-3-3.
//  Copyright (c) 2015年 myHelper. All rights reserved.
//

#import "UtilityViewController.h"
//#import "JHAPISDK.h"
//#import "JHOpenidSupplier.h"
#import "SearchInformationCell.h"

@interface UtilityViewController ()
{
    UtilityType type;
}

@end

@implementation UtilityViewController

- (instancetype)initWithUtilityType:(UtilityType)utilityType
{
    self = [super init];
    if (self) {
        type = utilityType;
        _dataArr = [[NSMutableArray alloc]init];
        _deviceDataArr = [[NSMutableArray alloc]init];
        _numberNameArr = [NSMutableArray arrayWithObjects:@"所查号码",@"卡号归属地",@"运营商",@"卡类型",@"城市区号",@"城市邮编", nil];
        _deviceNameArr = [NSMutableArray arrayWithObjects:@"设备信息",@"产品型号",@"产品序列号",@"生产日期",@"保修信息",@"购买时间",@"保修截止",@"保修状态",@"激活状态",@"电话支持", nil];
        
    }
    
    return self;
}

#pragma mark search归属地或设备维修记录
-(void)PhoneNumberAttributionOrDeviceInformation
{
    UIImage * image = [UIImage imageNamed:@"nav_categoryIcon.png"];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =  CGRectMake(10, 18, image.size.width/2, image.size.height/2);
    [backBtn setBackgroundImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    // 搜索框
    UIImage *iconImg = [UIImage imageNamed:@"search_icon.png"];
    UIImage *slashImg = [UIImage imageNamed:@"search_slash.png"];
    UIImageView *iconImgV  = [[UIImageView alloc] initWithImage:iconImg];
    UIImageView *slashImgV = [[UIImageView alloc] initWithImage:slashImg];
   UIView * leftView = [[UIView alloc] init];
    [leftView addSubview:iconImgV];
    [leftView addSubview:slashImgV];
    
    iconImgV.frame = CGRectMake(10,(30-iconImg.size.height*0.5)*0.5, iconImg.size.width*0.5, iconImg.size.height*0.5);
    slashImgV.frame = CGRectMake(iconImgV.frame.origin.x+iconImgV.frame.size.width+7, 1, 6, 29);
    leftView.frame = CGRectMake(0, 0, 40, 30);
    
    _textField = [[UITextField alloc]init];
    [_textField setBorderStyle:UITextBorderStyleNone];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.backgroundColor = hllColor(241.0, 241.0, 241.0, 1.0);
    _textField.placeholder = (type == utility_phoneNumberType?@"请输入需要查询的手机号码":@"请输入需要查询的设备序列号");
    _textField.font = [UIFont systemFontOfSize:15];
    _textField.textColor = hllColor(178.f, 178.f, 178.f, 1.0);
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.delegate = self;
    _textField.keyboardType = ((type == utility_phoneNumberType)?UIKeyboardTypeNumbersAndPunctuation:UIKeyboardTypeDefault);
    
    [self.view addSubview:_textField];
    
    //分割线
    _lineView= [[UIView alloc]init];
    _lineView.backgroundColor = hllColor(228.0, 228.0, 228.0, 1.0);
    [self.view addSubview:_lineView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _lineView.frame.origin.y +_lineView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - ( _lineView.frame.origin.y +_lineView.frame.size.height)) style:UITableViewStylePlain];
    _tableView.backgroundColor =  hllColor(189.f, 210.f, 227.f, 1.0);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    //下拉刷新
    _egoRefreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectZero];
    _egoRefreshView.egoDelegate = self;
    _egoRefreshView.inset = _tableView.contentInset;
    [_tableView addSubview:_egoRefreshView];
}

#pragma mark 设备维修记录
-(void)searchDeviceRepairInformation
{
    if (_textField.text) {
       NSString *path = @"http://apis.juhe.cn/appleinfo/index";
        NSString *api_id = @"37";
        NSString *method = @"GET";
        NSDictionary *param = nil; //@{@"sn":_textField.text ,@"key":APPLE_APPKEY,@"dtype":@"json"};
//        JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
//        [juheapi executeWorkWithAPI:path
//                              APIID:api_id
//                         Parameters:param
//                             Method:method
//                            Success:^(id responseObject){
//                                NSString *str1 = [NSString stringWithCString:[[responseObject objectForKey:@"reason"] UTF8String] encoding:NSUTF8StringEncoding];
//                                if ([[responseObject objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
//                                    NSDictionary *dic = [responseObject objectForKey:@"result"];
//                                    if (dic.allKeys.count) {
//                                        NSString *phone_model = [dic objectForKey:@"phone_model"]; //设备型号
//                                        NSString *serial_number;
//                                        if ([[dic objectForKey:@"serial_number"] isEqualToString:@""] && ![[dic objectForKey:@"imei_number"] isEqualToString:@""]) {
//                                            //输入是imei
//                                            serial_number = [dic objectForKey:@"imei_number"];
//                                            [_deviceNameArr replaceObjectAtIndex:2 withObject:@"IMEI"];
//                                        }
//                                        else if (![[dic objectForKey:@"serial_number"] isEqualToString:@""] && [[dic objectForKey:@"imei_number"] isEqualToString:@""])
//                                        {
//                                           //输入为序列号
//                                            serial_number = [dic objectForKey:@"serial_number"];
//                                            [_deviceNameArr replaceObjectAtIndex:2 withObject:@"产品序列号"];
//                                        }
//                                        NSString *start_date = [dic objectForKey:@"start_date"];//生产时间开始
//                                        NSString *end_date = [dic objectForKey:@"end_date"];//生产时间开始
//                                        NSString *warranty = [dic objectForKey:@"warranty"];//保修到期
//                                        NSString *warranty_status = [NSString stringWithCString:[[dic objectForKey:@"warranty_status"] UTF8String] encoding:NSUTF8StringEncoding];;//保修状态
//                                        NSString *tele_support_status = [NSString stringWithCString:[[dic objectForKey:@"tele_support_status"] UTF8String] encoding:NSUTF8StringEncoding];//电话支持状态
//                                        NSString *active = [NSString stringWithCString:[[dic objectForKey:@"active"] UTF8String] encoding:NSUTF8StringEncoding];//激活状态
//                                        if (_deviceDataArr.count) {
//                                            [_deviceDataArr removeAllObjects];
//                                        }
//                                        [_deviceDataArr addObject:@""];
//                                        [_deviceDataArr addObject:phone_model];
//                                        [_deviceDataArr addObject:serial_number];
//                                        [self changeDateFromString:start_date];//生产日期
//                                        [_deviceDataArr addObject:@""];
//                                         [self changeDateFromString:end_date];//购买日期
//                                         [self changeDateFromString:warranty];//保修截止
//                                        [_deviceDataArr addObject:warranty_status];// 保修状态
//                                        [_deviceDataArr addObject:active];//激活状态
//                                        [_deviceDataArr addObject:tele_support_status];
//                                        if (_deviceDataArr.count) {
//                                            [_tableView reloadData];
//                                        }
//   
//                                    }
//                                }
//                                else
//                                {
//                                    if (_deviceDataArr.count) {
//                                        [_deviceDataArr removeAllObjects];
//                                    }
//                                   [_tableView reloadData];
//                                    UIAlertView *tmpAlertView = [[UIAlertView alloc] initWithTitle:@"返回数据错误"
//                                                                                           message:str1
//                                                                                          delegate:self
//                                                                                 cancelButtonTitle:@"知道了"
//                                                                                 otherButtonTitles:nil, nil];
//                                    [tmpAlertView show];
//                                }
//                               
//                                
//                            } Failure:^(NSError *error) {
//                                [_tableView reloadData];
//                                UIAlertView *tmpAlertView = [[UIAlertView alloc] initWithTitle:@"网络不给力"
//                                                                                       message:@"网络不给力，请下拉刷新"
//                                                                                      delegate:self
//                                                                             cancelButtonTitle:@"知道了"
//                                                                             otherButtonTitles:nil, nil];
//                                [tmpAlertView show];
//                                
//                            }];
//        
//    }

}

}

-(void)changeDateFromString:(NSString *)str
{
    if (str.length>4) {
        [_deviceDataArr addObject:[NSString stringWithFormat:@"%@年%@月",[str substringToIndex:4],[str substringWithRange: NSMakeRange(5, 2)]]];//购买日期
    }
    else
    {
        [_deviceDataArr addObject:@""];
    }


}



#pragma mark 机号码归属地
-(void)searchPhoneNumberAttribution
{
    if (_textField.text) {
//        NSString *path = @"http://apis.juhe.cn/mobile/get";
//        NSString *api_id = @"11";
//        NSString *method = @"GET";
//        NSDictionary *param = @{@"phone":_textField.text ,@"key":PHONE_NUMBER_APPKEY,@"dtype":@"json"};
//        JHAPISDK *juheapi = [JHAPISDK shareJHAPISDK];
//        
//        [juheapi executeWorkWithAPI:path
//                              APIID:api_id
//                         Parameters:param
//                             Method:method
//                            Success:^(id responseObject){
//                                 NSString *str1 = [NSString stringWithCString:[[responseObject objectForKey:@"reason"] UTF8String] encoding:NSUTF8StringEncoding];
//                                if ([[responseObject objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
//                                    NSDictionary *dic = [responseObject objectForKey:@"result"];
//                                    if (dic) {
//                                        NSString *areacode = [dic objectForKey:@"areacode"];
//                                        NSString *card = [NSString stringWithCString:[[dic objectForKey:@"card"] UTF8String] encoding:NSUTF8StringEncoding];
//                                        NSString *city = [NSString stringWithCString:[[dic objectForKey:@"city"] UTF8String] encoding:NSUTF8StringEncoding];
//                                        NSString *company = [NSString stringWithCString:[[dic objectForKey:@"company"] UTF8String] encoding:NSUTF8StringEncoding];
//                                        NSString *province = [NSString stringWithCString:[[dic objectForKey:@"province"] UTF8String] encoding:NSUTF8StringEncoding];
//                                        NSString *zip = [dic objectForKey:@"city"];
//                                        if (_dataArr.count) {
//                                            [_dataArr removeAllObjects];
//                                        }
//                                        [_dataArr addObject:_textField.text];
//                                        [_dataArr addObject:[NSString stringWithFormat:@"%@%@",province,city]];
//                                        [_dataArr addObject:company];
//                                        [_dataArr addObject:card];
//                                        [_dataArr addObject:areacode];
//                                        [_dataArr addObject:zip];
//                                        if (_dataArr.count) {
//                                            [_tableView reloadData];
//                                        }
//                                    }
//                                }
//                                else
//                                {
//                                    if (_dataArr.count) {
//                                        [_dataArr removeAllObjects];
//                                    }
//                                    [_tableView reloadData];
//                                    UIAlertView *tmpAlertView = [[UIAlertView alloc] initWithTitle:@"返回数据错误"
//                                                                                           message:str1
//                                                                                          delegate:self
//                                                                                 cancelButtonTitle:@"知道了"
//                                                                                 otherButtonTitles:nil, nil];
//                                    [tmpAlertView show];
//                                }
//                            } Failure:^(NSError *error) {
//                                [_dataArr removeAllObjects];
//                                [_tableView reloadData];
//                                UIAlertView *tmpAlertView = [[UIAlertView alloc] initWithTitle:@"网络不给力"
//                                                                                       message:@"网络不给力，请下拉刷新"
//                                                                                      delegate:self
//                                                                             cancelButtonTitle:@"知道了"
//                                                                             otherButtonTitles:nil, nil];
//                                [tmpAlertView show];
//                            }];
//       
//    
//    }

}
}

#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
        [self PhoneNumberAttributionOrDeviceInformation];
}




-(void)pop
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    if (_textField) {
        [_textField becomeFirstResponder];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillLayoutSubviews
{
    _textField.frame =CGRectMake(47*MainScreen_Width/375,28, self.view.frame.size.width - 64*MainScreen_Width/375, 28);
    _lineView.frame = CGRectMake(0, _textField.frame.origin.y + _textField.frame.size.height +7*MainScreen_Width/375, self.view.frame.size.width, 1);
    _tableView.frame = CGRectMake(0, _lineView.frame.origin.y +_lineView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - ( _lineView.frame.origin.y +_lineView.frame.size.height));
    CGRect rect = _tableView.frame ;
    _egoRefreshView.frame = CGRectMake(0, -rect.size.height, rect.size.width, rect.size.height);
    _mirrorViewController.view.frame = self.view.bounds;
    
}

#pragma  mark ego

-(void)refreshRequest
{
    [_dataArr removeAllObjects];
    [_deviceDataArr removeAllObjects];
    if (type == utility_phoneNumberType) {
        
        [self searchPhoneNumberAttribution];
    }
    else if (type == utility_deviceRecordType)
    {
        [self searchDeviceRepairInformation];
    }
    
}


-(void)pullRequest
{
    [self refreshRequest];
    [self hideDownPullRefreshView];
    
}

-(void)hideDownPullRefreshView
{
    _refreshHeaderLoading = NO;
    [_egoRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    _refreshHeaderLoading = YES;
    [self performSelector:@selector(pullRequest) withObject:nil afterDelay:delayTime];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _refreshHeaderLoading;
}

#pragma mark textFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    _textField.text = @"";
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        return NO;
    }
    _tableView.hidden = NO;
    if (type == utility_phoneNumberType) {
        [_dataArr removeAllObjects];
        [self searchPhoneNumberAttribution];
        
    }
    else if (type == utility_deviceRecordType)
    {
        [_deviceDataArr removeAllObjects];
        [self searchDeviceRepairInformation];
        
    }
    [_textField resignFirstResponder];
    return YES;
}

#pragma mark tableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    SearchInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[SearchInformationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        if (type == utility_phoneNumberType && _dataArr.count>indexPath.row && _numberNameArr.count >indexPath.row) {
            [ cell setForeText:[_numberNameArr objectAtIndex:indexPath.row] AndBackText:[_dataArr objectAtIndex:indexPath.row] AndIsTitleCell:NO];
        }
        else if (type == utility_deviceRecordType && _deviceDataArr.count>indexPath.row &&_deviceNameArr.count >indexPath.row)
        {
            [ cell setForeText:[_deviceNameArr objectAtIndex:indexPath.row] AndBackText:[_deviceDataArr objectAtIndex:indexPath.row ] AndIsTitleCell:(indexPath.row == 0||indexPath.row == 4)?YES:NO];
        }
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (type == utility_phoneNumberType) {
        return _dataArr.count;
    }
    else if (type == utility_deviceRecordType)
    {
        return _deviceDataArr.count;
    }
    else return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43*MainScreen_Width/375;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_egoRefreshView egoRefreshScrollViewDidScroll:scrollView];
    
}




-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_egoRefreshView egoRefreshScrollViewDidEndDragging:scrollView];

}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y<-(_tableView.contentInset.top+65) && !self->_refreshHeaderLoading) {
        *targetContentOffset = scrollView.contentOffset;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

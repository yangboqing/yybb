//
//  AdvisePageView.m
//  browser
//
//  Created by 王 毅 on 13-4-12.
//
//

#import "AdvisePageView.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "CJSONDeserializer.h"
#import "FileUtil.h"
#import "stdio.h"
#import "JSONKit.h"

#define  MAX_LENGTH 150

//监听键盘的宏定义

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

#define TEXTVIEW_DEFAULT_STRING @"您可以在此输入任何问题或意见,应用宝贝会努力做得更好! (限于150字内)"
#define TEXTFILED_DEFAULT_STRING @"邮箱/QQ/手机"

#define EMPTY_TEXT_COLOR [UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:179.0/255.0 alpha:1.0];
#define VALID_TEXT_COLOR [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
// for iPad
#define LABEL_TEXT_COLOR [UIColor colorWithRed:68.0/255.0 green:68.0/255.0 blue:68.0/255.0 alpha:1.0];



@implementation AdvisePageView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        
        uploadTextDic = [[NSMutableDictionary alloc]init];
        
        isSucceed = NO;
        firstEnable = YES;
        isCanClickUpdataButton = YES;

        UIImage *img;
        
        //除顶部以外的部分为scroll子视图
        scrollView = [[UIScrollView alloc]init];
        scrollView.userInteractionEnabled = YES;
        scrollView.backgroundColor = WHITE_BACKGROUND_COLOR;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        bgImgView = [[UIImageView alloc]init];
        bgImgView.userInteractionEnabled = YES;
        [scrollView addSubview:bgImgView];
        
        //textview的背景图
        textViewBGImageView = [[UIImageView alloc]init];
        textViewBGImageView.backgroundColor = [UIColor clearColor];
        textViewBGImageView.userInteractionEnabled = YES;
        [bgImgView addSubview:textViewBGImageView];
        
        //问题反馈正文的textview
        UITextView *contentTextView = [[UITextView alloc]init];
        contentTextView.text = [NSString stringWithFormat:TEXTVIEW_DEFAULT_STRING];
        contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        contentTextView.textColor = EMPTY_TEXT_COLOR;
        contentTextView.delegate = self;
        contentTextView.backgroundColor = [UIColor clearColor];
        contentTextView.returnKeyType = UIReturnKeyDone;
        contentTextView.keyboardType = UIKeyboardTypeDefault;
        contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        contentTextView.scrollEnabled = YES;
        [textViewBGImageView addSubview:contentTextView];
        self.contentTextView = contentTextView;
        
        numericlabel = [[UILabel alloc] init];
        numericlabel.textAlignment = NSTextAlignmentRight;
        numericlabel.backgroundColor = [UIColor clearColor];
        numericlabel.text = @"0/150";
        numericlabel.textColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
        [bgImgView addSubview:numericlabel];
        
        //textfield背景图
        textFieldBGImageView = [[UIImageView alloc]init];
        textFieldBGImageView.backgroundColor = [UIColor clearColor];
        textFieldBGImageView.userInteractionEnabled = YES;
        [bgImgView addSubview:textFieldBGImageView];
        
        //反馈者联系方式的textfield
        mobileTextField = [[UITextField alloc]init];
        mobileTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        mobileTextField.backgroundColor = [UIColor clearColor];
        mobileTextField.delegate = self;
        mobileTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        mobileTextField.text = [NSString stringWithFormat:TEXTFILED_DEFAULT_STRING];
        mobileTextField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        mobileTextField.textColor = EMPTY_TEXT_COLOR;
        mobileTextField.keyboardType = UIKeyboardTypeDefault;
        mobileTextField.returnKeyType = UIReturnKeyDone;
        mobileTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;

        [textFieldBGImageView addSubview:mobileTextField];

        //提交等待界面的背景
        uploadImageView = [[UIImageView alloc]init];
        SET_IMAGE(uploadImageView.image, @"feedback_commit_BG.png");
        uploadImageView.userInteractionEnabled = NO;
        uploadImageView.hidden = YES;
        
        //提交等待界面的笑脸图
        uploadSubImageView = [[UIImageView alloc]init];
        uploadSubImageView.userInteractionEnabled = YES;
        uploadSubImageView.hidden = YES;
        
        //提交等待界面的文字
        uploadLabel = [[UILabel alloc]init];
        uploadLabel.backgroundColor = [UIColor clearColor];
        uploadLabel.text = [NSString stringWithFormat:@"正在提交,请稍候"];
        uploadLabel.textColor = [UIColor whiteColor];
        uploadLabel.textAlignment = NSTextAlignmentCenter;
        
        activityIndicator = [[UIActivityIndicatorView alloc]init];
        activityIndicator.hidesWhenStopped = YES;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        activityIndicator.hidden = YES;

        [self addSubview:uploadImageView];
        [self addSubview:uploadSubImageView];
        [uploadImageView addSubview:uploadLabel];
        [uploadImageView addSubview:activityIndicator];
        //
        contentTextView.font = [UIFont systemFontOfSize:15.0f];
        numericlabel.font = [UIFont systemFontOfSize:17.0f];
        mobileTextField.font = [UIFont systemFontOfSize:15.0f];
        uploadLabel.font = [UIFont systemFontOfSize:16.0f];

        [LocalImageManager setImageName:@"FeedbackTextBox.png" complete:^(UIImage *image) {
            textViewBGImageView.image = [image stretchableImageWithLeftCapWidth:50 topCapHeight:50];
        }];
        [LocalImageManager setImageName:@"feedback_connect_iphone.png" complete:^(UIImage *image) {
            textFieldBGImageView.image = [image stretchableImageWithLeftCapWidth:50 topCapHeight:5];
        }];
        SET_IMAGE(uploadSubImageView.image, @"feedback_succeed.png")
        
    }
    return self;
}

- (void)layoutSubviews{
    if (firstEnable==YES) {
        scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 41);
        firstEnable = NO;
    }
    scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    bgImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 41);
    textViewBGImageView.frame = CGRectMake(15, 19 + 9, self.frame.size.width - 30, 170);
    self.contentTextView.frame = CGRectMake(2, 0, textViewBGImageView.frame.size.width - 4, textViewBGImageView.frame.size.height);
    numericlabel.frame = CGRectMake(152, textViewBGImageView.frame.origin.y+textViewBGImageView.frame.size.height+2, textViewBGImageView.frame.size.width-150, 30);
    
    textFieldBGImageView.frame = CGRectMake(textViewBGImageView.frame.origin.x, textViewBGImageView.frame.origin.y+textViewBGImageView.frame.size.height+52, textViewBGImageView.frame.size.width, 35);
    
    mobileTextField.frame = CGRectMake(6, 0, textViewBGImageView.frame.size.width-12, textFieldBGImageView.frame.size.height);
    
    uploadImageView.frame  = CGRectMake(0, 0, 190, 120);
    uploadImageView.center = self.center;
    
    uploadSubImageView.frame = CGRectMake(0, 0, 190, 120);
    uploadSubImageView.center = self.center;
    uploadLabel.frame = CGRectMake(0, 74, uploadImageView.frame.size.width, 30);
    
    activityIndicator.frame = uploadImageView.frame;
    activityIndicator.center = CGPointMake(uploadImageView.frame.size.width/2, uploadImageView.frame.size.height/2 - 20);
    
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.contentTextView resignFirstResponder];
    if ([textField.text isEqualToString:TEXTFILED_DEFAULT_STRING]) {
        textField.text = @"";
    }

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""] || textField.text.length == 1){//|| ![textField.text isEqualToString:[TEXTFILED_DEFAULT_STRING ]]) {
        mobileTextField.textColor = EMPTY_TEXT_COLOR;
        mobileTextField.text = TEXTFILED_DEFAULT_STRING;
    }else{
        [uploadTextDic setObject:textField.text forKey:TEXTFIELD_TEXT];
        mobileTextField.textColor = VALID_TEXT_COLOR;
    }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    if (textField.text.length > MAX_LENGTH) {
        textField.text = [textField.text substringToIndex:MAX_LENGTH];
    }
    textField.textColor = VALID_TEXT_COLOR;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chanelFocus)]) {
        [self.delegate chanelFocus];
    }
    
    return YES;
}

#pragma mark -
#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [mobileTextField resignFirstResponder];
    if ([textView.text isEqualToString:TEXTVIEW_DEFAULT_STRING]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""] || textView.text.length == 1) {
        self.contentTextView.textColor = EMPTY_TEXT_COLOR;
        self.contentTextView.text = TEXTVIEW_DEFAULT_STRING;
        numericlabel.text = @"0/150";
    }else{
        [uploadTextDic setObject:textView.text forKey:TEXTVIEW_TEXT];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    textView.textColor = VALID_TEXT_COLOR;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *text = textView.text;
    if (text.length > MAX_LENGTH) {
        NSString *string = [text substringToIndex:MAX_LENGTH];
        [textView endEditing:NO];
        textView.text = string;
        [textView becomeFirstResponder];
    }
    numericlabel.text = [NSString stringWithFormat:@"%i/150",textView.text.length];
}

#pragma mark - Utility

- (void)uploadAdvise:(UIButton *)sender{
    // 提交按钮事件
    if ([_contentTextView.text isEqualToString:@""] || [mobileTextField.text isEqualToString:@""] ||[_contentTextView.text isEqualToString:TEXTVIEW_DEFAULT_STRING] || [mobileTextField.text isEqualToString:TEXTFILED_DEFAULT_STRING]){
        uploadImageView.hidden = YES;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您有资料未填写,请填写完整后继续再次提交,谢谢您的支持"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil,nil];
        [alertView show];
    }else{
        
        uploadImageView.hidden = YES;
        NSString * netType = [[FileUtil instance] GetCurrntNet];        
        if (![netType isEqualToString:@"3g"] && ![netType isEqualToString:@"wifi"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有连接到网络，请检查网络后再次提交"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:nil,nil];
            [alertView show];
            isSucceed = NO;
            self.contentTextView.text = [uploadTextDic objectForKey:TEXTVIEW_TEXT];
            mobileTextField.text = [uploadTextDic objectForKey:TEXTFIELD_TEXT];

        }else{
            
            
            if (isCanClickUpdataButton == NO) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"多谢您的付出,请于1分钟后再反馈问题"
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:@"好的"
                                                          otherButtonTitles:nil,nil];
                [alertView show];
                return;
            }
            
            [self adviseReturnView:0];
            [self request_advise_iPhone];
            
            isSucceed = YES;

//            NSLog(@"提交成功");
            
            isCanClickUpdataButton = NO;
            [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(canUpdataAgain:) userInfo:nil repeats:NO];

        }

    }
    
}


- (void)request_advise_iPhone {
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:ADVISE_PAGE_REPORT_URL];
    [request setPostValue:[[FileUtil instance] getDeviceFileUdid] forKey:@"udid"];
    [request setPostValue:[[FileUtil instance] getDeviceIDFA] forKey:@"devidfa"];
    [request setPostValue:[[FileUtil instance] macaddress] forKey:@"devmac"];
    [request setPostValue:_contentTextView.text forKey:@"content"];
    [request setPostValue:mobileTextField.text forKey:@"contact"];
    [request setTimeOutSeconds:5];
    
    [request setDelegate:self];
    __weak ASIFormDataRequest *requestSelf = request;
    [request setCompletionBlock:^{
        
        NSString *responseString = [requestSelf responseString];
        NSDictionary * map = [self analysisJSON:responseString];
        if( !IS_NSDICTIONARY(map) ) {
            //数据格式错误
            isSucceed = NO;
            [self adviseReturnView:2];
            return ;
        }
        
        NSString *isSucc = [map objectForKey:@"flag"];//@"succ" or @"fail"
        if ([isSucc isEqualToString:@"succ"]) {
            isSucceed = YES;
            [self adviseReturnView:1];
//            NSLog(@"反馈成功");
        }else{
            isSucceed = NO;
            [self adviseReturnView:2];
//            NSLog(@"反馈失败");
        }

    }];
    
    [request setFailedBlock:^{
        isSucceed = NO;
        [self adviseReturnView:2];
//        NSLog(@"反馈失败");
       
    }];
    
    [request startAsynchronous];
    
}
-(NSDictionary *)analysisJSON:(NSString *)jsonStr{
    NSError *error;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *root = [[CJSONDeserializer deserializer] deserialize:jsonData error:&error];
    if(!IS_NSDICTIONARY(root))
        return nil;
    
    return root;
}

- (void)canUpdataAgain:(NSTimer *)timer{
    isCanClickUpdataButton = YES;
}

- (void)resignAllResponder{
    [self.contentTextView resignFirstResponder];
    [mobileTextField resignFirstResponder];
}

//0:提交中 1:成功 2:失败
- (void)adviseReturnView:(int)index{
    uploadImageView.hidden = NO;
    switch (index) {
        case 0:
            
            uploadSubImageView.hidden = YES;
            activityIndicator.hidden = NO;
            [activityIndicator startAnimating];
            uploadLabel.text = [NSString stringWithFormat:@"正在提交,请稍候"];
            break;
        case 1:{
            scrollView.hidden = YES;
            
            activityIndicator.hidden = YES;
            [activityIndicator stopAnimating];
            uploadImageView.hidden  = YES;
            uploadSubImageView.hidden = NO;
//            uploadSubImageView.image = LOADIMAGE(@"feedback_succeed", @"png");
            SET_IMAGE(uploadSubImageView.image, @"feedback_succeed.png");
            
            self.contentTextView.textColor = EMPTY_TEXT_COLOR;
            mobileTextField.textColor = EMPTY_TEXT_COLOR;
            self.contentTextView.text = TEXTVIEW_DEFAULT_STRING;
            mobileTextField.text = TEXTFILED_DEFAULT_STRING;
            numericlabel.text = @"0/150";
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(closeUploadView:) userInfo:nil repeats:NO];
        }
            break;
        case 2:{
            [self commitFail];
            
            scrollView.hidden = YES;
            
            activityIndicator.hidden = YES;
            [activityIndicator stopAnimating];
            uploadImageView.hidden = YES;
            uploadSubImageView.hidden = NO;
            SET_IMAGE(uploadSubImageView.image, @"feedback_fail_iphone.png");
            self.contentTextView.textColor = EMPTY_TEXT_COLOR;
            mobileTextField.textColor = EMPTY_TEXT_COLOR;
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(closeUploadView:) userInfo:nil repeats:NO];
        }
            break;
        default:
            break;
    }
    
}

- (void)commitFail{
    UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@"提交不成功，请重试"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"好的"
                                           otherButtonTitles:nil,nil];
    [alView show];
}

- (void)closeUploadView:(NSTimer *)timer{
    uploadImageView.hidden = YES;
    uploadSubImageView.hidden = YES;
    scrollView.hidden = NO;
}

- (void)dealloc{
    uploadTextDic = nil;
}

@end

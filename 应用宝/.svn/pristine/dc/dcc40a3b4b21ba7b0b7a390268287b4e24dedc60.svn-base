//
//  SearchZoomView.m
//  browser
//
//  Created by 王毅 on 13-11-21.
//
//

#import "SearchZoomView.h"

#define BACKBTNSPACE 37
#define searchBarFrameY 5
#define width_searchBar 464/2*(MainScreen_Width/320)

@implementation SearchZoomView
@synthesize searchBar = _searchBar;
@synthesize searchButton = _searchButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (IOS7) {
            self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
            [self setClipsToBounds:YES];
            toolbar = [[UIToolbar alloc] initWithFrame:[self bounds]];
            //2.7
//            [toolbar setBarTintColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
           
            
//            [self.layer insertSublayer:[toolbar layer] atIndex:0];
        }else
        {
            self.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
        }
        
        self.searchBar = [[WYTextFieldEx alloc]init];
        self.searchBar.layer.cornerRadius = 5;
        self.searchBar.delegate = self;
        self.searchBar.borderStyle = UITextBorderStyleNone;
        self.searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
        if (IOS7) {
            self.searchBar.tintColor = [UIColor blueColor];
        }
        self.searchBar.placeholder = PLACEHOLDER;
        self.searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.searchBar.font = [UIFont systemFontOfSize:15];
        self.searchBar.textColor = [UIColor blackColor];
        //self.searchBar.keyboardType = UIKeyboardTypeURL;
        self.searchBar.returnKeyType = UIReturnKeySearch;
        self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        self.searchBar.backgroundColor = [UIColor whiteColor];
        
        self.searchBar.layer.borderWidth= 1.0f;
        self.searchBar.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.searchBar addTarget:self action:@selector(showAssociate:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:self.searchBar];
        
        
//        UIImage *img = [UIImage imageNamed:@"search_glass.png"];
        searchGlassImageView = [[UIImageView alloc] init];
        SET_IMAGE(searchGlassImageView.image, @"search_glass.png");
        [self.searchBar addSubview:searchGlassImageView];

        
        
        self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.searchButton.titleLabel.font = [UIFont systemFontOfSize:15];
        //2.7
        [self.searchButton setTitleColor:[UIColor colorWithRed:32.0/225.0 green:32.0/225.0 blue:32.0/225.0 alpha:1.0] forState:UIControlStateNormal];
        //新春版
//        [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.searchButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        [self.searchButton setTitle:@"取消" forState:UIControlStateNormal];
        self.searchButton.hidden = YES;
        [self addSubview:self.searchButton];
        
        cuttingLineView = [[UIImageView alloc] init];
        cuttingLineView.backgroundColor = [UIColor redColor];
        [self addSubview:cuttingLineView];

        
    }
    return self;
}

- (void)clickAction
{
    self.searchBar.placeholder = PLACEHOLDER;
    [self removeFirstRespone];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancleSearching:)]) {
        [self.delegate cancleSearching:nil];
    }
}

- (void)showAssociate:(id)sender
{
//    //点击联想判断    ----    去掉会崩溃
//    if ([self.searchBar.text length] > 30) {
//        self.searchBar.text = [self.searchBar.text substringToIndex:30]; //总内容超过限制字数30，则截取前30个字符
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"超过最大字数30不能输入了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
    
    if ([self.searchBar.text length]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showAssociate:)]) {
            [self.delegate showAssociate:self.searchBar.text];
        }
    }else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showSearchHistory:)]) {
            [self.delegate showSearchHistory:nil];
        }
        
    }
    
}

- (void)isSearchFrame:(BOOL)isSearchStaute andIsResulePage:(BOOL)resultPage{
    
    CGFloat TMPFL = 0;//IOS7 ? 20 : 0;
    
    isSearch = isSearchStaute;
    isResultPage = resultPage;
    
    if (isSearchStaute == YES) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            if (resultPage) {
                self.searchBar.frame = CGRectMake(26/2 + BACKBTNSPACE, searchBarFrameY+TMPFL, width_searchBar - BACKBTNSPACE, 60/2);
            }else
            {
                self.searchBar.frame = CGRectMake(26/2, searchBarFrameY+TMPFL, width_searchBar, 60/2);
            }
            
            self.searchButton.hidden = NO;
            searchGlassImageView.hidden = YES;
            
        } completion:^(BOOL isFinish){
            
        }];
        
        
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            
            if (resultPage) {
                self.searchBar.frame = CGRectMake(26/2 + BACKBTNSPACE, searchBarFrameY+TMPFL, self.frame.size.width - 26 - BACKBTNSPACE, 60/2);
            }else
            {
                self.searchBar.frame = CGRectMake(26/2, searchBarFrameY+TMPFL, self.frame.size.width - 26, 60/2);
            }
            
            self.searchButton.hidden = YES;
            self.searchBar.placeholder = PLACEHOLDER;
            
            if ([self.searchBar.text length]) {
                searchGlassImageView.hidden = YES;
            }else
            {
                searchGlassImageView.hidden = NO;
            }
            
        } completion:^(BOOL isFinish){
            
        }];
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [toolbar setFrame:[self bounds]];
    
    CGFloat TMPFL = 0;//IOS7 ? 20 : 0;
    
    if (!isSearch) {
        if (isResultPage) {
            self.searchBar.frame = CGRectMake(26/2 + BACKBTNSPACE, searchBarFrameY+TMPFL, self.frame.size.width - 26 - BACKBTNSPACE, 60/2);
        }else
        {
            self.searchBar.frame = CGRectMake(26/2, searchBarFrameY+TMPFL, self.frame.size.width - 26, 60/2);
        }
        
    }else
    {
        if (isResultPage) {
            self.searchBar.frame = CGRectMake(26/2 + BACKBTNSPACE, searchBarFrameY+TMPFL, width_searchBar - BACKBTNSPACE, 60/2);
        }else
        {
            self.searchBar.frame = CGRectMake(26/2, searchBarFrameY+TMPFL, width_searchBar, 60/2);
        }
        
    }
    
    searchGlassImageView.frame = CGRectMake(0, (60/2-42/2)/2, 42/2, 42/2);
    
    self.searchButton.frame = CGRectMake(26/2 + width_searchBar + 18/2, searchBarFrameY+TMPFL, 104/2, 56/2);
    
//    cuttingLineView.frame = CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
}

- (void)removeFirstRespone{
    [self.searchBar resignFirstResponder];
    [self isSearchFrame:NO andIsResulePage:isResultPage];
}

#pragma mark -
#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.searchBar.placeholder = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSearchHistory:)]) {
        [self.delegate showSearchHistory:nil];
    }

    [self isSearchFrame:YES andIsResulePage:isResultPage];
    
    if ([textField.text isEqualToString:PLACEHOLDER]) {
        textField.text = @"";
    }
    if ([textField.text length]) {
        [self showAssociate:textField.text];
    }
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //会崩溃
    NSString * toBeString = [textField.text stringByAppendingString:string];
    
    if ([toBeString length] > 30) {
        textField.text = [toBeString substringToIndex:30]; //总内容超过限制字数30，则截取前30个字符
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"超过最大字数30不能输入了" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    textField.text = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showSearchHistory:)]) {
        [self.delegate showSearchHistory:nil];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if ([textField.text length]) {
        [textField resignFirstResponder];
        
//        [UIView animateWithDuration:0.1 animations:^{
//            [self isSearchFrame:NO andIsResulePage:YES];
//        } completion:^(BOOL isFinish){
//            
//        }];
        
        //去掉动画
        [self isSearchFrame:NO andIsResulePage:YES];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(beginSearching:)]) {
            [self.delegate beginSearching:textField.text];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入搜索内容"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,nil];
        [alertView show];
    }
    
    
    return YES;
}


- (void)dealloc{
    
}

@end
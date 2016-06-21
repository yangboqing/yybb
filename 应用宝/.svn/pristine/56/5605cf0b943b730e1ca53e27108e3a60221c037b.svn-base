//
//  SettingTableViewCell_iphone.m
//  browser
//
//  Created by 王 毅 on 13-4-9.
//
//

#import "SwitchTableViewCell_iphone.h"

@implementation SwitchTableViewCell_iphone

@synthesize settingSwitch = _settingSwitch;
@synthesize cellLabel;
@synthesize myLabel = _myLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cellLabel = [[UILabel alloc]init];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:cellLabel];
        
        UISwitch *tempSwitch = [[UISwitch alloc]init];
        self.settingSwitch = tempSwitch;
        
        self.settingSwitch.on = YES;
        [self addSubview:self.settingSwitch];
        
        
        UILabel *tempLabel = [[UILabel alloc] init];
        self.myLabel = tempLabel;
        
        self.myLabel.backgroundColor = [UIColor clearColor];
        self.myLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.myLabel];
        
    }
    return self;
}

- (void)layoutSubviews{

    cellLabel.frame = CGRectMake(18,(self.frame.size.height - 18)/2, 210, 18);

        if (INT_SYSTEMVERSION >= 7) {
            self.settingSwitch.frame = CGRectMake(self.frame.size.width  - 77  , (self.frame.size.height - 27)/2, 77, 27);
        } else {
            self.settingSwitch.frame = CGRectMake(self.frame.size.width  - 77 - 22, (self.frame.size.height - 27)/2, 77, 27);
        }

    

}
- (void)setAllFrame{
    cellLabel.frame = CGRectMake(18,(self.frame.size.height - 18)/2, 180, 18);

        if (INT_SYSTEMVERSION >= 7) {
            self.settingSwitch.frame = CGRectMake(self.frame.size.width  - 77  , (self.frame.size.height - 27)/2, 77, 27);
        } else {
            self.settingSwitch.frame = CGRectMake(self.frame.size.width  - 77 - 22, (self.frame.size.height - 27)/2, 77, 27);
        }


}

- (void)cellLabelText:(NSString *)labelText{
    NSString *str = nil;
    if (labelText != nil && ![labelText isEqualToString:@""]) {
        str = labelText;
    }
    cellLabel.text = [NSString stringWithFormat:@"%@",str];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    // 自定义的UITableViewCell释放.. 经常会引起崩溃
    cellLabel = nil;
    _settingSwitch = nil;
    _myLabel = nil;
}

@end

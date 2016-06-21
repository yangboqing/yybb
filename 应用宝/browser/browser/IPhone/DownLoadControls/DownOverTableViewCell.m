//
//  DownOverTableViewCell.m
//  browser
//
//  Created by 王 毅 on 13-1-7.
//
//

#import "DownOverTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CollectionCells.h"

#define EDITOFFSET 40

@interface DownOverTableViewCell (){
    UIImageView *bottomLineImageView;
    NSString * versionStr;
}

@end

@implementation DownOverTableViewCell
@synthesize installBtn = _installBtn;
@synthesize idenStr = _idenStr;
@synthesize appID = _appID;
@synthesize m_checked;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        defaultImg =  _StaticImage.icon_60x60;
        
        cellBGimageView = [[UIImageView alloc]init];
        cellBGimageView.userInteractionEnabled = YES;
        SET_IMAGE(cellBGimageView.image, @"cell_bg_notline.png");
        [self addSubview:cellBGimageView];
        
        bottomLineImageView = [[UIImageView alloc]init];
        bottomLineImageView.backgroundColor = SEPERATE_LINE_COLOR;
        [self addSubview:bottomLineImageView];
        
        //
        iconImageView = [[UIImageView alloc]init];
        
        iconImageView.image = defaultImg;
        iconImageView.layer.borderWidth = 0.5;
        iconImageView.layer.borderColor = hllColor(50, 50, 50, 0.2).CGColor;
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        nameLabel.text = [NSString stringWithFormat:@""];
        self.nameLabel = nameLabel;
        
        infoLabel = [[UILabel alloc]init];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = GRAY_TEXT_COLOR;
        infoLabel.font = [UIFont systemFontOfSize:11.0f];
        infoLabel.text = [NSString stringWithFormat:@""];
        
        self.installBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.installBtn.tag = (NSUInteger)self; //button-->cell
        self.installBtn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        [self.installBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.installBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self.installBtn setBackgroundImage:[UIImage imageNamed:@"kong.png"] forState:UIControlStateNormal];
        [self.installBtn setBackgroundImage:[UIImage imageNamed:@"downselectbtn.png"] forState:UIControlStateHighlighted];
        
        
        
        self.idenStr = @"";
        self.appID = @"";
        versionStr = @"";
        
        [cellBGimageView addSubview:iconImageView];
        [cellBGimageView addSubview:_nameLabel];
        [cellBGimageView addSubview:infoLabel];
        [cellBGimageView addSubview:_installBtn];
    }
    
    return self;
}

#pragma mark - 外露接口

- (void)downOverCellIconImage:(UIImage *)img{
    iconImageView.image = (img)?img:defaultImg;
}

- (void)downOverCellName:(NSString *)nameStr{
    
    if (nameStr != nil && ![nameStr isEqualToString:@""]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",nameStr];
    }
}

//详细参数版本和容量
- (void)downOverCellVersion:(NSString *)str volume:(NSUInteger)volume{
    CGFloat vol = (CGFloat)volume/1024.0/1024.0;
    versionStr = str;
    infoLabel.text = [NSString stringWithFormat:@"版本%@ | %.2fM",str,vol];
}

- (void)setIphoneButtonImage:(UIImage *)img{
//    [self.installBtn setImage:img forState:UIControlStateNormal];
    [self.installBtn setTitle:@"安装" forState:UIControlStateNormal];

}

- (NSString *)getCellVersion{
    return versionStr;
}

#pragma mark - 自定义多选
- (void) setCheckImageViewCenter:(CGPoint)pt alpha:(CGFloat)alpha animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		
        if (alpha) {
            cellBGimageView.center = CGPointMake(self.center.x+EDITOFFSET, cellBGimageView.center.y);
        }else
        {
            cellBGimageView.center = CGPointMake(self.center.x, cellBGimageView.center.y);
        }
        
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
		
		[UIView commitAnimations];
	}
	else
	{
		m_checkImageView.center = pt;
		m_checkImageView.alpha = alpha;
	}
}

- (void) setEditing:(BOOL)editting animated:(BOOL)animated
{
    if (IOS7) {
        self.installBtn.enabled = !editting;
        self.installBtn.userInteractionEnabled = !editting;
        if (editting) {
            self.installBtn.titleLabel.alpha = 0.5;
        }else
        {
            self.installBtn.titleLabel.alpha = 1;
        }
    }else
    {
        self.installBtn.hidden = editting;
    }
    
    if (self.editingStyle == UITableViewCellEditingStyleDelete) {
        if (!IOS7) {
            [super setEditing:editting animated:animated];
        }
        return;
    }
    
	if (self.editing == editting)
	{
		return;
	}
    
	[super setEditing:editting animated:animated];
	
	if (editting)
	{
		self.backgroundView = [[UIView alloc] init];
		self.backgroundView.backgroundColor = [UIColor whiteColor];
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		
		if (m_checkImageView == nil)
		{
			m_checkImageView = [[UIImageView alloc] init];
            SET_IMAGE(m_checkImageView.image, @"Unselected.png");
            m_checkImageView.frame = CGRectMake(0, 0, 22, 22);
			[self addSubview:m_checkImageView];
		}
		
		[self setChecked:m_checked];
		m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
											  CGRectGetHeight(self.bounds) * 0.5);
		m_checkImageView.alpha = 0.0;
		[self setCheckImageViewCenter:CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5)
								alpha:1.0 animated:animated];
	}
	else
	{
		m_checked = NO;
		self.backgroundView = nil;
		
		if (m_checkImageView)
		{
			[self setCheckImageViewCenter:CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
													  CGRectGetHeight(self.bounds) * 0.5)
									alpha:0.0
								 animated:animated];
		}
	}
}

- (void) setChecked:(BOOL)checked
{
	if (checked)
	{
//		m_checkImageView.image = [UIImage imageNamed:@"Selected.png"];
        SET_IMAGE(m_checkImageView.image, @"Selected.png");
	}
	else
	{
//		m_checkImageView.image = [UIImage imageNamed:@"Unselected.png"];
        SET_IMAGE(m_checkImageView.image, @"Unselected.png");
	}
	m_checked = checked;
    self.backgroundView.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1];
}

#pragma mark - Utility

- (void)layoutSubviews{
    
    if (!IOS7) {
        [super layoutSubviews];
    }
    
    cellBGimageView.frame = self.bounds;
    
    if (self.editingStyle != UITableViewCellEditingStyleDelete) {
        if (self.editing) {
            m_checkImageView.center = CGPointMake(20.5, CGRectGetHeight(self.bounds) * 0.5);
            cellBGimageView.center = CGPointMake(self.center.x+EDITOFFSET, cellBGimageView.center.y);
            
        }else
        {
            m_checkImageView.center = CGPointMake(-CGRectGetWidth(m_checkImageView.frame) * 0.5,
                                                  CGRectGetHeight(self.bounds) * 0.5);
            cellBGimageView.center = CGPointMake(self.center.x, cellBGimageView.center.y);
        }
    }
    
    iconImageView.frame =CGRectMake(13*MULTIPLE, 13*MULTIPLE, 52*MULTIPLE, 52*MULTIPLE);
    iconImageView.layer.cornerRadius = 11;
    iconImageView.layer.masksToBounds = YES;
    
    self.nameLabel.frame = CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + 15, 16, 121*(MainScreen_Width/320), 15);
    if (IOS7) {
        self.nameLabel.frame = CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + 15, 16, (121+52)*(MainScreen_Width/320), 15);
    }
    infoLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 13, 121, 11);
//    self.installBtn.frame = CGRectMake(self.frame.size.width - 45, 0, 45, 70);
    self.installBtn.frame=  CGRectMake(self.frame.size.width - 64*MULTIPLE, 26*MULTIPLE, 53*MULTIPLE, 28*MULTIPLE);
    bottomLineImageView.frame = CGRectMake(8, self.bounds.size.height - 0.5, self.bounds.size.width - 8, 0.5);
}

- (void)dealloc{
    self.idenStr = nil;
    self.appID = nil;
    
    self.nameLabel = nil;
	m_checkImageView = nil;
}

@end

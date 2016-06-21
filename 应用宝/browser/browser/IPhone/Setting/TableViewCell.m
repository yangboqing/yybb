//
//  TableViewCell.m
//  browser
//
//  Created by admin on 13-9-18.
//
//

#import "TableViewCell.h"

@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected)
    {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    // Configure the view for the selected state
}

@end

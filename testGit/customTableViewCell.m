//
//  customTableViewCell.m
//  PlanIt!
//
//  Created by Alex Bechmann on 22/06/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "customTableViewCell.h"

@implementation customTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    frame.origin.x += 50;
    frame.size.width -= 2 * 50;
    [super setFrame:frame];
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  NavigationBarTitleWithSubtitleView.m
//  testGit
//
//  Created by Alex Bechmann on 04/05/14.
//  Copyright (c) 2014 Alex Bechmann. All rights reserved.
//

#import "NavigationBarTitleWithSubtitleView.h"

@interface NavigationBarTitleWithSubtitleView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation NavigationBarTitleWithSubtitleView

@synthesize titleLabel;
@synthesize detailLabel;

- (id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, 153, 50)];
    if (self) {
        [self setBackgroundColor: [UIColor clearColor]];
        [self setAutoresizesSubviews:YES];
        
        //CGRect titleFrame = CGRectMake(0, 2, 200, 24);
        CGRect titleFrame = CGRectMake(0, 2, 160, 30);
        titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        //titleLabel.textColor = [UIColor whiteColor];
       // titleLabel.shadowColor = [UIColor darkGrayColor];
        //titleLabel.shadowOffset = CGSizeMake(0, -1);
        titleLabel.text = @"";
        titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:titleLabel];
        
        CGRect detailFrame = CGRectMake(0, 24, 160, 44-24);
        detailLabel = [[UILabel alloc] initWithFrame:detailFrame];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:11];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        //detailLabel.textColor = [UIColor whiteColor];
        //detailLabel.shadowColor = [UIColor darkGrayColor];
        //detailLabel.shadowOffset = CGSizeMake(0, -1);
        detailLabel.text = @"";
        detailLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:detailLabel];
        
        [self setAutoresizingMask : (UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleBottomMargin)];
    }
    return self;
}

- (void) setTitleText: (NSString *) aTitleText
{
    [self.titleLabel setText:aTitleText];
}

- (void) setDetailText: (NSString *) aDetailText
{  
    [self.detailLabel setText:aDetailText];  
}  

@end
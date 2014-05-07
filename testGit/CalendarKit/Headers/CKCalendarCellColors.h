//
//  CKCalendarCalendarCellColors.h
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

/*
 
 Defines standard colors for MBCalendarCalendarView. These were grabbed using the
 color picker in Photoshop CS6 on OS X. There's a gradient across the calendar,
 from the top down, so the colors change slightly by row.
 
 Selected Blue: #1980e5
 Normal Gray (Top Row): #e2e2e4
 Normal Gray (Bottom Row): #cccbd0
 
 Text Gradient Top Color: #2b3540
 Text Gradient Bottom Color: #495a6d
 
 */


#ifndef MBCalendarKit_CKCalendarCalendarCellColors_h
#define MBCalendarKit_CKCalendarCalendarCellColors_h

#import "NSString+Color.h"

#define kCalendarColorBlue [@"#e5534b" toColor]
#define kCalendarColorLightGray [@"#ffffff" toColor] //e2e2e4
#define kCalendarColorDarkGray [@"#ffffff" toColor] //cccbd0

#define kCalendarColorBluishGray [@"#5aa1f8" toColor]
#define kCalendarColorTodayShadowBlue [@"#e4e4e4" toColor]
#define kCalendarColorSelectedShadowBlue [@"#294f75" toColor]

#define kCalendarColorDarkTextGradient [@"#2b3540" toColor]
#define kCalendarColorLightTextGradient [@"#495a6d" toColor]

#define kCalendarColorCellBorder [@"#e4e4e4" toColor]
#define kCalendarColorSelectedCellBorder [@"#e4e4e4" toColor]
//e5534b


//#define kCalendarColorBluishGray [@"#7389a5" toColor]
//#define kCalendarColorTodayShadowBlue [@"#394452" toColor]
//#define kCalendarColorSelectedShadowBlue [@"#294f75" toColor]
//
//#define kCalendarColorDarkTextGradient [@"#2b3540" toColor]
//#define kCalendarColorLightTextGradient [@"#495a6d" toColor]
//
//#define kCalendarColorCellBorder [@"#9da0a9" toColor]
//#define kCalendarColorSelectedCellBorder [@"#293649" toColor]

#endif

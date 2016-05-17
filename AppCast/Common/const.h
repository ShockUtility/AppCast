//
//  common.h
//  AppCast
//
//  Created by iMac5K on 2016. 4. 12..
//  Copyright © 2016년 Shock. All rights reserved.
//

@import StoreKit;
#import <Foundation/Foundation.h>
#import "MyDB.h"
#import "Util.h"

#define THEME_BG                    [UIColor colorWithRed:0.08 green:0.10 blue:0.13 alpha:1.00]
#define THEME_CELL_BG               [UIColor colorWithRed:0.12 green:0.14 blue:0.17 alpha:1.00]
#define THEME_CELL_TITLE            [UIColor colorWithRed:0.10 green:0.76 blue:1.00 alpha:1.00]
#define THEME_CELL_SUBTITLE         [UIColor colorWithRed:0.55 green:0.62 blue:0.73 alpha:1.00]
#define THEME_BUTTON                [UIColor colorWithRed:0.92 green:0.76 blue:0.18 alpha:1.00]

#define MAX_LOADING                 15000

#define TITLE_ARRAY     @[@"New ALL", @"New Free", @"New Paid", @"iPhone Free", @"iPone Paid", @"iPhone Grossing", @"iPad Free", @"iPad Paid", @"iPad Grossing", @"Mac Free", @"Mac Paid", @"Mac Grossing", @"Top Podcasts"]
#define CHART_ARRAY     @[@"newapplications", @"newfreeapplications", @"newpaidapplications", @"topfreeapplications", @"toppaidapplications", @"topgrossingapplications", @"topfreeipadapplications", @"toppaidipadapplications", @"topgrossingipadapplications", @"topfreemacapps", @"toppaidmacapps", @"topgrossingmacapps", @"toppodcasts"]

typedef NS_ENUM(NSInteger, TDetailType) {
    dtNEW_ALL,
    dtNEW_FREE,
    dtNEW_PAID,
    dtIPHONE_FREE,
    dtIPHONE_PAID,
    dtIPHONE_GROSS,
    dtIPAD_FREE,
    dtIPAD_PAID,
    dtIPAD_GROSS,
    dtMAC_FREE,
    dtMAC_PAID,
    dtMAC_GROSS,
    dtPODCASTS
};
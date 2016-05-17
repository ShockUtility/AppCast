//
//  DetailViewController.h
//  AppCast
//
//  Created by iMac5K on 2016. 4. 13..
//  Copyright © 2016년 Shock. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <JSONHTTPClient.h>
#import <UIImageView+AFNetworking.h>

#import "EntryModel.h"
#import "Option.h"
#import "Util.h"
#import "const.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, SKStoreProductViewControllerDelegate>
{
    NSDictionary *listCountry, *listCategory;
    NSString *chart;
    NSMutableArray *arrEntry;
    Option *option;
    NSInteger selectedRow;
}

@property (assign, nonatomic) TDetailType type;
@property (weak, nonatomic) IBOutlet UITableView *tblEntry;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnLimits;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCategory;
@property (weak, nonatomic) IBOutlet UIButton *btnCountry;
@property (weak, nonatomic) IBOutlet UIView *vwOption;
@property (weak, nonatomic) IBOutlet UIPickerView *pkOption;

@end


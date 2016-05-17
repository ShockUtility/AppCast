//
//  MasterViewController.h
//  AppCast
//
//  Created by iMac5K on 2016. 4. 13..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "FavViewController.h"
#import "MyDB.h"
#import "const.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@end


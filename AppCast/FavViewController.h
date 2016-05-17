//
//  FavViewController.h
//  AppCast
//
//  Created by iMac5K on 2016. 4. 14..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+AFNetworking.h>
#import "const.h"

@interface FavViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, SKStoreProductViewControllerDelegate>
{
    NSIndexPath *selectedIndexPath;
    NSMutableArray *iosFav, *osxFav, *podFav;
}

@property (weak, nonatomic) IBOutlet GADBannerView *vwBanner;
@property (weak, nonatomic) IBOutlet UITableView *tblFavorites;

@end

//
//  MasterViewController.m
//  AppCast
//
//  Created by iMac5K on 2016. 4. 13..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import "MasterViewController.h"

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MyDB sharedDB];
    
    [[UINavigationBar appearance] setBarTintColor:THEME_BUTTON];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: THEME_BG};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    _lblVersion.text = [NSString stringWithFormat:@"%@ (Build %@)",
                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                        [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        [controller setType:((NSNumber *)sender).intValue];
    } else if ([[segue identifier] isEqualToString:@"showFavorites"]) {
        FavViewController *controller = (FavViewController *)[[segue destinationViewController] topViewController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==5) {
        if (indexPath.row==0) [self performSegueWithIdentifier:@"showFavorites" sender:nil];
    } else {
        TDetailType type;
        if      (indexPath.section==0 && indexPath.row==0) type = dtNEW_ALL;
        else if (indexPath.section==0 && indexPath.row==1) type = dtNEW_FREE;
        else if (indexPath.section==0 && indexPath.row==2) type = dtNEW_PAID;
        else if (indexPath.section==1 && indexPath.row==0) type = dtIPHONE_FREE;
        else if (indexPath.section==1 && indexPath.row==1) type = dtIPHONE_PAID;
        else if (indexPath.section==1 && indexPath.row==2) type = dtIPHONE_GROSS;
        else if (indexPath.section==2 && indexPath.row==0) type = dtIPHONE_FREE;
        else if (indexPath.section==2 && indexPath.row==1) type = dtIPAD_PAID;
        else if (indexPath.section==2 && indexPath.row==2) type = dtIPAD_GROSS;
        else if (indexPath.section==3 && indexPath.row==0) type = dtMAC_FREE;
        else if (indexPath.section==3 && indexPath.row==1) type = dtMAC_PAID;
        else if (indexPath.section==3 && indexPath.row==2) type = dtMAC_GROSS;
        else if (indexPath.section==4 && indexPath.row==0) type = dtPODCASTS;
        
        
        [self performSegueWithIdentifier:@"showDetail" sender:[NSNumber numberWithInteger:type]];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
}

@end

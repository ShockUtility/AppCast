//
//  FavViewController.m
//  AppCast
//
//  Created by iMac5K on 2016. 4. 14..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import "FavViewController.h"

@implementation FavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarTintColor:THEME_BUTTON];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: THEME_BG};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    selectedIndexPath = nil;
    iosFav = [MyDB select:@"ios"];
    osxFav = [MyDB select:@"osx"];
    podFav = [MyDB select:@"pod"];
}

- (IBAction)onClickTrash:(id)sender {
    if (selectedIndexPath!=nil) {
        NSDictionary *item;
        [_tblFavorites beginUpdates];
        switch (selectedIndexPath.section) {
            case 0:
                item = [iosFav objectAtIndex:selectedIndexPath.row];
                if ([MyDB delete:[[item objectForKey:@"no"] longValue] table:@"ios"]) {
                    [iosFav removeObjectAtIndex:selectedIndexPath.row];
                    [_tblFavorites deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
            case 1:
                item = [osxFav objectAtIndex:selectedIndexPath.row];
                if ([MyDB delete:[[item objectForKey:@"no"] longValue] table:@"osx"]) {
                    [osxFav removeObjectAtIndex:selectedIndexPath.row];
                    [_tblFavorites deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
            default:
                item = [podFav objectAtIndex:selectedIndexPath.row];
                if ([MyDB delete:[[item objectForKey:@"no"] longValue] table:@"pod"]) {
                    [podFav removeObjectAtIndex:selectedIndexPath.row];
                    [_tblFavorites deleteRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                break;
        }
        [_tblFavorites endUpdates];
        selectedIndexPath = nil;
        [_tblFavorites reloadData];
    }
}

- (IBAction)onClickDownload:(id)sender {
    UIAlertController *loading = loadingAlert(@"Loading...");
    [self presentViewController:loading animated:true completion:^{
        NSDictionary *item = [iosFav objectAtIndex:selectedIndexPath.row];
        SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
        [storeProductViewController setDelegate:self];
        [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : [item objectForKey:@"id"]}
                                              completionBlock:^(BOOL result, NSError *error)
         {
             [loading dismissViewControllerAnimated:YES completion:^{
                 if (error) {
                     NSLog(@"Error %@ with User Info %@.", error, [error userInfo]);
                 } else {
                     [self presentViewController:storeProductViewController animated:YES completion:nil];
                 }
             }];
         }];
    }];
}

- (IBAction)onClickLink:(id)sender {
    NSDictionary *item = [osxFav objectAtIndex:selectedIndexPath.row];
    NSArray *shareAray = @[[item objectForKey:@"name"], [NSURL URLWithString:[item objectForKey:@"link"]]];
    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:shareAray
                                                                                    applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)onClickPod:(id)sender {
    NSDictionary *item = [podFav objectAtIndex:selectedIndexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[item objectForKey:@"link"]]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section==0 ? @"iOS Favorites" : section==1 ? @"OSX Favorites" : @"Podcast Favorites";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor blackColor];
    header.contentView.backgroundColor = [UIColor grayColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return iosFav.count;
    else if (section==1) return osxFav.count;
    return podFav.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section==0) cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    else if (indexPath.section==1) cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
    else cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
    
    UIImageView *image = [cell viewWithTag:1];
    UILabel *title = [cell viewWithTag:2];
    UILabel *artist = [cell viewWithTag:3];
    UILabel *price = [cell viewWithTag:4];
    UITextView *summery = [cell viewWithTag:5];
    
    NSDictionary *fav;
    if (indexPath.section==0) fav = [iosFav objectAtIndex:indexPath.row];
    else if (indexPath.section==1) fav = [osxFav objectAtIndex:indexPath.row];
    else fav = [podFav objectAtIndex:indexPath.row];
    
    image.layer.cornerRadius = 5;
    image.clipsToBounds = true;
    [image setImageWithURL:[NSURL URLWithString:[fav objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"loading"]];

    title.text = [fav objectForKey:@"name"];
    artist.text = [fav objectForKey:@"artist"];
    
    if (indexPath.section<2) {
        NSString *s = [fav objectForKey:@"price"];
        if (s==nil || [s isKindOfClass:[NSNull class]]) {
            price.text = @"";
        } else if ([price.text isEqualToString:@"Free"]) {
            price.text = s;
            price.textColor = [UIColor colorWithRed:0.58 green:0.80 blue:0.42 alpha:1.00];
        } else {
            price.text = s;
            price.textColor = [UIColor colorWithRed:0.81 green:0.18 blue:0.24 alpha:1.00];
        }
    } else {
        price.text = @"";
    }
    
    NSString *s = [fav objectForKey:@"summary"];
    summery.text = (s==nil || [s isKindOfClass:[NSNull class]]) ? @"Empty summary" : s;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedIndexPath = (selectedIndexPath==indexPath) ? nil : indexPath;
    [tableView reloadData];
    
    // 썸머리 스크롤 되었다면 최상위로 스크롤 올린다.
    if (selectedIndexPath!=nil) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITextView *summery = [cell viewWithTag:5];
        [summery scrollRangeToVisible:NSMakeRange(0, 0)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return selectedIndexPath==indexPath ? 163.5 : 51;
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end

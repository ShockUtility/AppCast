//
//  DetailViewController.m
//  AppCast
//
//  Created by iMac5K on 2016. 4. 13..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarTintColor:THEME_BUTTON];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: THEME_BG};
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    NSString *pathContry = [[NSBundle mainBundle] pathForResource:@"country" ofType:@"plist"];
    listCountry = [[NSDictionary alloc] initWithContentsOfFile:pathContry];
    
    NSString *pathCategory;
    if (_type<dtMAC_FREE) pathCategory = [[NSBundle mainBundle] pathForResource:@"ios-category" ofType:@"plist"];
    else if (_type<dtPODCASTS) pathCategory = [[NSBundle mainBundle] pathForResource:@"osx-category" ofType:@"plist"];
    else pathCategory = [[NSBundle mainBundle] pathForResource:@"pod-category" ofType:@"plist"];
    
    listCategory = [[NSDictionary alloc] initWithContentsOfFile:pathCategory];
    
    selectedRow = -1;
    option = [[Option alloc] init];
    _btnLimits.title = _type>dtNEW_PAID ? [NSString stringWithFormat:@"%d", (int)option.limits] : @"100";
    
    NSString *c = [listCategory objectForKey:option.category];
    if (c==nil || c.length==0) {
        option.category = @"0";
        _btnCategory.title = @"All";
    }
    
    [_btnCountry setImage:[UIImage imageNamed:option.country.uppercaseString] forState:UIControlStateNormal];
    arrEntry = [NSMutableArray array];
    
    self.title = [TITLE_ARRAY objectAtIndex:_type];
    _btnLimits.enabled = _type>dtNEW_PAID;
    _btnCategory.enabled = _type>dtNEW_PAID;
    
    [self onClickReload:nil];
    
    // 구글 배너 셋팅
    self.vwBanner.rootViewController = self;
    self.vwBanner.adSize = kGADAdSizeBanner;
    self.vwBanner.adUnitID = @"ca-app-pub-2693561479903032/2344704430"; // 디테일 리스트 하단 광고
    GADRequest *request = [GADRequest request];
    request.testDevices = ADMOB_TEST_DEVICES;
    [self.vwBanner loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)onClickReload:(id)sender {
    UIAlertController *loading = loadingAlertWithTimeout(@"Loading...", MAX_LOADING);
    [self presentViewController:loading animated:true completion:^{
        NSMutableString *queryUrl = [NSMutableString stringWithFormat:@"http://itunes.apple.com/%@/rss/%@",
                                     option.country,
                                     [CHART_ARRAY objectAtIndex:_type]];
        
        if(_btnLimits.enabled) {
            [queryUrl appendString:@"/limit="];
            [queryUrl appendString:[NSString stringWithFormat:@"%d", (int)option.limits]];
        }
        if (_btnCategory.enabled && ![option.category isEqualToString:@"0"]) {
            [queryUrl appendString:@"/genre="];
            [queryUrl appendString:option.category];
        }
        
        [queryUrl appendString:@"/json"];
        NSLog(@"Request URL : %@", queryUrl);
        
        [JSONHTTPClient getJSONFromURLWithString:queryUrl completion:^(id json, JSONModelError *err) {
            [loading dismissViewControllerAnimated:YES completion:^{
                [arrEntry removeAllObjects];
                
                if (err) {
                    alertMessage(self, @"Error", err.description);
                } else {
                    NSArray *arr = [EntryModel arrayOfModelsFromDictionaries:json[@"feed"][@"entry"] error:nil];
                    if (arr) {
                        arrEntry = [NSMutableArray arrayWithArray:arr];
                        [_tblEntry reloadData];
                        if (arrEntry.count>0) {
                            [_tblEntry scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                             atScrollPosition:UITableViewScrollPositionTop
                                                     animated:NO];
                        }
                    } else {
                        alertMessage(self, @"Warnning", @"Empty data");
                    }
                }
            }];
        }];
    }];
}

- (IBAction)onClickLimits:(id)sender {
    _vwOption.hidden = NO;
    _pkOption.tag = 0;
    [_pkOption reloadAllComponents];
    
    switch (option.limits) {
        case  10: [_pkOption selectRow:0 inComponent:0 animated:NO]; break;
        case  25: [_pkOption selectRow:1 inComponent:0 animated:NO]; break;
        case  50: [_pkOption selectRow:2 inComponent:0 animated:NO]; break;
        case 100: [_pkOption selectRow:3 inComponent:0 animated:NO]; break;
        case 200: [_pkOption selectRow:4 inComponent:0 animated:NO]; break;
    }
}

- (IBAction)onClickCategory:(id)sender {
    _vwOption.hidden = NO;
    _pkOption.tag = 1;
    [_pkOption reloadAllComponents];
    
    NSArray *sortedKeys = [listCategory keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)];
    NSInteger row = [sortedKeys indexOfObject:option.category];
    [_pkOption selectRow:row inComponent:0 animated:NO];
}

- (IBAction)onClickCountry:(id)sender {
    _vwOption.hidden = NO;
    _pkOption.tag = 2;
    [_pkOption reloadAllComponents];
    
    NSArray *sortedKeys = [listCountry keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)];
    NSInteger row = [sortedKeys indexOfObject:option.country];
    [_pkOption selectRow:row inComponent:0 animated:NO];
}

- (IBAction)onClickPickerDone:(id)sender {
    _vwOption.hidden = YES;
    NSUInteger row = [_pkOption selectedRowInComponent:0];
    switch (_pkOption.tag) {
        case 0:
            switch (row) {
                case 0: option.limits = 10; break;
                case 1: option.limits = 25; break;
                case 2: option.limits = 50; break;
                case 3: option.limits = 100; break;
                case 4: option.limits = 200; break;
            }
            _btnLimits.title = [NSString stringWithFormat:@"%d", (int)option.limits];
            break;
        case 1: {
            NSArray *sortedKeys = [listCategory keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)];
            option.category = [sortedKeys objectAtIndex:row];
            _btnCategory.title = [listCategory objectForKey:option.category];
        } break;
        case 2: {
            NSArray *sortedKeys = [listCountry keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)];
            NSString *code = [sortedKeys objectAtIndex:row];
            option.country = [code substringToIndex:2];
            [_btnCountry setImage:[UIImage imageNamed:option.country.uppercaseString] forState:UIControlStateNormal];
        } break;
    }
    [self onClickReload:nil];
}

- (IBAction)onClickFavorites:(id)sender {
    notifyMessage(self, @"Add to Favorites", @"", 500);
    EntryModel *entry = [arrEntry objectAtIndex:selectedRow];
    if (_type<dtMAC_FREE) [MyDB insert:entry table:@"ios"];
    else if (_type<dtPODCASTS) [MyDB insert:entry table:@"osx"];
    else [MyDB insert:entry table:@"pod"];
}

- (IBAction)onClickDownload:(id)sender {
    UIAlertController *loading = loadingAlertWithTimeout(@"Loading...", MAX_LOADING);
    [self presentViewController:loading animated:true completion:^{
        EntryModel *entry = [arrEntry objectAtIndex:selectedRow];
        SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
        [storeProductViewController setDelegate:self];
        [storeProductViewController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier : entry.id}
                                              completionBlock:^(BOOL result, NSError *error)
         {
             [loading dismissViewControllerAnimated:YES completion:^{
                 if (error) {
                     alertMessage(self, @"Error", error.description);
                 } else {
                     [self presentViewController:storeProductViewController animated:YES completion:nil];
                 }
             }];
         }];
    }];
}

- (IBAction)onClickLink:(id)sender {
    EntryModel *entry = [arrEntry objectAtIndex:selectedRow];
    NSArray *shareAray = @[entry.name, [NSURL URLWithString:entry.link]];
    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:shareAray
                                                                                    applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)onClickPod:(id)sender {
    EntryModel *entry = [arrEntry objectAtIndex:selectedRow];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:entry.link]];
}

#pragma mark - Picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (_pkOption.tag) {
        case 0: return 5;
        case 1: return listCategory.count;
        case 2: return listCountry.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (_pkOption.tag) {
        case 0:
            switch (row) {
                case 0: return @"10";
                case 1: return @"25";
                case 2: return @"50";
                case 3: return @"100";
                case 4: return @"200";
            }
        case 1: {
            NSArray *sortedKeys = [[listCategory allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            return [sortedKeys objectAtIndex:row];
        } break;
        case 2: {
            NSArray *sortedKeys = [[listCountry allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            return [sortedKeys objectAtIndex:row];
        } break;
            
    }
    return @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(arrEntry.count, option.limits);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID;
    switch (_type) {
        case dtNEW_ALL      :
        case dtNEW_FREE     :
        case dtNEW_PAID     : cellID = @"cell1"; break;
        case dtIPHONE_FREE  :
        case dtIPHONE_PAID  :
        case dtIPHONE_GROSS :
        case dtIPAD_FREE    :
        case dtIPAD_PAID    :
        case dtIPAD_GROSS   : cellID = @"cell2"; break;
        case dtMAC_FREE     :
        case dtMAC_PAID     :
        case dtMAC_GROSS    : cellID = @"cell3"; break;
        case dtPODCASTS     : cellID = @"cell4"; break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID
                                                            forIndexPath:indexPath];
    UIImageView *image = [cell viewWithTag:1];
    UILabel *title = [cell viewWithTag:2];
    UILabel *artist = [cell viewWithTag:3];
    UILabel *price = [cell viewWithTag:4];
    
    EntryModel *entry = [arrEntry objectAtIndex:indexPath.row];
    
    image.layer.cornerRadius = 5;
    image.clipsToBounds = true;
    [image setImageWithURL:entry.imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
    title.text = [NSString stringWithFormat:@"%d. %@", (int)indexPath.row+1, entry.name];
    artist.text = entry.artist;
    if (_type==dtPODCASTS) {
        price.text = @"";
    } else {
        if (entry.price==0.0) {
            price.textColor = [UIColor colorWithRed:0.58 green:0.80 blue:0.42 alpha:1.00];
            price.text = @"Free";
        } else {
            price.textColor = [UIColor colorWithRed:0.81 green:0.18 blue:0.24 alpha:1.00];
            price.text = entry.priceLabel;
        }
    }
    
    if (_type>dtNEW_PAID) {
        UITextView *summery = [cell viewWithTag:5];
        summery.text = (entry.summary==nil) ? @"Empty summary" : entry.summary;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedRow = (indexPath.row==selectedRow) ? -1 : indexPath.row;
    [tableView reloadData];
    
    // 썸머리 스크롤 되었다면 최상위로 스크롤 올린다.
    if (selectedRow>-1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UITextView *summery = [cell viewWithTag:5];
        [summery scrollRangeToVisible:NSMakeRange(0, 0)];        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedRow==indexPath.row) {
        if (_type>dtNEW_PAID) return 163.5;
        return 125;
    }
    
    return 51;
}

//-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewRowAction *favAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
//                                                                          title:@"Favorites"
//                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                        {
//                                            [tableView setEditing:NO animated:YES];
//                                        }];
//    favAction.backgroundColor = [UIColor colorWithRed:0.58 green:0.80 blue:0.42 alpha:1.00];
//    
//    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal
//                                                                         title:@"Share"
//                                                                       handler:^(UITableViewRowAction *action, NSIndexPath *indexPath)
//                                       {
//                                           [tableView setEditing:NO animated:YES];
//                                           EntryModel *entry = [arrEntry objectAtIndex:indexPath.row];
//                                       }];
//    shareAction.backgroundColor = [UIColor colorWithRed:0.10 green:0.76 blue:1.00 alpha:1.00];
//    
//    return @[favAction, shareAction];
//}

#pragma mark - SKStoreProductViewControllerDelegate

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end







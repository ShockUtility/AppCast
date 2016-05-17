//
//  iTunesModel.h
//  AppCast
//
//  Created by iMac5K on 2016. 4. 12..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface EntryModel : JSONModel

@property (strong, nonatomic) NSString*             id;
@property (strong, nonatomic) NSString*             name;
@property (strong, nonatomic) NSString*             artist;
@property (assign, nonatomic) float                 price;
@property (strong, nonatomic) NSString*             priceLabel;
@property (strong, nonatomic) NSString*             link;
@property (strong, nonatomic) NSString<Optional>*   summary;
@property (strong, nonatomic) NSArray*              images;
@property (readonly, nonatomic) NSURL<Ignore>*      imageURL;

@end

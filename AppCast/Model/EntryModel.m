//
//  iTunesModel.m
//  AppCast
//
//  Created by iMac5K on 2016. 4. 12..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import "EntryModel.h"

@implementation EntryModel

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"id.attributes.im:id"          : @"id",
        @"im:name.label"                : @"name",
        @"im:artist.label"              : @"artist",
        @"im:price.attributes.amount"   : @"price",
        @"im:price.label"               : @"priceLabel",
        @"im:image"                     : @"images",
        @"link.attributes.href"         : @"link",
        @"summary.label"                : @"summary"}];
}

- (NSURL *) imageURL {
    return [NSURL URLWithString: [_images lastObject][@"label"]];
}

@end

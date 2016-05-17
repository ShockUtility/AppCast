//
//  Option.h
//  AppCast
//
//  Created by iMac5K on 2016. 4. 12..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Option : NSObject
{
    NSUserDefaults *def;
}

@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* category;
@property (assign, nonatomic) NSInteger limits;

@end

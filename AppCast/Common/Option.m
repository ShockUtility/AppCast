//
//  Option.m
//  AppCast
//
//  Created by iMac5K on 2016. 4. 12..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import "Option.h"

@implementation Option

- (id)init {
    if (self = [super init]) {
        def = [NSUserDefaults standardUserDefaults];
        _country = [def stringForKey:@"country"];
        if (_country==nil) _country = @"us";
        _category = [def stringForKey:@"category"];
        if (_category==nil) _category = @"0";
        _limits = [def integerForKey:@"limits"];
        if (_limits==0) _limits = 100;
    }
    return self;
}

- (void)setCountry:(NSString *)value {
    _country = value;
    [def setObject:value forKey:@"country"];
    [def synchronize];
}

- (void)setCategory:(NSString *)value {
    _category = value;
    [def setObject:value forKey:@"category"];
    [def synchronize];
}

- (void)setLimits:(NSInteger)value {
    _limits = value;
    [def setInteger:value forKey:@"limits"];
    [def synchronize];
}

@end

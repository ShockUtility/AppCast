//
//  MyDB.h
//  AppCast
//
//  Created by iMac5K on 2016. 4. 14..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "EntryModel.h"

@interface MyDB : NSObject

+ (FMDatabase *)sharedDB;
+ (BOOL) insert:(EntryModel *)entry table:(NSString *)table;
+ (BOOL) delete:(long)no table:(NSString *)table;
+ (NSMutableArray *) select:(NSString *)table;

@property (strong, nonatomic) FMDatabase *db;

@end

//
//  MyDB.m
//  AppCast
//
//  Created by iMac5K on 2016. 4. 14..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import "MyDB.h"

@implementation MyDB

static FMDatabase *sharedDB = nil;

+ (FMDatabase *)sharedDB {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex : 0];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"appcast.db"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL success = [fileManager fileExistsAtPath:dbPath];
        
#ifdef DEBUG
//        [fileManager removeItemAtPath:dbPath error:nil];
//        success = NO;
//        NSLog(@"dbPath : %@", dbPath);
#endif
        
        if (!success) { // 최초 실행인걸로 간주할 수 있기 때문에 DB를 복사한다.
            NSString *dbPathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"appcast.db"];
            [fileManager copyItemAtPath:dbPathFromApp toPath:dbPath error:nil];
        }
        
        sharedDB = [FMDatabase databaseWithPath:dbPath];
        [sharedDB open];
    });
    
    return sharedDB;
}

+ (BOOL) insert:(EntryModel *)entry table:(NSString *)table {
    NSString *query = [NSString stringWithFormat: @"INSERT INTO %@_favorites (id,image,name,artist,price,link,summary) VALUES (?,?,?,?,?,?,?)", table];
    return [[MyDB sharedDB] executeUpdate: query,
            entry.id,
            entry.imageURL,
            entry.name,
            entry.artist,
            entry.price==0.0 ? @"Free" : entry.priceLabel,
            entry.link,
            entry.summary];
}

+ (BOOL) delete:(long)no table:(NSString *)table {
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@_favorites WHERE no=?", table];
    return [[MyDB sharedDB] executeUpdate:query, [NSNumber numberWithLong:no]];
}

+ (NSMutableArray *) select:(NSString *)table {
    NSMutableArray *list = [NSMutableArray array];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@_favorites ORDER BY name ASC", table];
    FMResultSet *s = [[MyDB sharedDB] executeQuery:query];
    
    while ([s next]) {
        [list addObject:[s resultDictionary]];
    }
    
    return list;
}

@end

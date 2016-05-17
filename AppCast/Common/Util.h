//
//  Util.h
//  AppCast
//
//  Created by iMac5K on 2016. 4. 14..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIAlertController *loadingAlertWithTimeout(NSString *title, long timeout);
UIAlertController *loadingAlert(NSString *title);
void alertMessage(UIViewController *owner, NSString *title, NSString *message);
void notifyMessage(UIViewController *owner, NSString *title, NSString *message, long delay);
//
//  Util.m
//  AppCast
//
//  Created by iMac5K on 2016. 4. 14..
//  Copyright © 2016년 Shock. All rights reserved.
//

#import "Util.h"

UIAlertController *loadingAlertWithTimeout(NSString *title, long timeout) {
    UIAlertController *loading = [UIAlertController alertControllerWithTitle: title
                                                                     message: nil
                                                              preferredStyle: UIAlertControllerStyleAlert];
    UIViewController *customVC = [[UIViewController alloc] init];
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    [customVC.view addSubview:spinner];
    [customVC.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem: spinner
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:customVC.view
                                  attribute:NSLayoutAttributeCenterX
                                  multiplier:1.0f
                                  constant:0.0f]];
    [customVC.view addConstraint:[NSLayoutConstraint
                                  constraintWithItem: spinner
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:customVC.view
                                  attribute:NSLayoutAttributeCenterY
                                  multiplier:1.0f
                                  constant:-10.0f]];
    [loading setValue:customVC forKey:@"contentViewController"];
    
    if (timeout>0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  timeout*NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
                if (loading && !loading.isBeingDismissed) {
                    [loading dismissViewControllerAnimated:YES completion:nil];
                }
            });
        });
    }
    
    return loading;
}

UIAlertController *loadingAlert(NSString *title) {
    return loadingAlertWithTimeout(title, 0);
}

void alertMessage(UIViewController *owner, NSString *title, NSString *message) {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: title
                                                                    message: message
                                                             preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [owner presentViewController:alert animated:YES completion:nil];
}

void notifyMessage(UIViewController *owner, NSString *title, NSString *message, long delay) {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: title
                                                                    message: message
                                                             preferredStyle: UIAlertControllerStyleAlert];
    [owner presentViewController:alert animated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  delay*NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    });
}






//
//  AlertView.m
//  Trigger
//
//  Created by Ray Shih on 1/16/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

+ (void)showError:(NSError *)error withTitle:(NSString *)title
{
    NSString *errorMessage = [error.userInfo valueForKeyPath:@"responseObject.message"];
    if (!errorMessage) {
        errorMessage = error.localizedDescription;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
    [alertView show];
}

@end

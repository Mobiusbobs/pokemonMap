//
//  AlertView.h
//  Trigger
//
//  Created by Ray Shih on 1/16/15.
//  Copyright (c) 2015 MobiusBobs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : NSObject

+ (void)showError:(NSError *)error withTitle:(NSString *)title;

@end

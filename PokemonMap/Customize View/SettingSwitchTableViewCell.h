//
//  SettingSwitchTableViewCell.h
//  Trigger
//
//  Created by LinYiting on 2015/7/16.
//  Copyright (c) 2015年 MobiusBobs Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingSwitchTableViewCell : UITableViewCell

@property (nonatomic, strong) UISwitch *switchButton;

- (void)updateViewWithMainText:(NSString *)mainText;

@end

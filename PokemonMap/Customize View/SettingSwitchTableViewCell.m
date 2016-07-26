//
//  SettingSwitchTableViewCell.m
//  Trigger
//
//  Created by LinYiting on 2015/7/16.
//  Copyright (c) 2015年 MobiusBobs Inc. All rights reserved.
//

#import "SettingSwitchTableViewCell.h"

#import <Masonry.h>
#import <ReactiveCocoa.h>

@interface SettingSwitchTableViewCell()

@property (nonatomic, strong) UILabel *mainTextLabel;

@end

@implementation SettingSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
        [self bindStyle];
    }
    return self;
}

- (void)setup
{
    UILabel *mainTextLabel = [UILabel new];
    mainTextLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:mainTextLabel];
    
    [mainTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.contentView);
    }];
    
    self.mainTextLabel = mainTextLabel;
    
    UISwitch *switchButton = [UISwitch new];
    [self.contentView addSubview:switchButton];
    
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mainTextLabel.mas_right).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@50);
    }];
    
    self.switchButton = switchButton;
}

- (void)bindStyle
{
    self.mainTextLabel.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)updateViewWithMainText:(NSString *)mainText
{
    self.mainTextLabel.text = mainText;
}




@end

//
//  SettingViewController.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/26.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingSwitchTableViewCell.h"
#import "FavoriteListViewController.h"

@interface SettingViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Setting";
    [self constructView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)constructView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;

    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:@"Cell1"];
    [tableView registerClass:[SettingSwitchTableViewCell class]
      forCellReuseIdentifier:@"Cell2"];
    
    // hide all empty cells
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    
    [self.view addSubview:tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: // personal info
            return 1;
            break;
            
        case 1: // social
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
            cell.textLabel.text = @"Customize Display";
            return cell;
        }
            break;
        case 1:
        {
            SettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
            [cell updateViewWithMainText:NSLocalizedString(@"publishNotificationSetting", nil)];
            return cell;
        }
            
            break;
        default: {
            return nil;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
            [self navigateToFavoriteVC];
            break;
        case 1:
            
            break;
        case 2:
                       break;
        default: {
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 32)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 6, tableView.frame.size.width, 20)];
    label.font = [UIFont fontWithName:@"SFUIText-Regular" size:14.0f];
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"General Settings", nil);
            break;
        case 1:
            sectionName = NSLocalizedString(@"Social Settings", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    
    
    
    /* Section header is in 0th index... */
    [label setText:sectionName];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:0.898 green:0.933 blue:0.945 alpha:1.000]]; //your background color...
    return view;
}

- (void)navigateToFavoriteVC
{
    FavoriteListViewController *vc = [FavoriteListViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

//
//  FavoriteListViewController.m
//  PokemonMap
//
//  Created by LinYiting on 2016/7/26.
//  Copyright © 2016年 Mobiusbobs. All rights reserved.
//

#import "FavoriteListViewController.h"
#import "PokemonTableViewCell.h"
#import <BlocksKit.h>

@interface FavoriteListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *pokemonBlackListArray;

@end

@implementation FavoriteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self constructView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *pokemonListSaved = [defaults objectForKey:@"pokemon_blacklist"];
    
    if (pokemonListSaved && [pokemonListSaved count] > 0) {
        self.pokemonBlackListArray = [[NSMutableArray alloc] initWithArray:pokemonListSaved];
    } else {
        self.pokemonBlackListArray = [[NSMutableArray alloc] init];
    }
}

- (void)constructView
{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[PokemonTableViewCell class]
      forCellReuseIdentifier:@"Cell"];
    
    // hide all empty cells
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    
    [self.view addSubview:tableView];

}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 151;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string =  [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    BOOL isDeleted = [self.pokemonBlackListArray bk_any:^BOOL(NSString *pokeId) {
        return [pokeId isEqualToString:string];
    }];
    PokemonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    [cell updateViewWithPokemon:indexPath.row+1];
    if(isDeleted) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PokemonTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *string =  [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    BOOL isDeleted = [self.pokemonBlackListArray bk_any:^BOOL(NSString *pokeId) {
        return [pokeId isEqualToString:string];
    }];
    
    if(isDeleted) {
        [self.pokemonBlackListArray removeObject:string];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [self.pokemonBlackListArray addObject:string];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)saveAction:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.pokemonBlackListArray forKey:@"pokemon_blacklist"];
    [prefs synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end

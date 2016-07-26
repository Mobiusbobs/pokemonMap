//
//  PokemonTableViewCell.h
//  iPokeGo
//
//  Created by Dimitri Dessus on 23/07/2016.
//  Copyright © 2016 Dimitri Dessus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pokemon.h"

@interface PokemonTableViewCell : UITableViewCell

@property(weak, nonatomic) UIImageView *pokemonimageView;
@property(weak, nonatomic) UILabel *pokemonName;
- (void)updateViewWithPokemon:(NSInteger)pokemonId;

@end

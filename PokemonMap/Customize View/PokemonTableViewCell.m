//
//  PokemonTableViewCell.m
//  iPokeGo
//
//  Created by Dimitri Dessus on 23/07/2016.
//  Copyright © 2016 Dimitri Dessus. All rights reserved.
//

#import "PokemonTableViewCell.h"
#import <Masonry.h>

@interface PokemonTableViewCell()

@end

@implementation PokemonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@38);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
    }];
    
    self.pokemonimageView = imageView;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    
    [self.contentView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
    }];
    
    self.pokemonName = titleLabel;
    
    
}

- (void)updateViewWithPokemon:(NSInteger)pokemonId
{
    NSString *string =  [NSString stringWithFormat:@"%ld", (long)pokemonId];
    self.pokemonimageView.image = [UIImage imageNamed:string];
    self.pokemonName.text = NSLocalizedString(string, nil);
}


@end

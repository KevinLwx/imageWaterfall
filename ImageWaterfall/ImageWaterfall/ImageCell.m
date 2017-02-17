//
//  ImageCell.m
//  ImageWaterfall
//
//  Created by Liuwx on 2017/2/16.
//  Copyright © 2017年 Liuwx. All rights reserved.
//

#import "ImageCell.h"
#import "ImageModel.h"
@interface ImageCell()
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;


@end

@implementation ImageCell
- (void)setModel:(ImageModel *)model{
    _model = model;
    
    self.cellImageView.image = [UIImage imageNamed:model.icon];
    self.cellLabel.text = model.price;
}

@end

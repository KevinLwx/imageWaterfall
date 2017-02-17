//
//  ImageModel.h
//  ImageWaterfall
//
//  Created by Liuwx on 2017/2/16.
//  Copyright © 2017年 Liuwx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject
@property(copy,nonatomic) NSString *icon;
@property(copy,nonatomic) NSString *price;
@property(assign,nonatomic) NSInteger height;
@property(assign,nonatomic) NSInteger width;

- (instancetype)initWithimageDict:(NSDictionary *)dict;

+ (instancetype)imageWithDict:(NSDictionary *)dict;

+ (NSArray*)imagesWithPlistIndex:(NSInteger)plistIndex;

@end

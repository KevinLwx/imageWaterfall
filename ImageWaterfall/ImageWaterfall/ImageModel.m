//
//  ImageModel.m
//  ImageWaterfall
//
//  Created by Liuwx on 2017/2/16.
//  Copyright © 2017年 Liuwx. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

- (instancetype)initWithimageDict:(NSDictionary *)dict{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)imageWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithimageDict:dict];
}

+ (NSArray*)imagesWithPlistIndex:(NSInteger)plistIndex{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@(plistIndex % 3 + 1).description ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:array.count];
    
    for(NSDictionary *dict in array){
        ImageModel *model = [ImageModel imageWithDict:dict];
        [arrM addObject:model];
    }
    return arrM.copy;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


@end

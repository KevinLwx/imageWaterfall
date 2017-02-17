//
//  FlowLayout.h
//  ImageWaterfall
//
//  Created by Liuwx on 2017/2/16.
//  Copyright © 2017年 Liuwx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageFlowLayoutDelegate <NSObject>

- (CGFloat)cellHeightWithIndexPath:(NSIndexPath*)indexPath andCellWidth:(CGFloat)cellWidth;

@end

@interface FlowLayout : UICollectionViewFlowLayout

/**
 列数
 */
@property(assign,nonatomic) NSInteger columnCount;


/**
 代理：用于计算cell的显示高度
 */
@property(weak,nonatomic) id<ImageFlowLayoutDelegate> delegate;


@end

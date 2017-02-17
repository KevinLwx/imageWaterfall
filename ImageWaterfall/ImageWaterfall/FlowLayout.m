//
//  FlowLayout.m
//  ImageWaterfall
//
//  Created by Liuwx on 2017/2/16.
//  Copyright © 2017年 Liuwx. All rights reserved.
//

#import "FlowLayout.h"
#import "ImageModel.h"
@interface FlowLayout()
@property(nonatomic,strong) NSMutableArray *attrList;

/**
 所有列的高度集合
 */
@property(nonatomic,strong) NSMutableArray *colHeightList;


@end

@implementation FlowLayout
// MARK: - 设置items的位置和大小：组与组的间距、组内cell间距、组内行间距
// 在这里计算每一个item的位置和大小
- (void)prepareLayout{
    [super prepareLayout];
    
    NSInteger cellCount = [self.collectionView numberOfItemsInSection:0];
    
    // 先把底部视图移除：防止上拉加载更多时出错，不能加一次后，又加，又加
    [self.attrList removeLastObject];
    
    // 获取上拉加载时新增的cell个数
    NSInteger newCellCount = cellCount - self.attrList.count;
    
    // 计算每一个cell的位置和大小
    for (NSInteger itemNo = 0; itemNo < newCellCount; itemNo++){
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.attrList.count inSection:0];
        
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 列号
        // NSInteger col = itemNo % self.columnCount;
        // 获取最低高度的列号
        NSInteger col = [self minHeightColNum];
        
        // x = 左间距 + （水平间距+宽度）* 列号
        CGFloat cellWidth = (self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.minimumInteritemSpacing) / self.columnCount;
        CGFloat cellX = self.sectionInset.left + (self.minimumInteritemSpacing + cellWidth) * col;
        
        // 这里代理方法一定要实现，不要判断
        CGFloat cellHeight = [self.delegate cellHeightWithIndexPath:indexPath andCellWidth:cellWidth];
        
        CGFloat cellY = [self.colHeightList[col] floatValue];
        self.colHeightList[col] = @([self.colHeightList[col] floatValue] + cellHeight + self.minimumLineSpacing);
        
        attr.frame = CGRectMake(cellX, cellY, cellWidth, cellHeight);
        
        [self.attrList addObject:attr];
    }
    
    // 底部视图
    UICollectionViewLayoutAttributes *footerAttr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    footerAttr.frame = CGRectMake(0, [self maxHeight] + self.minimumLineSpacing, self.collectionView.bounds.size.width, self.footerReferenceSize.height);
    
    [self.attrList addObject:footerAttr];
}

// MARK: - 求最低高度的列号，优化Cell某一列高度错太开的情况
- (NSInteger)minHeightColNum{
    CGFloat minHeight = CGFLOAT_MAX;
    CGFloat minHeightColNum = 0;
    for(NSInteger i = 0; i < self.colHeightList.count; i++){
        if(minHeight > [self.colHeightList[i] floatValue]){
            minHeight = [self.colHeightList[i] floatValue];
            minHeightColNum = i;
        }
    }
    return minHeightColNum;
}

// MARK: - 求最大高度，重新设置滚动范围
- (CGFloat)maxHeight{
    CGFloat h = CGFLOAT_MIN;
    for(NSInteger i = 0; i < self.colHeightList.count; i++){
        if (h < [self.colHeightList[i] floatValue]){
            h = [self.colHeightList[i] floatValue];
        }
    }
    return h;
}

// MARK: - 设置ContentSize
- (CGSize)collectionViewContentSize{
    return CGSizeMake(0, [self maxHeight] + self.minimumLineSpacing + self.footerReferenceSize.height);
}

// MARK: - 等比例缩放，求高度
- (CGFloat)cellHeightWithModel:(ImageModel*)model :(CGFloat)cellWidth{
    CGFloat cellHeight = cellWidth / model.width * model.height;
    return cellHeight;
}

// MARK: - 返回指定范围元素进行布局设置
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrList;
}

// MARK: - 懒加载属性
- (NSMutableArray *)attrList{
    if(_attrList == nil){
        _attrList = [NSMutableArray array];
    }
    return _attrList;
}
- (NSMutableArray *)colHeightList{
    if(_colHeightList == nil){
        _colHeightList = [NSMutableArray arrayWithCapacity:self.columnCount];
        for(NSInteger i = 0; i < self.columnCount; i++){
            _colHeightList[i] = @(self.sectionInset.top);
        }
    }
    return _colHeightList;
}

@end

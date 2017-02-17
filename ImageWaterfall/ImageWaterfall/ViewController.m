//
//  ViewController.m
//  ImageWaterfall
//
//  Created by Liuwx on 2017/2/16.
//  Copyright © 2017年 Liuwx. All rights reserved.
//

#import "ViewController.h"
#import "ImageModel.h"
#import "ImageCell.h"
#import "FlowLayout.h"
#import "FootView.h"
static NSString *cellID = @"cell";

@interface ViewController ()<ImageFlowLayoutDelegate>
@property (nonatomic,strong) NSMutableArray *imageList;

@property (weak, nonatomic) IBOutlet FlowLayout *flowLayout;
@property (weak,nonatomic) FootView *footerView;
// 第几个plist文件
@property (assign,nonatomic) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    self.flowLayout.columnCount = 3;
    // self.flowLayout.images = self.imageList;
    self.flowLayout.delegate = self;

    // Do any additional setup after loading the view, typically from a nib.
}
- (void)loadData{
    NSArray *images = [ImageModel imagesWithPlistIndex:self.index];
    [self.imageList addObjectsFromArray:images];
    self.index++;
    self.index = MAX(self.index, 3);
}

// MARK: - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    ImageModel *model = self.imageList[indexPath.row];
    
    cell.model = model;
    
    return cell;
}
// 分组的头部或底部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    FootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    
    self.footerView = footerView;
    
    return footerView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.footerView == nil || self.footerView.activityView.isAnimating){
        return;
    }
    // 如果底部视图完全可见，加载更多数据
    if(self.collectionView.contentOffset.y + self.collectionView.frame.size.height > CGRectGetMaxY(self.footerView.frame)){
        // 加载更多数据
        [self.footerView.activityView startAnimating]; // 开启菊花转
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 加载更多数据
            [self loadData];
            [self.collectionView reloadData];
            
            // 数据加载完，停止菊花转
            [self.footerView.activityView stopAnimating];
            self.footerView = nil;
        });
    }
}

// MARK: - 懒加载数据
- (NSMutableArray*)imageList{
    if(_imageList == nil){
        _imageList = [NSMutableArray array];
    }
    return _imageList;
}

// MARK: - imageFlowLayoutDelegate
- (CGFloat)cellHeightWithIndexPath:(NSIndexPath*)indexPath andCellWidth:(CGFloat)cellWidth{
    ImageModel *model = self.imageList[indexPath.item];
    return cellWidth / model.width * model.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

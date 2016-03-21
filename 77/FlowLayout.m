//
//  FlowLayout.m
//  77
//
//  Created by wzt on 15/9/28.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "FlowLayout.h"

@interface FlowLayout()
@property (nonatomic, strong) NSMutableDictionary *MaxYDict;
@property (nonatomic, strong) NSMutableArray *attrbutarray;

@end

@implementation FlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.edgInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        self.totalColumn  = 3;
        self.columnMargin = 30;
        self.rowMargin = 30;
        self.attrbutarray = [NSMutableArray array];
        self.MaxYDict = [NSMutableDictionary dictionary];
//        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}



- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
- (CGSize)collectionViewContentSize {
    __block NSString *max = @"0";
    [self.MaxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *obj, BOOL *stop) {
        if ([obj floatValue] > [self.MaxYDict[max]floatValue]) {
            max = column;
        }
    }];
    return CGSizeMake(0,[self.MaxYDict[max] floatValue] + self.edgInsets.bottom );
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    __block NSString *minColum = @"0";
    [self.MaxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * stop) {
        if ([maxY floatValue] < [self.MaxYDict[minColum] floatValue]) {
            minColum = column;
        }
    }];
    //设置 宽高
    CGFloat Width  = (self.collectionView.bounds.size.width - self.edgInsets.left - self.edgInsets.right - (self.totalColumn - 1) * self.columnMargin)/self.totalColumn;
    CGFloat Height = [self.delegate waterflowLayout:self heightForWidth:Width atIndexPath:indexPath];
    //设置 XY
    CGFloat X = self.edgInsets.left + (Width + self.columnMargin) * [minColum floatValue];
    CGFloat Y = [self.MaxYDict[minColum] floatValue] + self.rowMargin;
    
    self.MaxYDict[minColum] = @(Y + Height);
    
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(X, Y, Width, Height);
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
  
    return self.attrbutarray;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    for (int i = 0; i < self.totalColumn; i ++) {
        NSString *column = [NSString stringWithFormat:@"%@",@(i)];
        self.MaxYDict[column] = @(self.edgInsets.top);
    }

    [self.attrbutarray removeAllObjects];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i ++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrbutarray addObject:attr];
    }
}
@end

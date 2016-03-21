//
//  FlowLayout.h
//  77
//
//  Created by wzt on 15/9/28.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlowLayout;
@protocol FlowLayoutDelegate <NSObject>
- (CGFloat)waterflowLayout:(FlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end
@interface FlowLayout : UICollectionViewLayout

@property(nonatomic, weak) id<FlowLayoutDelegate> delegate;
@property (nonatomic, assign) UIEdgeInsets  edgInsets;
@property (nonatomic, assign) NSInteger     totalColumn;
@property (nonatomic, assign) CGFloat       height;
@property (nonatomic, assign) CGFloat       width;
/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;



@end

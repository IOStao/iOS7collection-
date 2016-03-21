//
//  layout.h
//  layout
//
//  Created by wzt on 15/11/9.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface layout : UICollectionViewLayout
/**内边距 */
@property (nonatomic, assign) UIEdgeInsets  edgInsets;
/**想展示的行数*/
@property (nonatomic, assign) NSInteger     totalRow;
/**想展示的列数*/
@property (nonatomic, assign) NSInteger     totalColum;
/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat       rowMargin;
@property (nonatomic, assign) CGFloat       height;
@property (nonatomic, assign) CGFloat       width;
@end


#import <UIKit/UIKit.h>
@class Shop,ShopCell;
@protocol ShopCellDelegate <NSObject>
@optional
- (void)shopCellClickDeleteBtn:(ShopCell *)cell;

@end

@interface ShopCell : UICollectionViewCell
@property (nonatomic, strong) Shop *shop;
@property (nonatomic, assign) BOOL  change;
@property(nonatomic, weak) id<ShopCellDelegate> delegate;
@end

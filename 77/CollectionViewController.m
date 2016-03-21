//
//  CollectionViewController.m
//  77
//
//  Created by wzt on 15/9/28.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "CollectionViewController.h"
#import "Shop.h"
#import "ShopCell.h"
#import "FlowLayout.h"
#import "layout.h"
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
@interface CollectionViewController ()<FlowLayoutDelegate,ShopCellDelegate>

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) BOOL change;
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)array {
    if (!_array) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *Array = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            Shop *app = [[Shop alloc] initWithDict:dict];
            [Array addObject:app];
        }
        _array = Array;
    }
return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    [self addgesture];
    // Register cell classes
    self.collectionView.backgroundColor = [UIColor whiteColor];
//    FlowLayout *layout = [[FlowLayout alloc]init];
//    layout.delegate = self;
//    self.collectionView.collectionViewLayout = layout;
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UILayoutConstraintAxisHorizontal
//    layout.itemSize = CGSizeMake(80, 80);
//    layout.minimumInteritemSpacing = 0;
//    layout.minimumLineSpacing = 10;
//    layout.sectionInset = UIEdgeInsetsMake(layout.minimumLineSpacing, 10, 10, 10);
//    self.collectionView.collectionViewLayout = layout;
//
    layout *layoutHorizontal = [[layout alloc] init];
    layoutHorizontal.height = 50;
    layoutHorizontal.width = 50;
    layoutHorizontal.totalColum = 4;
    layoutHorizontal.totalRow = 3;
    self.collectionView.collectionViewLayout = layoutHorizontal;
    self.collectionView.pagingEnabled = YES;
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShopCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}


//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    
//    if (!cell) {
//        cell = [[UICollectionViewCell alloc]init];
//    }
//    cell.backgroundColor = [UIColor redColor];
//    UILabel *index = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
//    
//    index.text =  [NSString stringWithFormat:@"%ld", indexPath.item] ;
//    [cell.contentView addSubview:index];
//    return cell;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        // Configure the cell
    Shop *shop = self.array [indexPath.item];
    cell.shop = shop;
    cell.delegate = self;
    cell.backgroundColor = [UIColor yellowColor];
    if (self.change) {
        cell.change = YES;
    }else {
        cell.change = NO;
    }
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)addgesture {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.collectionView addGestureRecognizer:longPress];
    
}

- (void)longPressGestureRecognized:(id)sender {


    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {

                self.change = YES;
                
                for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
                    ShopCell *cell = (ShopCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                    
                    cell.change = YES;
                }
                sourceIndexPath = indexPath;
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            
                snapshot = [self customSnapshoFromView:cell];
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.collectionView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    center.x = location.x;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;

                    cell.alpha = 0.0;
                } completion:nil];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            center.x = location.x;
            snapshot.center = center;
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            cell.alpha = 0;
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                    [self.array exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                    [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                [self.collectionView.collectionViewLayout invalidateLayout];

                sourceIndexPath = indexPath;
            }
            
            if (location.y + cell.frame.size.height/2 > self.collectionView.contentOffset.y + self.view.bounds.size.height && location.y < self.collectionView.contentSize.height) {
                CGFloat  y;
                CGFloat x = self.collectionView.contentOffset.x;
                y = self.collectionView.contentOffset.y;
                y += 2;
                self.collectionView.contentOffset = CGPointMake(x, y);
                
            } else if (location.y - cell.frame.size.height/2 < self.collectionView.contentOffset.y && (location.y - cell.frame.size.height/2 > 0)) {
                CGFloat  y;
                CGFloat x = self.collectionView.contentOffset.x;
                y = self.collectionView.contentOffset.y;
                y -= 2;
                self.collectionView.contentOffset = CGPointMake(x, y);
            }
            break;
        }
            
        default: {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];

            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            sourceIndexPath = nil;
            [self.collectionView.collectionViewLayout invalidateLayout];
            break;
        }
    }
}

- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

- (CGFloat)waterflowLayout:(FlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath {
    Shop *shop = self.array[indexPath.row];
    return shop.h * width/shop.w;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.change = NO;
    [self.collectionView reloadData];
}

- (void)shopCellClickDeleteBtn:(ShopCell *)cell {
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        [self.array removeObjectAtIndex:[self.collectionView indexPathForCell:cell].item];
    [self.collectionView performBatchUpdates:^{
         [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:nil];
    
    
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end

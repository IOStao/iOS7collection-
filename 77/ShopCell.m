

#import "ShopCell.h"
#import "Shop.h"
#define Angle2Radian(angle) ((angle) / 180.0 * M_PI)
//#import "UIImageView+WebCache.h"

@interface ShopCell()
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation ShopCell

- (void)setChange:(BOOL)change {
    _change = change;
    if (change) {
        [self addAnimation];
        self.deleteBtn.hidden = NO;
    }else {
        self.deleteBtn.hidden = YES;
    }
}
- (void)awakeFromNib {
    self.deleteBtn.clipsToBounds = YES;
    self.deleteBtn.backgroundColor = [UIColor redColor];
    [self.deleteBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.hidden = YES;
    
}
- (void)setShop:(Shop *)shop
{
    _shop = shop;
    
    // 1.图片
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    // 2.价格
    self.priceLabel.text = shop.price;
}

- (void)addAnimation {
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];

    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(Angle2Radian(-2)),  @(Angle2Radian(2)), @(Angle2Radian(-2))];
    anim.duration = 0.25;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    
    [self.layer addAnimation:anim forKey:@"shake"];
}

- (void)click {
    if ([self.delegate respondsToSelector:@selector(shopCellClickDeleteBtn:)]) {
        [self.delegate shopCellClickDeleteBtn:self];
    }
}
@end

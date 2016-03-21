
#import <UIKit/UIKit.h>

@interface Shop : NSObject
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat h;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *price;

- (instancetype)initWithDict: (NSDictionary *)dict;
@end

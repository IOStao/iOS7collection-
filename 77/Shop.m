
#import "Shop.h"

@implementation Shop

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.price = dict[@"price"];
        self.h = [dict[@"h"]floatValue];
        self.w = [dict[@"w"]floatValue];
    }
    return self;
}
@end

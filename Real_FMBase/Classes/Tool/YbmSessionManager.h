//
//  YbmSessionManager.h
//  Pods
//
//  Created by ybm on 2017/10/31.
//
//


typedef enum{
    RequestTypeGet,
    RequestTypePost
    
}RequestType;


@interface YbmSessionManager : NSObject
- (void)setValue:(NSString *)value forHttpField:(NSString *)field;

- (void)request:(RequestType)requestType urlStr: (NSString *)urlStr parameter: (NSDictionary *)param resultBlock: (void(^)(id responseObject, NSError *error))resultBlock;
@end

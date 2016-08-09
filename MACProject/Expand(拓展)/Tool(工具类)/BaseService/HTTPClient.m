	//
//  HTTPClient.m
//  WeSchool
//
//  Created by MacKun on 15/8/26.
//  Copyright (c) 2015年 MacKun. All rights reserved.
//

#import "HTTPClient.h"
#import "AFSecurityPolicy.h"

@implementation HTTPClient
static HTTPClient *_sharedHTTPClient=nil;
/**
 *  测试地址：班班通218-查询48-点餐42
 */


//static NSString *baseUrl=@"http://10.8.1.121:86";
//static NSString *baseUrl=@"http://10.8.1.42:86";
//static NSString *baseUrl=@"http://10.8.1.237:86";
//static NSString *baseUrl=@"http://10.8.1.48:86";
static NSString *baseUrl=@"http://www.361school.com:74";


+(instancetype)sharedHTTPClient{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initHTTPClient];
      
    });
    
    return _sharedHTTPClient;
}
+(void)initHTTPClient{
     _sharedHTTPClient=[[HTTPClient alloc]initWithBaseURL:[NSURL URLWithString:baseUrl]];
    [_sharedHTTPClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"-------AFNetworkReachabilityStatusReachableViaWWAN------");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"-------AFNetworkReachabilityStatusReachableViaWiFi------");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"-------AFNetworkReachabilityStatusNotReachable------");
                break;
            default:
                break;
        }
    }];
    [_sharedHTTPClient.reachabilityManager startMonitoring];
}
-(BOOL)isReachable{
   // BOOL isReachable=_sharedHTTPClient.reachabilityManager.reachable;
   // DLog(@"reache %d",isReachable);
    return _sharedHTTPClient.reachabilityManager.reachable;

}
-(instancetype)initWithBaseURL:(nullable NSURL *)url{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
   
   // [self.requestSerializer setAuthorizationHeaderFieldWithUsername:@"XYZ" password:@"xyzzzz"];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
     self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.requestSerializer.timeoutInterval = 10.0;
   //self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    
    securityPolicy.validatesDomainName = NO;
    self.securityPolicy = securityPolicy;
    return self;
}


@end

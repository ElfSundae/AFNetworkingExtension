//
//  AFHTTPRequestSerializer+AFNEExtension.m
//  AFNetworkExtension
//
//  Created by Elf Sundae on 2019/06/18.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "AFHTTPRequestSerializer+AFNEExtension.h"
#import <objc/runtime.h>
#import <ESFramework/ESFramework.h>

static const void *URLQueryParametersBlockKey = &URLQueryParametersBlockKey;
static const void *HTTPRequestHeadersBlockKey = &HTTPRequestHeadersBlockKey;

@implementation AFHTTPRequestSerializer (AFNEExtension)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ESSwizzleInstanceMethod(self, @selector(requestWithMethod:URLString:parameters:error:), @selector(afne_requestWithMethod:URLString:parameters:error:));
    });
}

- (AFURLQueryParametersBlock)URLQueryParametersBlock
{
    return objc_getAssociatedObject(self, URLQueryParametersBlockKey);
}

- (void)setURLQueryParametersBlock:(AFURLQueryParametersBlock)block
{
    objc_setAssociatedObject(self, URLQueryParametersBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (AFHTTPRequestHeadersBlock)HTTPRequestHeadersBlock
{
    return objc_getAssociatedObject(self, HTTPRequestHeadersBlockKey);
}

- (void)setHTTPRequestHeadersBlock:(AFHTTPRequestHeadersBlock)block
{
    objc_setAssociatedObject(self, HTTPRequestHeadersBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableURLRequest *)afne_requestWithMethod:(NSString *)method
                                      URLString:(NSString *)URLString
                                     parameters:(id)parameters
                                          error:(NSError *__autoreleasing *)error
{
    if (self.URLQueryParametersBlock) {
        NSDictionary *query = self.URLQueryParametersBlock(method, URLString, parameters);
        if (query) {
            URLString = [URLString stringByAddingURLQueryParameters:query];
        }
    }

    NSMutableURLRequest *request = [self afne_requestWithMethod:method URLString:URLString parameters:parameters error:error];

    if (request) {
        if (self.HTTPRequestHeadersBlock) {
            NSDictionary *headers = self.HTTPRequestHeadersBlock(request, parameters);
            for (NSString *key in headers) {
                [request setValue:ESStringValue(headers[key]) forHTTPHeaderField:key];
            }
        }
    }

    return request;
}

@end

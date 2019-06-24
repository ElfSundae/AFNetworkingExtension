//
//  AFHTTPSessionManager+ESExtension.m
//  AFNetworkingExtension
//
//  Created by Elf Sundae on 2019/06/24.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import "AFHTTPSessionManager+ESExtension.h"

static BOOL ESIsURLMatchesURL(NSURL *URL, NSURL *matchURL)
{
    if ([URL.host compare:matchURL.host options:NSCaseInsensitiveSearch] != NSOrderedSame) {
        return NO;
    }

    NSString *matchPath = matchURL.path;
    if ([matchPath hasSuffix:@"*"]) {
        NSString *matchPrefix = [matchPath substringToIndex:matchPath.length - 1];
        return [URL.path.lowercaseString hasPrefix:matchPrefix.lowercaseString];
    } else {
        return [URL.path compare:matchPath options:NSCaseInsensitiveSearch] == NSOrderedSame;
    }
}

@implementation AFHTTPSessionManager (ESExtension)

- (NSURL *)fullURL:(NSString *)path
{
    return [NSURL URLWithString:path relativeToURL:self.baseURL];
}

- (NSArray<NSURLSessionTask *> *)tasksWithURL:(NSString *)URLString method:(nullable NSString *)method
{
    NSURL *url = [self fullURL:URLString];
    method = [method uppercaseString];

    NSMutableArray *tasks = [NSMutableArray array];

    for (NSURLSessionTask *task in self.tasks) {
        NSURLRequest *request = task.originalRequest;
        if ((!method || [request.HTTPMethod isEqualToString:method]) &&
            ESIsURLMatchesURL(request.URL, url)) {
            [tasks addObject:task];
        }
    }

    return [tasks copy];
}

@end

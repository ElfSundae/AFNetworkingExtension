//
//  AFNetworkActivityLogger+AFNEExtension.h
//  AFNetworkExtension
//
//  Created by Elf Sundae on 2019/06/18.
//  Copyright © 2019 https://0x123.com. All rights reserved.
//

#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import <AFNetworking/AFHTTPSessionManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFNetworkActivityLogger (AFNEExtension)

/**
 * Toggles logging, indicates whether the logger is enabled or not.
 */
@property (nonatomic, getter = isEnabled) BOOL enabled;

@end

@interface AFHTTPSessionManager (AFNEActivityLogger)

/**
 * The network activity logger instance.
 */
@property (null_resettable, nonatomic, strong) AFNetworkActivityLogger *logger;

@end

NS_ASSUME_NONNULL_END

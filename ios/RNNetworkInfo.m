//
//  RNNetworkInfo.m
//  RNNetworkInfo
//
//  Created by Corey Wilson on 7/12/15.
//  Copyright (c) 2015 eastcodes. All rights reserved.
//

#import "RNNetworkInfo.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

@import SystemConfiguration.CaptiveNetwork;

@implementation RNNetworkInfo

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getSSID:(RCTResponseSenderBlock)callback)
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    NSString *SSID = @"error";
    
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        
        if (SSIDInfo.count > 0) {
            SSID = SSIDInfo[@"SSID"];
            break;
        }
    }
    
    callback(@[SSID]);
}

RCT_EXPORT_METHOD(getIPAddress:(RCTResponseSenderBlock)callback)
{
    NSString *address = @"error";
    
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    callback(@[address]);
}

@end


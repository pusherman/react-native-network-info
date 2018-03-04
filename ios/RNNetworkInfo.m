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
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@import SystemConfiguration.CaptiveNetwork;

@implementation RNNetworkInfo

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(getSSID:(RCTResponseSenderBlock)callback)
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());

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

RCT_EXPORT_METHOD(getBSSID:(RCTResponseSenderBlock)callback)
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    NSString *BSSID = @"error";

    for (NSString* interface in interfaceNames)
    {
        CFDictionaryRef networkDetails = CNCopyCurrentNetworkInfo((CFStringRef) interface);
        if (networkDetails)
        {
            BSSID = (NSString *)CFDictionaryGetValue (networkDetails, kCNNetworkInfoKeyBSSID);
            CFRelease(networkDetails);
        }
    }

    callback(@[BSSID]);
}

RCT_EXPORT_METHOD(getBroadcast:(RCTResponseSenderBlock)callback)
{
    NSString *address = @"error";
    NSString *netmask = @"error";

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
                    netmask = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];

                    struct in_addr local_addr;
                    struct in_addr netmask_addr;
                    inet_aton([address UTF8String], &local_addr);
                    inet_aton([netmask UTF8String], &netmask_addr);

                    local_addr.s_addr |= ~(netmask_addr.s_addr);

                    address = [NSString stringWithUTF8String:inet_ntoa(local_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }

    freeifaddrs(interfaces);
    callback(@[address]);
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

    RCT_EXPORT_METHOD(getIPV4Address:(RCTResponseSenderBlock)callback)
    {
        NSArray *searchArray = @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv4 ];
        NSDictionary *addresses = [self getAllIPAddresses];
        NSLog(@"addresses: %@", addresses);
        
        __block NSString *address;
        [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
         {
             address = addresses[key];
             if(address) *stop = YES;
         } ];
        NSString *addressToReturn = address ? address : @"0.0.0.0";
        callback(@[addressToReturn]);
    }
    
- (NSDictionary *)getAllIPAddresses
    {
        NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
        
        // retrieve the current interfaces - returns 0 on success
        struct ifaddrs *interfaces;
        if(!getifaddrs(&interfaces)) {
            // Loop through linked list of interfaces
            struct ifaddrs *interface;
            for(interface=interfaces; interface; interface=interface->ifa_next) {
                if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                    continue; // deeply nested code harder to read
                }
                const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
                char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
                if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                    NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                    NSString *type;
                    if(addr->sin_family == AF_INET) {
                        if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                            type = IP_ADDR_IPv4;
                        }
                    } else {
                        const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                        if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                            type = IP_ADDR_IPv6;
                        }
                    }
                    if(type) {
                        NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                        addresses[key] = [NSString stringWithUTF8String:addrBuf];
                    }
                }
            }
            // Free memory
            freeifaddrs(interfaces);
        }
        return [addresses count] ? addresses : nil;
    }

@end


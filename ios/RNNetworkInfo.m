//
//  RNNetworkInfo.m
//  RNNetworkInfo
//
//  Created by Corey Wilson on 7/12/15.
//  Copyright (c) 2015 eastcodes. All rights reserved.
//

#import "RNNetworkInfo.h"
#import "getgateway.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#include <net/if.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <TargetConditionals.h>
#import <NetworkExtension/NetworkExtension.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@import SystemConfiguration.CaptiveNetwork;

@implementation RNNetworkInfo

RCT_EXPORT_MODULE();

#if TARGET_OS_IOS
RCT_EXPORT_METHOD(getSSID:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 14.0, *)) {
        [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(NEHotspotNetwork * _Nullable currentNetwork) {
            resolve(currentNetwork.SSID);
        }];
        return;
    }

    @try{
        NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
        
        NSDictionary *SSIDInfo;
        NSString *SSID = NULL;
        
        for (NSString *interfaceName in interfaceNames) {
            SSIDInfo = CFBridgingRelease(CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
            
            if (SSIDInfo.count > 0) {
                SSID = SSIDInfo[@"SSID"];
                break;
            }
        }
        
        if (SSID == NULL) {
            NSException* exception = [NSException
                                      exceptionWithName:@"SSIDNotFoundException"
                                      reason:@"SSID Not Found"
                                      userInfo:nil];
            @throw exception;
        }
        resolve(SSID);
    }@catch (NSException *exception) {
        reject(exception);
    }
}
#endif

#if TARGET_OS_IOS
RCT_EXPORT_METHOD(getBSSID:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    if (@available(iOS 14.0, *)) {
        [NEHotspotNetwork fetchCurrentWithCompletionHandler:^(NEHotspotNetwork * _Nullable currentNetwork) {
            resolve(currentNetwork.BSSID);
        }];
        return;
    }

    @try{
        NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
        NSString *BSSID = NULL;
        
        for (NSString* interface in interfaceNames)
        {
            CFDictionaryRef networkDetails = CNCopyCurrentNetworkInfo((CFStringRef) interface);
            if (networkDetails)
            {
                BSSID = (NSString *)CFDictionaryGetValue (networkDetails, kCNNetworkInfoKeyBSSID);
                CFRelease(networkDetails);
            }
        }
        
        if (BSSID == NULL) {
            NSException* exception = [NSException
                                      exceptionWithName:@"BSSIDNotFoundException"
                                      reason:@"BSSID Not Found"
                                      userInfo:nil];
            @throw exception;
        }
        resolve(BSSID);
    }@catch (NSException *exception) {
        reject(exception);
    }
}
#endif

RCT_EXPORT_METHOD(getBroadcast:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

{
    @try{
        NSString *address = NULL;
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
        } else {
            freeifaddrs(interfaces);

            NSException* exception = [NSException
                                      exceptionWithName:@"BroadcastNotFoundException"
                                      reason:@"getifaddrs has been Not successful"
                                      userInfo:nil];
            @throw exception;
        }

        freeifaddrs(interfaces);

        if (address == NULL) {
            NSException* exception = [NSException
                                      exceptionWithName:@"BroadcastNotFoundException"
                                      reason:@"Broadcast Not Found"
                                      userInfo:nil];
            @throw exception;
        }
        resolve(address);
    }@catch (NSException *exception) {
        reject(exception);
    }
}

RCT_EXPORT_METHOD(getIPAddress:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    @try {
        NSString *address = NULL;
        
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
        } else {
            freeifaddrs(interfaces);

            NSException* exception = [NSException
                                      exceptionWithName:@"IPAddressNotFoundException"
                                      reason:@"getifaddrs has been Not successful"
                                      userInfo:nil];
            @throw exception;
        }
        freeifaddrs(interfaces);
        
        if (address == NULL) {
            NSException* exception = [NSException
                                      exceptionWithName:@"IPAddressNotFoundException"
                                      reason:@"IPAddress Not Found"
                                      userInfo:nil];
            @throw exception;
        }

        resolve(address);
    }@catch (NSException *exception) {
        reject(exception);
    }
}

RCT_EXPORT_METHOD(getGatewayIPAddress:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    @try{
        NSString *ipString = nil;
        struct in_addr gatewayaddr;
        int r = getdefaultgateway(&(gatewayaddr.s_addr));
        if(r >= 0) {
            ipString = [NSString stringWithFormat: @"%s",inet_ntoa(gatewayaddr)];
    	}
        resolve(ipString);
    }@catch (NSException *exception) {
        reject(exception);
    }
}

RCT_EXPORT_METHOD(getIPV4Address:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    @try{
        NSArray *searchArray = @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv4 ];
        NSDictionary *addresses = [self getAllIPAddresses];
        NSLog(@"addresses: %@", addresses);
        
        __block NSString *address;
        [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
         {
             address = addresses[key];
             if(address) *stop = YES;
         } ];
        
        if (address) {
            resolve(address);
        }
            NSException* exception = [NSException
                                      exceptionWithName:@"IPV4AddressNotFoundException"
                                      reason:@"IPV4Address Not Found"
                                      userInfo:nil];
            @throw exception;
        }
    }@catch (NSException *exception) {
        reject(exception);
    }
}

/**
    Gets the device's WiFi interface IP address
    @return device's WiFi IP if connected to WiFi, else '0.0.0.0'
*/
RCT_EXPORT_METHOD(getWIFIIPV4Address:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    @try{
        NSArray *searchArray = @[ IOS_WIFI @"/" IP_ADDR_IPv4 ];
        NSDictionary *addresses = [self getAllIPAddresses];
        NSLog(@"addresses: %@", addresses);

        __block NSString *address;
        [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
         {
             address = addresses[key];
             if(address) *stop = YES;
         } ];
         if(address){
            resolve(address);
         } else {
            NSException* exception = [NSException
                                      exceptionWithName:@"WIFIIPV4AddressNotFoundException"
                                      reason:@"WIFIIPV4Address Not Found"
                                      userInfo:nil];
            @throw exception;
         }
    }@catch (NSException *exception) {
        reject(exception);
    }
}

RCT_EXPORT_METHOD(getSubnet:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    @try {
        NSString *netmask = NULL;
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        
        int success = 0;
        
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0)
        {
            temp_addr = interfaces;
            
            while(temp_addr != NULL)
            {
                // check if interface is en0 which is the wifi connection on the iPhone
                if(temp_addr->ifa_addr->sa_family == AF_INET)
                {
                    if([@(temp_addr->ifa_name) isEqualToString:@"en0"])
                    {
                        netmask = @(inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr));
                    }
                }
                
                temp_addr = temp_addr->ifa_next;
            }
        }
        freeifaddrs(interfaces);

        if (netmask == NULL) {
            NSException* exception = [NSException
                                      exceptionWithName:@"IPV4AddressNotFoundException"
                                      reason:@"IPV4Address Not Found"
                                      userInfo:nil];
            @throw exception;
        }

        resolve(netmask);
    } @catch (NSException *exception) {
        reject(exception);
    }
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


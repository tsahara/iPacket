//
//  util.m
//  iPacket
//
//  Created by Tomoyuki Sahara on 9/16/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Darwin.POSIX.net;
@import Darwin.POSIX.ioctl;

#include <sys/socket.h>
#include <net/bpf.h>
#include <ifaddrs.h>

#include <pcap/pcap.h>

#include <string.h>


const char *default_interface(void)
{
    struct ifaddrs *ifa, *ifa0;
    static char ifname[20];
   
    ifname[0] = '\0';
    (void)getifaddrs(&ifa0);
    for (ifa = ifa0; ifa != NULL; ifa = ifa->ifa_next) {
        if (ifa->ifa_addr->sa_family == AF_INET) {
            strlcpy(ifname, ifa->ifa_name, sizeof(ifname));
            break;
        }
    }
    freeifaddrs(ifa0);
    return ifname;
}

int bpf_setup(int fd, const char *ifname)
{
    struct ifreq ifr;
    unsigned int k;

    if (ifname == NULL)
        ifname = default_interface();
    
    k = 2000;
    if (ioctl(fd, BIOCSBLEN, &k) == -1)
        return -1;

    memset(&ifr, 0, sizeof(ifr));
    strncpy(ifr.ifr_name, ifname, sizeof(ifr.ifr_name));
    if (ioctl(fd, BIOCSETIF, &ifr) == -1)
        return -2;
    
    k = 1;
    if (ioctl(fd, BIOCIMMEDIATE, &k) == -1)
        return -3;
    
    k = 1;
    if (ioctl(fd, BIOCSHDRCMPLT, &k) == -1)
        return -4;
    
    if (ioctl(fd, BIOCPROMISC) == -1)
        return -5;
    
    return 0;
}

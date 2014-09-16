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

#include <net/bpf.h>
#include <string.h>


int bpf_setup(int fd, const char *ifname)
{
    struct ifreq ifr;
    unsigned int k;

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
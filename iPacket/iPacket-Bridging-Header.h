//
//  Header.h
//  iPacket
//
//  Created by Tomoyuki Sahara on 8/12/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

#ifndef iPacket_Header_h
#define iPacket_Header_h

#include "net/bpf.h"
#include "pcap/bpf.h"
#include "pcap/pcap.h"

int bpf_setup(int fd, const char *ifname);

#endif

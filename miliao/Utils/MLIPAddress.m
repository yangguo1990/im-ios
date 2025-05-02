//
//  MLIPAddress.m
//  miliao
//
//  Created by apple on 2022/9/20.
//

#import "MLIPAddress.h"

#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

//#include <ifaddrs.h>
//#include <arpa/inet.h>
//#include <net/if.h>
// #define IOS_CELLULAR    @"pdp_ip0"//有些分配的地址为en0 有些分配的en1
//#define IOS_WIFI2       @"en2"
//#define IOS_WIFI1       @"en1"
//#define IOS_WIFI        @"en0"//
//#define IOS_VPN       @"utun0"  vpn很少用到可以注释
//#define IP_ADDR_IPv4    @"ipv4"
//#define IP_ADDR_IPv6    @"ipv6"

@implementation MLIPAddress

+ (NSString *)getIPAddress {

    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);


    NSMutableArray *ips = [NSMutableArray array];

    int BUFFERSIZE = 4096;

    struct ifconf ifc;

    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;

    struct ifreq *ifr, ifrcopy;

    ifc.ifc_len = BUFFERSIZE;

    ifc.ifc_buf = buffer;

    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0) {

        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ) {

            ifr = (struct ifreq *)ptr;

            int len = sizeof(struct sockaddr);

            if (ifr->ifr_addr.sa_len > len) {

                len = ifr->ifr_addr.sa_len;
            }

            ptr += sizeof(ifr->ifr_name) + len;

            if (ifr->ifr_addr.sa_family != AF_INET) continue;

            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr = 0;

            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)continue;

            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);

            ifrcopy = *ifr;

            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);

            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;

            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];

            [ips addObject:ip];
        }

    }

    close(sockfd);

    NSString *deviceIP = @"";
    for (int i = 0; i < ips.count; i++) {
        if(ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@", ips.lastObject];
        }
    }

    return deviceIP;
}

@end

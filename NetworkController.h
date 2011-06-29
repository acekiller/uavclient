//
//  NetworkController.h
//  Socket
//
//  Created by visu4l on 11. 6. 28..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>




@interface NetworkController : NSObject {

    char* ip;    
    int port;
    
    int sockfd;
}

@property char* ip;
@property int port;
@property int sockfd;


-(Boolean) createSock;
-(void) closeSock;

-(void) recvRoutine;
-(void) sendPacket;

@end

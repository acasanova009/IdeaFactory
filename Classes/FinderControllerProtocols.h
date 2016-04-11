//
//  FinderControllerProtocols.h
//  Table
//
//  Created by Renato Casanova on 6/20/13.
//  Copyright (c) 2013 Renato Casanova. All rights reserved.
//

#import <Foundation/Foundation.h>//Archive Protocol
@protocol FinderArchiveReferenceProtocol <NSObject>

-(void)finderControllerWantsToCreateNewArchiveReference:(NSString*)reference;
-(void)finderControllerWantsToDeleteArchiveReferences:(NSArray*)indexPaths;
//-(void)finderControllerMovedArchiveFrom:(NSIndexPath*)fromPath ToIndexPath:(NSIndexPath*)toIndexPath;

@end

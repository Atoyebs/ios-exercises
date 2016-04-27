//
//  BLCDataSource.h
//  Blocstagram
//
//  Created by Inioluwa Work Account on 21/04/2016.
//  Copyright © 2016 bloc. All rights reserved.
//

@class BLCMedia;

#import <Foundation/Foundation.h>

@interface BLCDataSource : NSObject

+(instancetype)sharedInstance;

-(void)removeObjectAtIndex:(NSInteger)index;

-(void)deleteMediaItem:(BLCMedia *)item;

@property (nonatomic, strong, readonly) NSArray *mediaItems;



@end

//
//  BLCDataSource.m
//  Blocstagram
//
//  Created by Inioluwa Work Account on 21/04/2016.
//  Copyright © 2016 bloc. All rights reserved.
//

#import "BLCDataSource.h"

#import "BLCUser.h"
#import "BLCMedia.h"
#import "BLCComment.h"


@interface BLCDataSource() {
    
    NSMutableArray *_mediaItems;
    
}

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, assign) BOOL isLoadingOlderItems;

@end



@implementation BLCDataSource

#pragma mark - Class Constructors

+ (instancetype) sharedInstance {
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype) init {
    self = [super init];
    
    if (self) {
        [self addRandomData];
    }
    
    return self;
}


#pragma mark - Funcitons Using Random

- (void) addRandomData {
    
    NSMutableArray *randomMediaItems = [NSMutableArray array];
    
    for (int i = 0  ; i <= 10; i++) {
        
        NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
        UIImage *image = [UIImage imageNamed:imageName];
        
        if (image) {
            
            BLCMedia *media = [[BLCMedia alloc] init];
            media.user = [self randomUser];
            media.image = image;
            
            NSUInteger commentCount = arc4random_uniform(10);
            NSMutableArray *randomComments = [NSMutableArray array];
            
            for (int i  = 0; i <= commentCount; i++) {
                BLCComment *randomComment = [self randomComment];
                [randomComments addObject:randomComment];
            }
            
            media.comments = randomComments;
            
            [randomMediaItems addObject:media];
        }
    }
    
    _mediaItems = randomMediaItems;
}

- (BLCUser *) randomUser {
    
    BLCUser *user = [[BLCUser alloc] init];
    
    user.userName = [self randomStringOfLength:arc4random_uniform(10)];
    
    NSString *firstName = [self randomStringOfLength:arc4random_uniform(7)];
    NSString *lastName = [self randomStringOfLength:arc4random_uniform(12)];
    user.fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    return user;
}

- (BLCComment *) randomComment {
    
    BLCComment *comment = [[BLCComment alloc] init];
    
    comment.from = [self randomUser];
    
    NSUInteger wordCount = arc4random_uniform(20);
    
    NSMutableString *randomSentence = [[NSMutableString alloc] init];
    
    for (int i  = 0; i <= wordCount; i++) {
        NSString *randomWord = [self randomStringOfLength:arc4random_uniform(12)];
        [randomSentence appendFormat:@"%@ ", randomWord];
    }
    
    comment.text = randomSentence;
    
    return comment;
}

- (NSString *) randomStringOfLength:(NSUInteger) len {
    
    NSString *alphabet = @"abcdefghijklmnopqrstuvwxyz";
    
    NSMutableString *s = [NSMutableString string];
    for (NSUInteger i = 0U; i < len; i++) {
        u_int32_t r = arc4random_uniform((u_int32_t)[alphabet length]);
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return [NSString stringWithString:s];
}


- (NSString*)randomSentenceWithMaximumNumberOfWords:(NSUInteger)maximumNumberOfWords {

    NSMutableString *sentence = [NSMutableString new];
    static int minimumNumberOfWords = 2;
    static int minimumNumberOfLettersInWord = 3;
    int numberOfWords = arc4random_uniform(maximumNumberOfWords - minimumNumberOfWords) + minimumNumberOfWords;
    int numberOfLetters = 0;
    
    for (int i = 0; i < numberOfWords; i++) {
        
        //generate the number of letters this string is going to have for this iteration
        numberOfLetters = arc4random_uniform(maximumNumberOfWords - minimumNumberOfLettersInWord) + minimumNumberOfLettersInWord;
        [sentence appendString:[self randomStringOfLength:numberOfLetters]];
        
        if (i != (numberOfWords -1)) {
            [sentence appendString:@" "];
        }
    }
    
    return sentence;
}


+ (NSString *) getRandomImageWithNameAsNumberBetween:(int)from to:(int)upperBound withExtension:(NSString*)ext {
    
    int randomNumberGenerated = arc4random_uniform(upperBound) + from;
    
    NSString *generatedImageName = [NSString stringWithFormat:@"%d.%@", randomNumberGenerated, ext];
    
    return generatedImageName;
}


#pragma mark - Data Source (Accessor) Utitlity Methods

- (NSUInteger) countOfMediaItems {
    return self.mediaItems.count;
}

- (id) objectInMediaItemsAtIndex:(NSUInteger)index {
    return [self.mediaItems objectAtIndex:index];
}

- (NSArray *) mediaItemsAtIndexes:(NSIndexSet *)indexes {
    return [self.mediaItems objectsAtIndexes:indexes];
}

- (void)deleteMediaItem:(BLCMedia *)item {
    
    NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
    [mutableArrayWithKVO removeObject:item];
}

- (void) insertObject:(BLCMedia *)object inMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems insertObject:object atIndex:index];
}

- (void) removeObjectFromMediaItemsAtIndex:(NSUInteger)index {
    [_mediaItems removeObjectAtIndex:index];
}

- (void) replaceObjectInMediaItemsAtIndex:(NSUInteger)index withObject:(id)object {
    [_mediaItems replaceObjectAtIndex:index withObject:object];
}


#pragma mark - Completion Handlers

-(void)requestNewItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler {
    
    if (self.isRefreshing == NO) {
        
        self.isRefreshing = YES;
        BLCMedia *media = [[BLCMedia alloc] init];
        media.user = [self randomUser];
        NSString *randomImageName = [BLCDataSource getRandomImageWithNameAsNumberBetween:0 to:10 withExtension:@"jpg"];
        media.image = [UIImage imageNamed:randomImageName];
        media.caption = [self randomSentenceWithMaximumNumberOfWords:7];
        
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
        [mutableArrayWithKVO insertObject:media atIndex:0];
        
        self.isRefreshing = NO;
        
        if (completionHandler) {
            completionHandler(nil);
        }
    }
    
}

- (void) requestOldItemsWithCompletionHandler:(BLCNewItemCompletionBlock)completionHandler {
    
    if (self.isLoadingOlderItems == NO) {
        
        self.isLoadingOlderItems = YES;
        BLCMedia *media = [[BLCMedia alloc] init];
        media.user = [self randomUser];
        NSString *randomImageName = [BLCDataSource getRandomImageWithNameAsNumberBetween:0 to:10 withExtension:@"jpg"];
        media.image = [UIImage imageNamed:randomImageName];
        media.caption = [self randomSentenceWithMaximumNumberOfWords:7];
        
        NSMutableArray *mutableArrayWithKVO = [self mutableArrayValueForKey:@"mediaItems"];
        [mutableArrayWithKVO addObject:media];
        
        self.isLoadingOlderItems = NO;
        
        if (completionHandler) {
            completionHandler(nil);
        }
    }
}

@end

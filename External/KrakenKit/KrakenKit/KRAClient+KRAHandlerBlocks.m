//
//  KRAClient+KRAHandlerBlocks.m
//  KrakenKit
//
//  Created by Robert Widmann on 4/30/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "KRAClient+KRAHandlerBlocks.h"
#import <Mantle/Mantle.h>

@implementation KRAClient (KRAHandlerBlocks)

- (AFNetworkingSuccessBlock)successHandlerForClientHandler:(KRAClientCompletionBlock)handler unboxBlock:(id (^)(id, NSError *__autoreleasing *))unboxBlock {
	return ^(AFHTTPRequestOperation *operation, id responseJSON) {
		id finalObject = responseJSON;
		NSError *error = nil;
		
		if (unboxBlock) {
			finalObject = unboxBlock(responseJSON, &error);
		}
		
		if (handler) {
			handler(finalObject, error);
		}
	};
}

- (AFNetworkingSuccessBlock)successHandlerForResourceClass:(Class)resourceClass clientHandler:(KRAClientCompletionBlock)handler {
	return [self successHandlerForClientHandler:handler unboxBlock:^id(id responseJSON, NSError *__autoreleasing *error) {
		id unboxedObject = nil;
		if ([resourceClass isSubclassOfClass:MTLModel.class]) {
			unboxedObject = [resourceClass modelWithDictionary:responseJSON error:nil];
		}
		return unboxedObject;
	}];
}

- (NSArray *)kra_unpackResponseArray:(id)responseJSON withModelClass:(Class)resourceClass {
	id unboxedObject = nil;
	if ([resourceClass isSubclassOfClass:MTLModel.class]) {
		NSValueTransformer *arrayTransformer = [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:resourceClass];
		unboxedObject = [arrayTransformer transformedValue:responseJSON];
	}
	return unboxedObject;
}

- (AFNetworkingSuccessBlock)successHandlerForArrayOfModelClass:(Class)resourceClass clientHandler:(KRAClientCompletionBlock)handler {
	return [self successHandlerForClientHandler:handler unboxBlock:^id(id arrayResponse, NSError *__autoreleasing *error) {
		return [self kra_unpackResponseArray:arrayResponse withModelClass:resourceClass];
	}];
}


@end

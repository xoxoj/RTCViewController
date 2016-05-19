// switch statement for strings
#define SWITCH(object, value) NSMutableDictionary *swtch = [object mutableCopy]; [swtch setObject:^{} forKey:@""]; ((dispatch_block_t)(swtch[value]?swtch[value]:(swtch[@"default"]?swtch[@"default"]:swtch[@""])))();

// easier thread IDs
#define MAIN dispatch_get_main_queue()
#define HIGH dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
#define LOW dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
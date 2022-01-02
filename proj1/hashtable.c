#include "hashtable.h"
#include <stdlib.h>

/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *)) {
  int i = 0;
  HashTable *newTable = malloc(sizeof(HashTable));
  newTable->size = size;
  newTable->data = malloc(sizeof(struct HashBucket *) * size);
  for (i = 0; i < size; ++i) {
    newTable->data[i] = NULL;
  }
  newTable->hashFunction = hashFunction;
  newTable->equalFunction = equalFunction;
  return newTable;
}

/*
 * This inserts a key/data pair into a hash table.  To use this
 * to store strings, simply cast the char * to a void * (e.g., to store
 * the string referred to by the declaration char *string, you would
 * call insertData(someHashTable, (void *) string, (void *) string).
 * Because we only need a set data structure for this spell checker,
 * we can use the string as both the key and data.
 */
void insertData(HashTable *table, void *key, void *data) {
  // HINT:
  // 1. Find the right hash bucket location with table->hashFunction.
  // 2. Allocate a new hash bucket struct.
  // 3. Append to the linked list or create it if it does not yet exist.
  unsigned int (* hashFunction)(void *) = table->hashFunction;
  int index= (*hashFunction)(key);

 struct HashBucket *bucket = malloc(sizeof(struct HashBucket *));

  if (table->data[index] == NULL) {
    bucket->key = key;
    bucket->data = data;
    bucket->next = NULL;    
    table->data[index] = bucket;
    return;
  }

  bucket->key = key;
  bucket->data = data;
  bucket->next = table->data[index];
  table->data[index] = bucket;
}

/*
 * This returns the corresponding data for a given key.
 * It returns NULL if the key is not found. 
 */
void *findData(HashTable *table, void *key) {
  // 1. Find the right hash bucket with table->hashFunction.
  unsigned int (* hashFunction)(void *) = table->hashFunction;
  int index = (*hashFunction)(key);
  struct HashBucket *bucket = table->data[index];

  // 2. Walk the linked list and check for equality with table->equalFunction.
  int (*equalFunction)(void *, void *) = table->equalFunction;
  while (bucket != NULL && !equalFunction(key,bucket->key)) {
    bucket = bucket->next;  	  
  }

  if ( bucket == NULL) {
    return NULL;
  }

  return bucket->data;
}

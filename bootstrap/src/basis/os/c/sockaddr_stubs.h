#pragma once

#include <netinet/in.h>
#include <sys/un.h>
#include <caml/mlvalues.h>

/* Layout of the C-heap buffer pointed to by a Sockaddr.t custom block.
 * Using a flexible array so the sockaddr bytes follow the length field
 * contiguously, avoiding a second allocation. */
struct hemlock_sockaddr {
    socklen_t len;
    char      data[];
};

struct hemlock_sockaddr *hemlock__c__sockaddr__of_value(value v);

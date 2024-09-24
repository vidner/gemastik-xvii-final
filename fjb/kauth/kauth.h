#pragma once

#include <stddef.h>

struct kauth_user {
  const char name[128];
  unsigned long long id;
  unsigned long long exp;
};

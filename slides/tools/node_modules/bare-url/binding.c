#include <assert.h>
#include <bare.h>
#include <js.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <url.h>
#include <url/character-set.h>
#include <url/percent-encode.h>
#include <utf.h>
#include <utf/string.h>

// https://url.spec.whatwg.org/#concept-urlencoded-byte-serializer
//
// Everything except ASCII alphanumerics and `*-._` is percent-encoded. A space
// (0x20) is a special case, encoded as `+` rather than `%20`, so it is left out
// of the set and handled separately below.
static url_character_set_t bare_url__form_urlencoded_percent_encode_set = {
  // 00    01     02     03     04     05     06     07
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 08    09     0a     0b     0c     0d     0e     0f
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 10    11     12     13     14     15     16     17
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 18    19     1a     1b     1c     1d     1e     1f
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 20    21     22     23     24     25     26     27
  0x00 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 28    29     2a     2b     2c     2d     2e     2f
  0x01 | 0x02 | 0x00 | 0x08 | 0x10 | 0x00 | 0x00 | 0x80,
  // 30    31     32     33     34     35     36     37
  0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00,
  // 38    39     3a     3b     3c     3d     3e     3f
  0x00 | 0x00 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 40    41     42     43     44     45     46     47
  0x01 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00,
  // 48    49     4a     4b     4c     4d     4e     4f
  0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00,
  // 50    51     52     53     54     55     56     57
  0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00,
  // 58    59     5a     5b     5c     5d     5e     5f
  0x00 | 0x00 | 0x00 | 0x08 | 0x10 | 0x20 | 0x40 | 0x00,
  // 60    61     62     63     64     65     66     67
  0x01 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00,
  // 68    69     6a     6b     6c     6d     6e     6f
  0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00,
  // 70    71     72     73     74     75     76     77
  0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00 | 0x00,
  // 78    79     7a     7b     7c     7d     7e     7f
  0x00 | 0x00 | 0x00 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 80    81     82     83     84     85     86     87
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 88    89     8a     8b     8c     8d     8e     8f
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 90    91     92     93     94     95     96     97
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // 98    99     9a     9b     9c     9d     9e     9f
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // a0    a1     a2     a3     a4     a5     a6     a7
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // a8    a9     aa     ab     ac     ad     ae     af
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // b0    b1     b2     b3     b4     b5     b6     b7
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // b8    b9     ba     bb     bc     bd     be     bf
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // c0    c1     c2     c3     c4     c5     c6     c7
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // c8    c9     ca     cb     cc     cd     ce     cf
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // d0    d1     d2     d3     d4     d5     d6     d7
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // d8    d9     da     db     dc     dd     de     df
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // e0    e1     e2     e3     e4     e5     e6     e7
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // e8    e9     ea     eb     ec     ed     ee     ef
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // f0    f1     f2     f3     f4     f5     f6     f7
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
  // f8    f9     fa     fb     fc     fd     fe     ff
  0x01 | 0x02 | 0x04 | 0x08 | 0x10 | 0x20 | 0x40 | 0x80,
};

// https://url.spec.whatwg.org/#concept-urlencoded-serializer
static void
bare_url__serialize_form_urlencoded_component(js_env_t *env, js_value_t *value, utf8_string_t *result) {
  int err;

  size_t len;
  err = js_get_value_string_utf8(env, value, NULL, 0, &len);
  assert(err == 0);

  utf8_t *input = malloc(len);
  err = js_get_value_string_utf8(env, value, input, len, NULL);
  assert(err == 0);

  for (size_t i = 0; i < len; i++) {
    utf8_t c = input[i];

    if (c == 0x20 /* space */) {
      err = utf8_string_append_character(result, '+');
    } else {
      err = url__percent_encode_character(c, bare_url__form_urlencoded_percent_encode_set, result);
    }

    assert(err == 0);
  }

  free(input);
}

static js_value_t *
bare_url_parse(js_env_t *env, js_callback_info_t *info) {
  int err;

  size_t argc = 4;
  js_value_t *argv[4];

  err = js_get_callback_info(env, info, &argc, argv, NULL, NULL);
  assert(err == 0);

  assert(argc == 4);

  bool should_throw;
  err = js_get_value_bool(env, argv[3], &should_throw);
  assert(err == 0);

  bool has_base;
  err = js_is_string(env, argv[1], &has_base);
  assert(err == 0);

  url_t base;
  url_init(&base);

  if (has_base) {
    size_t len;
    err = js_get_value_string_utf8(env, argv[1], NULL, 0, &len);
    assert(err == 0);

    utf8_t *input = malloc(len);
    err = js_get_value_string_utf8(env, argv[1], input, len, NULL);
    assert(err == 0);

    err = url_parse(&base, input, len, NULL);

    free(input);

    if (err < 0) {
      url_destroy(&base);

      if (should_throw) js_throw_error(env, NULL, "Invalid base URL");

      return NULL;
    }
  }

  size_t len;
  err = js_get_value_string_utf8(env, argv[0], NULL, 0, &len);
  assert(err == 0);

  utf8_t *input = malloc(len);
  err = js_get_value_string_utf8(env, argv[0], input, len, NULL);
  assert(err == 0);

  js_value_t *handle;

  url_t url;
  url_init(&url);

  err = url_parse(&url, input, len, has_base ? &base : NULL);

  free(input);

  if (err < 0) {
    url_destroy(&base);
    url_destroy(&url);

    if (should_throw) js_throw_error(env, NULL, "Invalid URL");

    return NULL;
  }

  js_value_t *href;
  err = js_create_string_utf8(env, url.href.data, url.href.len, &href);
  assert(err == 0);

  uint32_t *components;
  err = js_get_typedarray_info(env, argv[2], NULL, (void **) &components, NULL, NULL, NULL);
  assert(err == 0);

  memcpy(components, &url.components, sizeof(url.components));

  url_destroy(&base);
  url_destroy(&url);

  return href;
}

static js_value_t *
bare_url_can_parse(js_env_t *env, js_callback_info_t *info) {
  int err;

  size_t argc = 2;
  js_value_t *argv[2];

  err = js_get_callback_info(env, info, &argc, argv, NULL, NULL);
  assert(err == 0);

  assert(argc == 2);

  bool has_base;
  err = js_is_string(env, argv[1], &has_base);
  assert(err == 0);

  url_t base;
  url_init(&base);

  if (has_base) {
    size_t len;
    err = js_get_value_string_utf8(env, argv[1], NULL, 0, &len);
    assert(err == 0);

    utf8_t *input = malloc(len);
    err = js_get_value_string_utf8(env, argv[1], input, len, NULL);
    assert(err == 0);

    err = url_parse(&base, input, len, NULL);

    free(input);

    if (err < 0) {
      url_destroy(&base);

      js_value_t *result;
      err = js_get_boolean(env, false, &result);
      assert(err == 0);

      return result;
    }
  }

  size_t len;
  err = js_get_value_string_utf8(env, argv[0], NULL, 0, &len);
  assert(err == 0);

  utf8_t *input = malloc(len);
  err = js_get_value_string_utf8(env, argv[0], input, len, NULL);
  assert(err == 0);

  url_t url;
  url_init(&url);

  err = url_parse(&url, input, len, has_base ? &base : NULL);

  free(input);

  url_destroy(&base);
  url_destroy(&url);

  js_value_t *result;
  err = js_get_boolean(env, err == 0, &result);
  assert(err == 0);

  return result;
}

static js_value_t *
bare_url_serialize_form_urlencoded(js_env_t *env, js_callback_info_t *info) {
  int err;

  size_t argc = 1;
  js_value_t *argv[1];

  err = js_get_callback_info(env, info, &argc, argv, NULL, NULL);
  assert(err == 0);

  assert(argc == 1);

  uint32_t len;
  err = js_get_array_length(env, argv[0], &len);
  assert(err == 0);

  utf8_string_t result;
  utf8_string_init(&result);

  for (uint32_t i = 0; i + 1 < len; i += 2) {
    js_value_t *pair[2];

    err = js_get_element(env, argv[0], i, &pair[0]);
    assert(err == 0);

    err = js_get_element(env, argv[0], i + 1, &pair[1]);
    assert(err == 0);

    if (i != 0) {
      err = utf8_string_append_character(&result, '&');
      assert(err == 0);
    }

    bare_url__serialize_form_urlencoded_component(env, pair[0], &result);

    err = utf8_string_append_character(&result, '=');
    assert(err == 0);

    bare_url__serialize_form_urlencoded_component(env, pair[1], &result);
  }

  js_value_t *output;
  err = js_create_string_utf8(env, result.data, result.len, &output);
  assert(err == 0);

  utf8_string_destroy(&result);

  return output;
}

static js_value_t *
bare_url_exports(js_env_t *env, js_value_t *exports) {
  int err;

#define V(name, fn) \
  { \
    js_value_t *val; \
    err = js_create_function(env, name, -1, fn, NULL, &val); \
    assert(err == 0); \
    err = js_set_named_property(env, exports, name, val); \
    assert(err == 0); \
  }

  V("parse", bare_url_parse)
  V("canParse", bare_url_can_parse)
  V("serializeSearchParams", bare_url_serialize_form_urlencoded)
#undef V

  return exports;
}

BARE_MODULE(bare_url, bare_url_exports)

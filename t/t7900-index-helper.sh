#!/bin/sh
#
# Copyright (c) 2016, Twitter, Inc
#

test_description='git-index-helper

Testing git index-helper
'

. ./test-lib.sh

test -n "$NO_MMAP" && {
	skip_all='skipping index-helper tests: no mmap'
	test_done
}

test_expect_success 'index-helper smoke test' '
	git index-helper --exit-after 1 &&
	test_path_is_missing .git/index-helper.path
'

test_expect_success 'index-helper creates usable path file and can be killed' '
	test_when_finished "git index-helper --kill" &&
	test_path_is_missing .git/index-helper.path &&
	git index-helper --detach &&
	test -L .git/index-helper.path &&
	dir="$(readlink .git/index-helper.path)" &&
	test -S "$dir/s" &&
	ls -ld "$dir" | grep ^drwx...--- &&
	git index-helper --kill &&
	test_path_is_missing .git/index-helper.path
'

test_done

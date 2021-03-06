# Copyright 2012 The Rust Project Developers. See the COPYRIGHT
# file at the top-level directory of this distribution and at
# http://rust-lang.org/COPYRIGHT.
#
# Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
# http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
# <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
# option. This file may not be copied, modified, or distributed
# except according to those terms.

# Rules for non-core tools built with the compiler, both for target
# and host architectures

FUZZER_LIB := $(S)src/libfuzzer/fuzzer.rc
FUZZER_INPUTS := $(wildcard $(addprefix $(S)src/libfuzzer/, *.rs))

# The test runner that runs the cfail/rfail/rpass and bxench tests
COMPILETEST_CRATE := $(S)src/compiletest/compiletest.rc
COMPILETEST_INPUTS := $(wildcard $(S)src/compiletest/*rs)

# Rustpkg, the package manager and build system
RUSTPKG_LIB := $(S)src/librustpkg/rustpkg.rc
RUSTPKG_INPUTS := $(wildcard $(S)src/librustpkg/*rs)

# Rustdoc, the documentation tool
RUSTDOC_LIB := $(S)src/librustdoc/rustdoc.rc
RUSTDOC_INPUTS := $(wildcard $(S)src/librustdoc/*.rs)

# Rusti, the JIT REPL
RUSTI_LIB := $(S)src/librusti/rusti.rc
RUSTI_INPUTS := $(wildcard $(S)src/librusti/*.rs)

# Rust, the convenience tool
RUST_LIB := $(S)src/librust/rust.rc
RUST_INPUTS := $(wildcard $(S)src/librust/*.rs)

# FIXME: These are only built for the host arch. Eventually we'll
# have tools that need to built for other targets.
define TOOLS_STAGE_N_TARGET

$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBFUZZER_$(4)):          \
		$$(FUZZER_LIB) $$(FUZZER_INPUTS)			\
		$$(TSREQ$(1)_T_$(4)_H_$(3))					\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_CORELIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_STDLIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTC_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) -o $$@ $$< && touch $$@

$$(TBIN$(1)_T_$(4)_H_$(3))/fuzzer$$(X_$(4)):				\
		$$(DRIVER_CRATE)								\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBFUZZER_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) --cfg fuzzer -o $$@ $$<

$$(TBIN$(1)_T_$(4)_H_$(3))/compiletest$$(X_$(4)):			\
		$$(COMPILETEST_CRATE) $$(COMPILETEST_INPUTS)	\
		$$(TSREQ$(1)_T_$(4)_H_$(3))						\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_CORELIB_$(4))      \
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_STDLIB_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) -o $$@ $$<

$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTPKG_$(4)):		\
		$$(RUSTPKG_LIB) $$(RUSTPKG_INPUTS)		    \
		$$(TSREQ$(1)_T_$(4)_H_$(3))					\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_CORELIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_STDLIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTC_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) -o $$@ $$< && touch $$@

$$(TBIN$(1)_T_$(4)_H_$(3))/rustpkg$$(X_$(4)):				\
		$$(DRIVER_CRATE) 							\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTPKG_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) --cfg rustpkg -o $$@ $$<

$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTDOC_$(4)):		\
		$$(RUSTDOC_LIB) $$(RUSTDOC_INPUTS)			\
		$$(TSREQ$(1)_T_$(4)_H_$(3))					\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_CORELIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_STDLIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTC_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) -o $$@ $$< && touch $$@

$$(TBIN$(1)_T_$(4)_H_$(3))/rustdoc$$(X_$(4)):			\
		$$(DRIVER_CRATE) 							\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTDOC_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) --cfg rustdoc -o $$@ $$<

$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTI_$(4)):		\
		$$(RUSTI_LIB) $$(RUSTI_INPUTS)			\
		$$(TSREQ$(1)_T_$(4)_H_$(3))					\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_CORELIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_STDLIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTC_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) -o $$@ $$< && touch $$@

$$(TBIN$(1)_T_$(4)_H_$(3))/rusti$$(X_$(4)):			\
		$$(DRIVER_CRATE) 							\
		$$(TLIB$(1)_T_$(4)_H_$(4))/$(CFG_LIBRUSTI_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) --cfg rusti -o $$@ $$<

$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUST_$(4)):		\
		$$(RUST_LIB) $$(RUST_INPUTS)			\
		$$(TSREQ$(1)_T_$(4)_H_$(3))					\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_CORELIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_STDLIB_$(4))	\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTC_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) -o $$@ $$< && touch $$@

$$(TBIN$(1)_T_$(4)_H_$(3))/rust$$(X_$(4)):			\
		$$(DRIVER_CRATE) 							\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUST_$(4))
	@$$(call E, compile_and_link: $$@)
	$$(STAGE$(1)_T_$(4)_H_$(3)) --cfg rust -o $$@ $$<

endef

define TOOLS_STAGE_N_HOST


# Promote the stageN target to stageN+1 host
# FIXME: Shouldn't need to depend on host/librustc.so once
# rpath is working
$$(HLIB$(2)_H_$(4))/$(CFG_LIBFUZZER_$(4)):					\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBFUZZER_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTC_$(4))			\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@
	$$(Q)cp -R $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBFUZZER_GLOB_$(4)) \
		$$(wildcard $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBFUZZER_DSYM_GLOB_$(4))) \
	        $$(HLIB$(2)_H_$(4))

$$(HBIN$(2)_H_$(4))/fuzzer$$(X_$(4)):				\
		$$(TBIN$(1)_T_$(4)_H_$(3))/fuzzer$$(X_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBFUZZER_$(4))	\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@

$$(HBIN$(2)_H_$(4))/compiletest$$(X_$(4)):				\
		$$(TBIN$(1)_T_$(4)_H_$(3))/compiletest$$(X_$(4))	\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@


$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTPKG_$(4)):				\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTPKG_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTC_$(4))		\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@
	$$(Q)cp -R $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBRUSTPKG_GLOB_$(4)) \
		$$(wildcard $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBRUSTPKG_DSYM_GLOB_$(4))) \
	        $$(HLIB$(2)_H_$(4))

$$(HBIN$(2)_H_$(4))/rustpkg$$(X_$(4)):				\
		$$(TBIN$(1)_T_$(4)_H_$(3))/rustpkg$$(X_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTPKG_$(4))	\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@

$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTDOC_$(4)):					\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTDOC_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTC_$(4))			\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@
	$$(Q)cp -R $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBRUSTDOC_GLOB_$(4)) \
		$$(wildcard $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBRUSTDOC_DSYM_GLOB_$(4))) \
	        $$(HLIB$(2)_H_$(4))

$$(HBIN$(2)_H_$(4))/rustdoc$$(X_$(4)):				\
		$$(TBIN$(1)_T_$(4)_H_$(3))/rustdoc$$(X_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTDOC_$(4))	\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@

$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTI_$(4)):					\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUSTI_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTC_$(4))			\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@
	$$(Q)cp -R $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBRUSTI_GLOB_$(4)) \
		$$(wildcard $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBRUSTI_DSYM_GLOB_$(4))) \
	        $$(HLIB$(2)_H_$(4))

$$(HBIN$(2)_H_$(4))/rusti$$(X_$(4)):				\
		$$(TBIN$(1)_T_$(4)_H_$(3))/rusti$$(X_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTI_$(4))	\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@

$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUST_$(4)):					\
		$$(TLIB$(1)_T_$(4)_H_$(3))/$(CFG_LIBRUST_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUSTC_$(4))			\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@
	$$(Q)cp -R $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBRUST_GLOB_$(4)) \
		$$(wildcard $$(TLIB$(1)_T_$(4)_H_$(3))/$(LIBRUST_DSYM_GLOB)_$(4)) \
	        $$(HLIB$(2)_H_$(4))

$$(HBIN$(2)_H_$(4))/rust$$(X_$(4)):				\
		$$(TBIN$(1)_T_$(4)_H_$(3))/rust$$(X_$(4))	\
		$$(HLIB$(2)_H_$(4))/$(CFG_LIBRUST_$(4))	\
		$$(HSREQ$(2)_H_$(4))
	@$$(call E, cp: $$@)
	$$(Q)cp $$< $$@

endef

$(foreach host,$(CFG_HOST_TRIPLES),				\
$(foreach target,$(CFG_TARGET_TRIPLES),				\
 $(eval $(call TOOLS_STAGE_N_TARGET,0,1,$(host),$(target)))	\
 $(eval $(call TOOLS_STAGE_N_TARGET,1,2,$(host),$(target)))	\
 $(eval $(call TOOLS_STAGE_N_TARGET,2,3,$(host),$(target)))))

$(foreach host,$(CFG_HOST_TRIPLES),				\
 $(eval $(call TOOLS_STAGE_N_HOST,0,1,$(host),$(host)))	\
 $(eval $(call TOOLS_STAGE_N_HOST,1,2,$(host),$(host)))	\
 $(eval $(call TOOLS_STAGE_N_HOST,2,3,$(host),$(host))))

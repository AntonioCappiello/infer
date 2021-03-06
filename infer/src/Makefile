# Copyright (c) 2013 - present Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the BSD style license found in the
# LICENSE file in the root directory of this source tree. An additional grant
# of patent rights can be found in the PATENTS file in the same directory.

INFER_VERSION_MAJOR = 0
INFER_VERSION_MINOR = 4
INFER_VERSION_PATCH = 0

REMOVE = rm -vf
REMOVE_DIR = rm -rvf
COPY = cp -f -p
COPY_DIR = cp -rf
MKDIR = mkdir -p
LINK = ln -sf
ATDGEN = atdgen

OCAML_INCLUDE_DIR = $(shell ocamlc -where)

#### Global declarations ####

ROOT = $(shell cd ../.. && pwd)

BUILDDIR = $(ROOT)/infer/_build-infer
ANNOTDIR = $(ROOT)/infer/src/_build
BINDIR = $(ROOT)/infer/bin
SCRIPTDIR = $(ROOT)/scripts
ETC_DIR = $(ROOT)/infer/etc

ifneq ($(wildcard $(BUILDDIR)/sanitize.sh),)
	SANITIZE_SCRIPT = $(BUILDDIR)/sanitize.sh
endif

#### Infer includes declarations ####

ATDGEN_INCLUDE_DIR = $(shell ocamlfind query atdgen)
BINIOU_INCLUDE_DIR = $(shell ocamlfind query biniou)
YOJSON_INCLUDE_DIR = $(shell ocamlfind query yojson)
EASYFORMAT_INCLUDE_DIR = $(shell ocamlfind query easy-format)

OCAML_INCLUDES = -I,$(EASYFORMAT_INCLUDE_DIR),-I,$(BINIOU_INCLUDE_DIR),-I,$(YOJSON_INCLUDE_DIR),-I,$(ATDGEN_INCLUDE_DIR)
OCAML_LIBS = unix str atdgen
OCAML_MODS = easy_format bi_util bi_share bi_outbuf bi_inbuf bi_vint bi_io yojson ag_oj_run ag_ob_run ag_util
OCAMLBUILD_OPTIONS = -lflags -annot \
                     -cflags -annot,-bin-annot,-warn-error,@5@8@10..12@20@26@39 \
                     -lflags $(OCAML_INCLUDES) \
                     -cflags $(OCAML_INCLUDES) \
                     $(addprefix -lib ,$(OCAML_LIBS)) \
                     $(addprefix -mod ,$(OCAML_MODS))

#### Backend declarations ####

BACKEND_SOURCES = backend

INFERANALYZE_MAIN = $(BACKEND_SOURCES)/inferanalyze
INFERANALYZE_BINARY = $(BINDIR)/InferAnalyze

#### Typeprop declarations ####

TYPEPROP_MAIN = $(BACKEND_SOURCES)/type_prop
TYPEPROP_BINARY = $(BINDIR)/Typeprop

#### InferPrint declarations ####

INFERPRINT_ATDGEN_STUB_BASE = $(BACKEND_SOURCES)/jsonbug
INFERPRINT_ATDGEN_STUB_ATD = $(INFERPRINT_ATDGEN_STUB_BASE).atd
INFERPRINT_ATDGEN_SUFFIXES = _t.ml _t.mli _j.ml _j.mli
INFERPRINT_ATDGEN_STUBS = $(addprefix $(INFERPRINT_ATDGEN_STUB_BASE), $(INFERPRINT_ATDGEN_SUFFIXES))

INFERPRINT_MAIN = $(BACKEND_SOURCES)/inferprint
INFERPRINT_BINARY = $(BINDIR)/InferPrint

#### Java declarations ####

EXTLIB_INCLUDE_DIR = $(shell ocamlfind query extlib)
PTREES_INCLUDE_DIR = $(shell ocamlfind query ptrees)
JAVALIB_INCLUDE_DIR = $(shell ocamlfind query javalib)
SAWJA_INCLUDE_DIR = $(shell ocamlfind query sawja)
ZIP_INCLUDE_DIR = $(shell ocamlfind query camlzip)

JAVA_INCLUDES = -I,$(EXTLIB_INCLUDE_DIR),-I,$(ZIP_INCLUDE_DIR),-I,$(PTREES_INCLUDE_DIR),-I,$(JAVALIB_INCLUDE_DIR),-I,$(SAWJA_INCLUDE_DIR)
JAVA_LIBS = zip extLib ptrees javalib sawja
JAVA_OPTIONS = -cflags -annot -lflags $(JAVA_INCLUDES) -cflags $(JAVA_INCLUDES) $(addprefix -lib ,$(JAVA_LIBS))

JAVA_SOURCES = java

INFERJAVA_MAIN = $(JAVA_SOURCES)/jMain
INFERJAVA_BINARY = $(BINDIR)/InferJava

#### Clang declarations ####

CLANG_SOURCES = clang
INFERCLANG_MAIN = $(CLANG_SOURCES)/cMain
INFERCLANG_BINARY = $(BINDIR)/InferClang

CLANG_PLUGIN_ROOT ?= $(ROOT)/facebook-clang-plugins
CLANG_PLUGIN_BINARIES = $(addprefix $(CLANG_PLUGIN_ROOT)/clang-ocaml/build/, clang_ast_converter clang_ast_named_decl_printer)

CLANG_OCAML_ROOT = $(CLANG_PLUGIN_ROOT)/clang-ocaml
CLANG_OCAML_BUILD = $(CLANG_OCAML_ROOT)/build

CLANG_AST_BASE_NAME = clang_ast
CLANG_ATDGEN_STUB_BASE = $(CLANG_SOURCES)/$(CLANG_AST_BASE_NAME)
CLANG_ATDGEN_STUB_ATD = $(CLANG_OCAML_BUILD)/$(CLANG_AST_BASE_NAME).atd
CLANG_ATDGEN_SUFFIXES = _t.ml _t.mli _b.ml _b.mli _j.ml _j.mli _v.ml _v.mli
CLANG_ATDGEN_STUBS = $(addprefix $(CLANG_SOURCES)/$(CLANG_AST_BASE_NAME), $(CLANG_ATDGEN_SUFFIXES))

INFER_CLANG_AST_PROJ = $(addprefix $(CLANG_SOURCES)/, clang_ast_proj.ml clang_ast_proj.mli)
INFER_CLANG_AST_MAIN = $(addprefix $(CLANG_SOURCES)/, clang_ast_visit.ml clang_ast_main.ml)
FCP_CLANG_AST_PROJ = $(addprefix $(CLANG_OCAML_BUILD)/, clang_ast_proj.ml clang_ast_proj.mli)
FCP_CLANG_AST_MAIN = $(addprefix $(CLANG_OCAML_ROOT)/, clang_ast_visit.ml clang_ast_main.ml)

CLANG_BINIOU_DICT = $(ETC_DIR)/clang_ast.dict

#### LLVM declarations ####

LLVM_SOURCES = llvm
INFERLLVM_MAIN = $(LLVM_SOURCES)/lMain
INFERLLVM_BINARY = $(BINDIR)/InferLLVM

#### scripts declarations ####

SCRIPT_SOURCES = scripts

CHECKCOPYRIGHT_BINARY = $(SCRIPTDIR)/checkCopyright
CHECKCOPYRIGHT_MAIN = $(SCRIPT_SOURCES)/checkCopyright

#### End of declarations ####

# Check whether .facebook file exists in a root directory.
# Based on that determine which code should be loaded
ifeq ($(wildcard $(ROOT)/.facebook),)
	EXTRA_DEPS = opensource
else
	EXTRA_DEPS = facebook
endif

DEPENDENCIES = $(BACKEND_SOURCES) checkers facebook/checkers facebook/checkers/graphql facebook/scripts harness $(EXTRA_DEPS)

OCAMLBUILD = ocamlbuild $(OCAMLBUILD_OPTIONS) -build-dir $(BUILDDIR) -j 0 $(addprefix -I , $(DEPENDENCIES)) $(JAVA_OPTIONS)

.PHONY: all java clang llvm checkCopyright build_java build_clang build_llvm build_checkCopyright annotations init sanitize version clean

all: java clang llvm checkCopyright

java: build_java annotations $(INFERANALYZE_BINARY) $(INFERPRINT_BINARY) $(INFERJAVA_BINARY)

clang: build_clang annotations $(INFERANALYZE_BINARY) $(INFERPRINT_BINARY) $(INFERCLANG_BINARY) $(CLANG_BINIOU_DICT)

llvm: build_llvm annotations $(INFERLLVM_BINARY)

checkCopyright: build_checkCopyright annotations $(CHECKCOPYRIGHT_BINARY)

build_java: init $(INFERPRINT_ATDGEN_STUBS)
	$(OCAMLBUILD) $(TYPEPROP_MAIN).native $(INFERANALYZE_MAIN).native $(INFERPRINT_MAIN).native $(INFERJAVA_MAIN).native

build_clang: init $(INFERPRINT_ATDGEN_STUBS) $(CLANG_ATDGEN_STUBS)
	$(OCAMLBUILD) $(INFERANALYZE_MAIN).native $(INFERPRINT_MAIN).native $(INFERCLANG_MAIN).native

build_llvm:
	$(OCAMLBUILD) -use-menhir $(INFERLLVM_MAIN).native

build_checkCopyright:
	$(OCAMLBUILD) -I $(SCRIPT_SOURCES) $(CHECKCOPYRIGHT_MAIN).native

annotations:
	rsync -r --delete --exclude=*.ml* --exclude=*.o --exclude=*.cm* --exclude=*.native $(BUILDDIR)/* $(ANNOTDIR)

$(INFERPRINT_ATDGEN_STUBS): $(INFERPRINT_ATDGEN_STUB_ATD)
	$(ATDGEN) -t $(INFERPRINT_ATDGEN_STUB_ATD) -o $(INFERPRINT_ATDGEN_STUB_BASE)
	$(ATDGEN) -j $(INFERPRINT_ATDGEN_STUB_ATD) -o $(INFERPRINT_ATDGEN_STUB_BASE)

$(CLANG_ATDGEN_STUBS) $(INFER_CLANG_AST_PROJ) $(INFER_CLANG_AST_MAIN): $(CLANG_ATDGEN_STUB_ATD) $(CLANG_PLUGIN_BINARIES) $(FCP_CLANG_AST_PROJ) $(FCP_CLANG_AST_MAIN)
# rebuild the artifacts of the AST files whenever they're upated in FCP
# also copy the ast_proj files whenever they are updated
	$(ATDGEN) -t $(CLANG_ATDGEN_STUB_ATD) -o $(CLANG_ATDGEN_STUB_BASE)
	$(ATDGEN) -b $(CLANG_ATDGEN_STUB_ATD) -o $(CLANG_ATDGEN_STUB_BASE)
	$(ATDGEN) -j $(CLANG_ATDGEN_STUB_ATD) -o $(CLANG_ATDGEN_STUB_BASE)
	$(ATDGEN) -v $(CLANG_ATDGEN_STUB_ATD) -o $(CLANG_ATDGEN_STUB_BASE)
	$(COPY) $(CLANG_OCAML_BUILD)/clang_ast_proj.ml $(CLANG_SOURCES)
	$(COPY) $(CLANG_OCAML_BUILD)/clang_ast_proj.mli $(CLANG_SOURCES)
	$(COPY) $(CLANG_OCAML_ROOT)/clang_ast_visit.ml $(CLANG_SOURCES)
	$(COPY) $(CLANG_OCAML_ROOT)/clang_ast_main.ml $(CLANG_SOURCES)

$(CLANG_BINIOU_DICT): $(CLANG_ATDGEN_STUB_ATD)
# overapproximation of the words we need in the biniou dictionary
# the long litany of symbols is [:punct:] minus "_-'"
	tr -s '[*!"#\$%&\(\)\+,\\\.\/:;<=>\?@\[\\\\]^`\{|\}~[:space:]]' '\n' \
	  < $(CLANG_ATDGEN_STUB_ATD) \
	  | sort | uniq  \
	  > $(CLANG_BINIOU_DICT)

init: sanitize version $(BUILDDIR)

sanitize:
	$(SANITIZE_SCRIPT)

version:
	GIT_COMMIT=$$(git rev-parse HEAD 2> /dev/null \
	  || printf "unknown commit"); \
	GIT_BRANCH=$$(git rev-parse --abbrev-ref HEAD 2> /dev/null \
	  || printf "unknown branch"); \
	UNKNOWN="-unknown"; \
	if [ -e "$(ROOT)/.release" ]; then \
	  UNKNOWN=""; \
	fi; \
	GIT_TAG=$$(git tag --points-at HEAD 2> /dev/null \
	  || printf "v$(INFER_VERSION_MAJOR).$(INFER_VERSION_MINOR).$(INFER_VERSION_PATCH)$$UNKNOWN"); \
	sed -e 's/@MAJOR@/$(INFER_VERSION_MAJOR)/g' \
		-e 's/@MINOR@/$(INFER_VERSION_MINOR)/g' \
		-e 's/@PATCH@/$(INFER_VERSION_PATCH)/g' \
		-e "s/@GIT_COMMIT@/$$GIT_COMMIT/g" \
		-e "s#@GIT_BRANCH@#$$GIT_BRANCH#g" \
		-e "s/@GIT_TAG@/$$GIT_TAG/g" \
		$(BACKEND_SOURCES)/version.ml.in > $(BACKEND_SOURCES)/version.ml

$(BUILDDIR):
	$(MKDIR) $(BUILDDIR)

$(INFERANALYZE_BINARY): $(BUILDDIR)/$(INFERANALYZE_MAIN).native
	$(COPY) $(BUILDDIR)/$(INFERANALYZE_MAIN).native $(INFERANALYZE_BINARY)

$(INFERPRINT_BINARY): $(BUILDDIR)/$(INFERPRINT_MAIN).native
	$(COPY) $(BUILDDIR)/$(INFERPRINT_MAIN).native $(INFERPRINT_BINARY)

$(INFERJAVA_BINARY): $(BUILDDIR)/$(INFERJAVA_MAIN).native
	$(COPY) $(BUILDDIR)/$(INFERJAVA_MAIN).native $(INFERJAVA_BINARY)

$(INFERCLANG_BINARY): $(BUILDDIR)/$(INFERCLANG_MAIN).native
	$(COPY) $(BUILDDIR)/$(INFERCLANG_MAIN).native $(INFERCLANG_BINARY)

$(INFERLLVM_BINARY): $(BUILDDIR)/$(INFERLLVM_MAIN).native
	$(COPY) $(BUILDDIR)/$(INFERLLVM_MAIN).native $(INFERLLVM_BINARY)

$(TYPEPROP_BINARY): $(BUILDDIR)/$(TYPEPROP_MAIN).native
	$(COPY) $(BUILDDIR)/$(TYPEPROP_MAIN).native $(TYPEPROP_BINARY)

$(CHECKCOPYRIGHT_BINARY): $(BUILDDIR)/$(CHECKCOPYRIGHT_MAIN).native
	$(COPY) $(BUILDDIR)/$(CHECKCOPYRIGHT_MAIN).native $(CHECKCOPYRIGHT_BINARY)

clean: $(BUILDDIR)
	$(OCAMLBUILD) -clean
	$(REMOVE_DIR) $(ANNOTDIR)
	$(REMOVE) $(BACKEND_SOURCES)/version.ml
	$(REMOVE) $(TYPEPROP_BINARY) $(INFERANALYZE_BINARY) $(INFERPRINT_BINARY)
	$(REMOVE) $(INFERJAVA_BINARY) $(INFERCLANG_BINARY) $(INFERLLVM_BINARY)
	$(REMOVE) $(CHECKCOPYRIGHT_BINARY)
	$(REMOVE) $(CLANG_ATDGEN_STUBS)
	$(REMOVE) $(INFER_CLANG_AST_PROJ)
	$(REMOVE) $(INFER_CLANG_AST_MAIN)

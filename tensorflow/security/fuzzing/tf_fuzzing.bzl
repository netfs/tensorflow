"""Definitions for rules to fuzz TensorFlow."""

# TensorFlow fuzzing can be done in open source too.
#
# For a fuzzer ${FUZZ} we have the following setup:
#   - ${FUZZ}_fuzz.cc           : the implementation of the fuzzer
#   - corpus/${FUZZ}/...        : public corpus for the fuzzer
#   - dictionaries/${FUZZ}.dict : fuzzing dictionary for the fuzzer
#   - ${FUZZ}_internal/...      : internal data for the fuzzer
#
# If a fuzzer needs some framework to build, we can use the ${FUZZ}_internal/
# directory to hold the harness. Or, if the infrastructure needs to be shared
# across multiple fuzzers (for example fuzzing ops), we can store it in other
# places in TF or move it to a different folder here. We will decide on these
# on a case by case basis, for now the ops fuzzing harness resides under
# tensorflow/core/kernels/fuzzing.
#
# The internal folder can also contain proto definitions (if using proto-based
# mutators to do structure aware fuzzing) or any other type of content that is
# not classified elsewhere.

# tf_cc_fuzz_target is a cc_test modified to include fuzzing support.
def tf_fuzz_target(
        name,
        # Fuzzing specific arguments
        fuzzing_dict = [],
        corpus = [],
        parsers = [],
        # Reporting bugs arguments, not used in open source
        componentid = None,
        hotlists = [],
        # Additional cc_test control
        data = [],
        deps = [],
        tags = [],
        # Remaining cc_test arguments
        **kwargs):
    """Specify how to build a TensorFlow fuzz target.

    Args:
      name: Mandatory name of the fuzzer target.

      fuzzing_dict: An optional a set of dictionary files following
        the AFL/libFuzzer dictionary syntax.

      corpus: An optional set of files used as the initial test corpus
        for the target. When doing "bazel test" in the default null-fuzzer
        (unittest) mode, these files are automatically passed to the target
        function.

      parsers: An optional list of file extensions that the target supports.
        Used by tools like autofuzz to reuse corpus sets across targets.

      componentid: Used internally for reporting fuzz discovered bugs.

      hotlists: Used internally for reporting fuzz discovered bugs.

      data: Additional data dependencies passed to the underlying cc_test rule.

      deps: An optional list of dependencies for the code you're fuzzing.

      tags: Additional tags passed to the underlying cc_test rule.

      **kwargs: Collects all remaining arguments and passes them to the
        underlying cc_test rule generated by the macro.
    """
    componentid = None
    hotlists = None

    # Fuzzers in open source must be run manually
    tags = tags + ["manual"]

    # Now, redirect to cc_test
    native.cc_test(
        name = name,
        deps = deps,  # TODO(mihaimaruseac): fuzzing lib?
        data = data,  # TODO(mihaimaruseac): dict, corpus, parsers??
        tags = tags,  # TODO(mihaimaruseac): fuzzing tags?
        linkstatic = 1,
        **kwargs
    )

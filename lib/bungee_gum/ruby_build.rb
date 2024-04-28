# frozen_string_literal: true

require 'git'
require 'optparse'

class BungeeGum::RubyBuild
  GITHUB_RUBY_REPOSITORY = 'https://github.com/ruby/ruby.git'
  LOCAL_RUBY_REPOSITORY = 'base-ruby-repo'
  FOR_BUILD_REPOSITORY = 'build-ruby-repo'
  FOR_UP_BUILD_REPOSITORY = 'build-up-ruby-repo'
  FOR_YJIT_BUILD_REPOSITORY = 'build-yjit-ruby-repo'
  FOR_FORCE_YJIT_BUILD_REPOSITORY = 'build-force-yjit-ruby-repo'
  FOR_RJIT_BUILD_REPOSITORY = 'build-rjit-ruby-repo'
  FOR_FORCE_RJIT_BUILD_REPOSITORY = 'build-force-rjit-ruby-repo'
  FOR_OPT_DIRECT_THREADED_CODE_BUILD_REPOSITORY = 'build-odtc-ruby-repo'
  FOR_OPT_TOKEN_THREADED_CODE_BUILD_REPOSITORY = 'build-ottc-ruby-repo'
  FOR_OPT_CALL_THREADED_CODE_BUILD_REPOSITORY = 'build-octc-ruby-repo'
  FOR_NDEBUG_BUILD_REPOSITORY = 'build-ndebug-ruby-repo'
  FOR_RUBY_DEBUG_BUILD_REPOSITORY = 'build-rubydebug-ruby-repo'
  FOR_ARRAY_DEBUG_BUILD_REPOSITORY = 'build-arraydebug-ruby-repo'
  FOR_BIGNUM_DEBUG_BUILD_REPOSITORY = 'build-bignumdebug-ruby-repo'
  FOR_CCAN_LIST_DEBUG_BUILD_REPOSITORY = 'build-cldebug-ruby-repo'
  FOR_CPDEBUG_BUILD_REPOSITORY = 'build-cpdebug-ruby-repo'
  FOR_ENC_DEBUG_BUILD_REPOSITORY = 'build-encdebug-ruby-repo'
  FOR_GC_DEBUG_BUILD_REPOSITORY = 'build-gcdebug-ruby-repo'
  FOR_HASH_DEBUG_BUILD_REPOSITORY = 'build-hashdebug-ruby-repo'
  FOR_ID_TABLE_DEBUG_BUILD_REPOSITORY = 'build-idtabledebug-ruby-repo'
  FOR_RGENGC_DEBUG_BUILD_REPOSITORY = 'build-rgengcdebug-ruby-repo'
  FOR_SYMBOL_DEBUG_BUILD_REPOSITORY = 'build-symboldebug-ruby-repo'
  FOR_RGENGC_CHECK_MODE_BUILD_REPOSITORY = 'build-rcm-ruby-repo'
  FOR_VM_CHECK_MODE_BUILD_REPOSITORY = 'build-vcm-ruby-repo'
  FOR_USE_EMBED_CI_BUILD_REPOSITORY = 'build-umc-ruby-repo'
  FOR_USE_FLONUM_BUILD_REPOSITORY = 'build-useflonum-ruby-repo'
  FOR_USE_GC_MALLOC_OBJ_INFO_DETAILS_BUILD_REPOSITORY = 'build-ugmoid-ruby-repo'
  FOR_USE_LAZY_LOAD_BUILD_REPOSITORY = 'build-ull-ruby-repo'
  FOR_USE_SYMBOL_GC_BUILD_REPOSITORY = 'build-usg-ruby-repo'
  FOR_USE_THREAD_CACHE_BUILD_REPOSITORY = 'build-utc-ruby-repo'
  FOR_USE_RUBY_DEBUG_LOG_BUILD_REPOSITORY = 'build-urbl-ruby-repo'
  FOR_USE_DEBUG_COUNTER_BUILD_REPOSITORY = 'build-udc-ruby-repo'
  FOR_SHARABLE_MIDDLE_SUBSTRING_BUILD_REPOSITORY = 'build-sms-ruby-repo'
  FOR_DEBUG_FIND_TIME_NUMGUESS_BUILD_REPOSITORY = 'build-dftn-ruby-repo'
  FOR_DEBUG_INTEGER_PACK_BUILD_REPOSITORY = 'build-dip-ruby-repo'
  FOR_ENABLE_PATH_CHECK_BUILD_REPOSITORY = 'build-epc-ruby-repo'
  FOR_GC_DEBUG_STRESS_TO_CLASS_BUILD_REPOSITORY = 'build-gdstc-ruby-repo'
  FOR_GC_ENABLE_LAZY_SWEEP_BUILD_REPOSITORY = 'build-gels-ruby-repo'
  FOR_GC_PROFILE_DETAIL_MEMORY_BUILD_REPOSITORY = 'build-gpdm-ruby-repo'
  FOR_GC_PROFILE_MORE_DETAIL_BUILD_REPOSITORY = 'build-gpmd-ruby-repo'
  FOR_CALC_EXACT_MALLOC_SIZE_BUILD_REPOSITORY = 'build-cems-ruby-repo'
  FOR_MALLOC_ALLOCATED_SIZE_CHECK_BUILD_REPOSITORY = 'build-masc-ruby-repo'
  FOR_IBF_ISEQ_ENABLE_LOCAL_BUFFER_BUILD_REPOSITORY = 'build-iielb-ruby-repo'
  FOR_RGENGC_ESTIMATE_OLDMALLOC_BUILD_REPOSITORY = 'build-reo-ruby-repo'
  FOR_RGENGC_FORCE_MAJOR_GC_BUILD_REPOSITORY = 'build-rfmg-ruby-repo'
  FOR_RGENGC_OBJ_INFO_BUILD_REPOSITORY = 'build-roi-ruby-repo'
  FOR_RGENGC_PROFILE_BUILD_REPOSITORY = 'build-rgengcprofile-ruby-repo'
  FOR_VM_DEBUG_BP_CHECK_BUILD_REPOSITORY = 'build-vdbc-ruby-repo'
  FOR_VM_DEBUG_VERIFY_METHOD_CACHE_BUILD_REPOSITORY = 'build-vdvmc-ruby-repo'

  INSTALL_PREFIX_BASE = "#{Dir.home}/.rubies"
  INSTALL_PREFIX_RUBY = "#{INSTALL_PREFIX_BASE}/ruby-master"
  INSTALL_PREFIX_RUBY_UP = "#{INSTALL_PREFIX_BASE}/ruby-universal-parser"
  INSTALL_PREFIX_RUBY_YJIT = "#{INSTALL_PREFIX_BASE}/ruby-yjit"
  INSTALL_PREFIX_RUBY_FORCE_YJIT = "#{INSTALL_PREFIX_BASE}/ruby-force-yjit"
  INSTALL_PREFIX_RUBY_RJIT = "#{INSTALL_PREFIX_BASE}/ruby-rjit"
  INSTALL_PREFIX_RUBY_FORCE_RJIT = "#{INSTALL_PREFIX_BASE}/ruby-force-rjit"
  INSTALL_PREFIX_RUBY_ODTC = "#{INSTALL_PREFIX_BASE}/ruby-odtc"
  INSTALL_PREFIX_RUBY_OTTC = "#{INSTALL_PREFIX_BASE}/ruby-ottc"
  INSTALL_PREFIX_RUBY_OCTC = "#{INSTALL_PREFIX_BASE}/ruby-octc"
  INSTALL_PREFIX_RUBY_OTC = "#{INSTALL_PREFIX_BASE}/ruby-otc"
  INSTALL_PREFIX_RUBY_NDEBUG = "#{INSTALL_PREFIX_BASE}/ruby-ndebug"
  INSTALL_PREFIX_RUBY_RUBY_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-rubydebug"
  INSTALL_PREFIX_RUBY_ARRAY_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-arraydebug"
  INSTALL_PREFIX_RUBY_BIGNUM_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-bignumdebug"
  INSTALL_PREFIX_RUBY_CCAN_LIST_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-cldebug"
  INSTALL_PREFIX_RUBY_CPDEBUG = "#{INSTALL_PREFIX_BASE}/ruby-cpdebug"
  INSTALL_PREFIX_RUBY_ENC_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-encdebug"
  INSTALL_PREFIX_RUBY_GC_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-gcdebug"
  INSTALL_PREFIX_RUBY_HASH_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-hashdebug"
  INSTALL_PREFIX_RUBY_ID_TABLE_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-idtabledebug"
  INSTALL_PREFIX_RUBY_RGENGC_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-rgengcdebug"
  INSTALL_PREFIX_RUBY_SYMBOL_DEBUG = "#{INSTALL_PREFIX_BASE}/ruby-symboldebug"
  INSTALL_PREFIX_RUBY_RGENGC_CHECK_MODE = "#{INSTALL_PREFIX_BASE}/ruby-rcm"
  INSTALL_PREFIX_RUBY_VM_CHECK_MODE = "#{INSTALL_PREFIX_BASE}/ruby-vcm"
  INSTALL_PREFIX_RUBY_USE_EMBED_CI = "#{INSTALL_PREFIX_BASE}/ruby-umc"
  INSTALL_PREFIX_RUBY_USE_FLONUM = "#{INSTALL_PREFIX_BASE}/ruby-useflonum"
  INSTALL_PREFIX_RUBY_USE_GC_MALLOC_OBJ_INFO_DETAILS = "#{INSTALL_PREFIX_BASE}/ruby-ugmoid"
  INSTALL_PREFIX_RUBY_USE_LAZY_LOAD = "#{INSTALL_PREFIX_BASE}/ruby-ull"
  INSTALL_PREFIX_RUBY_USE_SYMBOL_GC = "#{INSTALL_PREFIX_BASE}/ruby-usg"
  INSTALL_PREFIX_RUBY_USE_THREAD_CACHE = "#{INSTALL_PREFIX_BASE}/ruby-utc"
  INSTALL_PREFIX_RUBY_USE_RUBY_DEBUG_LOG = "#{INSTALL_PREFIX_BASE}/ruby-urdl"
  INSTALL_PREFIX_RUBY_USE_DEBUG_COUNTER = "#{INSTALL_PREFIX_BASE}/ruby-udc"
  INSTALL_PREFIX_RUBY_SHARABLE_MIDDLE_SUBSTRING = "#{INSTALL_PREFIX_BASE}/ruby-sms"
  INSTALL_PREFIX_RUBY_DEBUG_FIND_TIME_NUMGUESS = "#{INSTALL_PREFIX_BASE}/ruby-dftn"
  INSTALL_PREFIX_RUBY_DEBUG_INTEGER_PACK = "#{INSTALL_PREFIX_BASE}/ruby-dip"
  INSTALL_PREFIX_RUBY_ENABLE_PATH_CHECK = "#{INSTALL_PREFIX_BASE}/ruby-epc"
  INSTALL_PREFIX_RUBY_GC_DEBUG_STRESS_TO_CLASS = "#{INSTALL_PREFIX_BASE}/ruby-gdstc"
  INSTALL_PREFIX_RUBY_GC_ENABLE_LAZY_SWEEP = "#{INSTALL_PREFIX_BASE}/ruby-gels"
  INSTALL_PREFIX_RUBY_GC_PROFILE_DETAIL_MEMORY = "#{INSTALL_PREFIX_BASE}/ruby-gpdm"
  INSTALL_PREFIX_RUBY_GC_PROFILE_MORE_DETAIL = "#{INSTALL_PREFIX_BASE}/ruby-gpmd"
  INSTALL_PREFIX_RUBY_CALC_EXACT_MALLOC_SIZE = "#{INSTALL_PREFIX_BASE}/ruby-cems"
  INSTALL_PREFIX_RUBY_MALLOC_ALLOCATED_SIZE_CHECK = "#{INSTALL_PREFIX_BASE}/ruby-masc"
  INSTALL_PREFIX_RUBY_IBF_ISEQ_ENABLE_LOCAL_BUFFER = "#{INSTALL_PREFIX_BASE}/ruby-iielb"
  INSTALL_PREFIX_RUBY_RGENGC_ESTIMATE_OLDMALLOC = "#{INSTALL_PREFIX_BASE}/ruby-reo"
  INSTALL_PREFIX_RUBY_RGENGC_FORCE_MAJOR_GC = "#{INSTALL_PREFIX_BASE}/ruby-rfmg"
  INSTALL_PREFIX_RUBY_RGENGC_OBJ_INFO = "#{INSTALL_PREFIX_BASE}/ruby-roi"
  INSTALL_PREFIX_RUBY_RGENGC_PROFILE = "#{INSTALL_PREFIX_BASE}/ruby-rgengcprofile"
  INSTALL_PREFIX_RUBY_VM_DEBUG_BP_CHECK = "#{INSTALL_PREFIX_BASE}/ruby-vdbc"
  INSTALL_PREFIX_RUBY_VM_DEBUG_VERIFY_METHOD_CACHE = "#{INSTALL_PREFIX_BASE}/ruby-vdvmc"

  def initialize
    @base_ruby_repo = "#{Dir.pwd}/#{LOCAL_RUBY_REPOSITORY}"
    @working_dir = {}
    @now = Time.now.strftime('%Y%m%d%H%M%S')
    @opt = OptionParser.new
    @opt.version = BungeeGum::VERSION
  end

  def run
    param = {}
    params = []

    param[:with] = {}
    param[:only] = {}
    param[:skip] = {}

    @opt.on('--with-universalparser',
            'Add `--with-universalparser` if you also would like to build with enabled Universal Parser. This is equivalent to adding `cppflags=-DUNIVERSAL_PARSER`.') do |v|
      param[:with][:up] = v
      params << '--with-universalparser'
    end
    @opt.on('--only-universalparser',
            'Add `--only-universalparser` if you would like to build with only enabled Universal Parser. This is equivalent to adding `cppflags=-DUNIVERSAL_PARSER`. This option can not be used in conjunction with other options.') do |v|
      param[:only][:up] = v
      params << '--only-universalparser'
    end
    @opt.on('--with-yjit',
            'Add `--with-yjit` if you also would like to build with enabled YJIT. This is equivalent to adding `--enable-yjit`.') do |v|
      param[:with][:yjit] = v
      params << '--with-yjit'
    end
    @opt.on('--only-yjit',
            'Add `--only-yjit` if you would like to build with only enabled YJIT. This is equivalent to adding `--enable-yjit`. This option can not be used in conjunction with other options.') do |v|
      param[:only][:yjit] = v
      params << '--only-yjit'
    end
    @opt.on('--with-force-yjit',
            'Add `--with-force-yjit` if you also would like to build with enabled YJIT. This is equivalent to adding `cppflags=-DYJIT_FORCE_ENABLE`.') do |v|
      param[:with][:force_yjit] = v
      params << '--with-force-yjit'
    end
    @opt.on('--only-force-yjit',
            'Add `--only-force-yjit` if you would like to build with only enabled YJIT. This is equivalent to adding `cppflags=-DYJIT_FORCE_ENABLE`. This option can not be used in conjunction with other options.') do |v|
      param[:only][:force_yjit] = v
      params << '--only-force-yjit'
    end
    @opt.on('--with-rjit',
            'Add `--with-rjit` if you also would like to build with enabled RJIT. This is equivalent to adding `--enable-rjit --disable-yjit`.') do |v|
      param[:with][:rjit] = v
      params << '--with-rjit'
    end
    @opt.on('--only-rjit',
            'Add `--only-rjit` if you would like to build with only enabled RJIT. This is equivalent to adding `--enable-rjit --disable-yjit`. This option can not be used in conjunction with other options.') do |v|
      param[:only][:rjit] = v
      params << '--only-rjit'
    end
    @opt.on('--with-force-rjit',
            'Add `--with-force-rjit` if you also would like to build with enabled RJIT. This is equivalent to adding `cppflags=-DRJIT_FORCE_ENABLE`.') do |v|
      param[:with][:force_rjit] = v
      params << '--with-force-rjit'
    end
    @opt.on('--only-force-rjit',
            'Add `--only-force-rjit` if you would like to build with only enabled RJIT. This is equivalent to adding `cppflags=-DRJIT_FORCE_ENABLE`. This option can not be used in conjunction with other options.') do |v|
      param[:only][:force_rjit] = v
      params << '--only-force-rjit'
    end
    @opt.on('--all-build',
            'Add `--all-build` if you would like to build with all patterns that include `cppflags` option') do |v|
      param[:all_build] = v
      params << '--all-build'
    end

    @opt.parse!(ARGV)

    if param[:only].keys.size > 1 ||
       (param[:only].keys.size == 1 && !param[:with].empty?) ||
       (param[:only].keys.size == 1 && !!param[:all_build])
      only_error('--only-universalparser') if params.include?('--only-universalparser')
      only_error('--only-yjit')            if params.include?('--only-yjit')
      only_error('--only-force-yjit')      if params.include?('--only-force-yjit')
      only_error('--only-rjit')            if params.include?('--only-rjit')
      only_error('--only-force-rjit')      if params.include?('--only-force-rjit')

      exit 1
    end

    clone_or_pull(LOCAL_RUBY_REPOSITORY, true)
    Dir.mkdir(INSTALL_PREFIX_BASE, 0755) unless Dir.exist?(INSTALL_PREFIX_BASE)
    Dir.mkdir('logs', 0755) unless Dir.exist?('./logs')
    if param[:only].keys.size == 0
      clone_or_pull(FOR_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_BUILD_REPOSITORY,
          'master',
          "--prefix=#{INSTALL_PREFIX_RUBY}")
      }
    end

    if param[:only][:up] || param[:with][:up] || param[:all_build]
      clone_or_pull(FOR_UP_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_UP_BUILD_REPOSITORY,
          'universal-parser',
          "--prefix=#{INSTALL_PREFIX_RUBY_UP} --enable-shared cppflags=-DUNIVERSAL_PARSER")
      }
    end

    if param[:only][:yjit] || param[:with][:yjit] || param[:all_build]
      # with --enable-yjit
      clone_or_pull(FOR_YJIT_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_YJIT_BUILD_REPOSITORY,
          'yjit',
          "--prefix=#{INSTALL_PREFIX_RUBY_YJIT} --enable-yjit --disable-install-doc")
      }
    end

    if param[:only][:force_yjit] || param[:with][:force_yjit] || param[:all_build]
      # with cppflags=-DYJIT_FORCE_ENABLE
      clone_or_pull(FOR_FORCE_YJIT_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_FORCE_YJIT_BUILD_REPOSITORY,
          'force-yjit',
          "--prefix=#{INSTALL_PREFIX_RUBY_FORCE_YJIT} cppflags=-DYJIT_FORCE_ENABLE --disable-install-doc")
      }
    end

    if param[:only][:rjit] || param[:with][:rjit] || param[:all_build]
      # with --enable-rjit --disable-yjit
      clone_or_pull(FOR_RJIT_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RJIT_BUILD_REPOSITORY,
          'rjit',
          "--prefix=#{INSTALL_PREFIX_RUBY_RJIT} --enable-rjit --disable-yjit --disable-install-doc")
      }
    end

    if param[:only][:force_rjit] || param[:with][:force_rjit] || param[:all_build]
      # with cppflags=-DRJIT_FORCE_ENABLE
      clone_or_pull(FOR_FORCE_RJIT_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_FORCE_RJIT_BUILD_REPOSITORY,
          'force-rjit',
          "--prefix=#{INSTALL_PREFIX_RUBY_FORCE_RJIT} cppflags=-DRJIT_FORCE_ENABLE --disable-install-doc")
      }
    end

    if param[:all_build]
      # OPT_THREADED_CODE=0
      clone_or_pull(FOR_OPT_DIRECT_THREADED_CODE_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_OPT_DIRECT_THREADED_CODE_BUILD_REPOSITORY,
          'odtc',
          "--prefix=#{INSTALL_PREFIX_RUBY_ODTC} cppflags=-DOPT_THREADED_CODE=0 --disable-install-doc")
      }

      # OPT_THREADED_CODE=1
      clone_or_pull(FOR_OPT_TOKEN_THREADED_CODE_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_OPT_TOKEN_THREADED_CODE_BUILD_REPOSITORY,
          'ottc',
          "--prefix=#{INSTALL_PREFIX_RUBY_OTTC} cppflags=-DOPT_THREADED_CODE=1 --disable-install-doc")
      }

      # OPT_THREADED_CODE=2
      clone_or_pull(FOR_OPT_CALL_THREADED_CODE_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_OPT_CALL_THREADED_CODE_BUILD_REPOSITORY,
          'octc',
          "--prefix=#{INSTALL_PREFIX_RUBY_OCTC} cppflags=-DOPT_THREADED_CODE=2 --disable-install-doc")
      }

      # NDEBUG
      clone_or_pull(FOR_NDEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_NDEBUG_BUILD_REPOSITORY,
          'ndebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_NDEBUG} cppflags=-DNDEBUG --disable-install-doc")
      }

      # RUBY_DEBUG
      clone_or_pull(FOR_RUBY_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RUBY_DEBUG_BUILD_REPOSITORY,
          'rubydebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_RUBY_DEBUG} cppflags=-DRUBY_DEBUG --disable-install-doc")
      }

      # ARRAY_DEBUG
      clone_or_pull(FOR_ARRAY_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_ARRAY_DEBUG_BUILD_REPOSITORY,
          'arraydebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_ARRAY_DEBUG} cppflags=-DARRAY_DEBUG --disable-install-doc")
      }

      # BIGNUM_DEBUG
      clone_or_pull(FOR_BIGNUM_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_BIGNUM_DEBUG_BUILD_REPOSITORY,
          'bignumdebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_BIGNUM_DEBUG} cppflags=-DBIGNUM_DEBUG --disable-install-doc")
      }

      # CCAN_LIST_DEBUG
      clone_or_pull(FOR_CCAN_LIST_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_CCAN_LIST_DEBUG_BUILD_REPOSITORY,
          'cldebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_CCAN_LIST_DEBUG} cppflags=-DCCAN_LIST_DEBUG --disable-install-doc")
      }

      # CPDEBUG=-1
      clone_or_pull(FOR_CPDEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_CPDEBUG_BUILD_REPOSITORY,
          'cpdebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_CPDEBUG} cppflags=-DCPDEBUG=-1 --disable-install-doc")
      }

      # ENC_DEBUG
      clone_or_pull(FOR_ENC_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_ENC_DEBUG_BUILD_REPOSITORY,
          'encdebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_ENC_DEBUG} cppflags=-DENC_DEBUG --disable-install-doc")
      }

      # GC_DEBUG
      clone_or_pull(FOR_GC_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_GC_DEBUG_BUILD_REPOSITORY,
          'gcdebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_GC_DEBUG} cppflags=-DGC_DEBUG --disable-install-doc")
      }

      # GC_DEBUG
      clone_or_pull(FOR_GC_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_GC_DEBUG_BUILD_REPOSITORY,
          'gcdebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_GC_DEBUG} cppflags=-DGC_DEBUG --disable-install-doc")
      }

      # HASH_DEBUG
      clone_or_pull(FOR_HASH_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_HASH_DEBUG_BUILD_REPOSITORY,
          'hashdebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_HASH_DEBUG} cppflags=-DHASH_DEBUG --disable-install-doc")
      }

      # ID_TABLE_DEBUG
      clone_or_pull(FOR_ID_TABLE_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_ID_TABLE_DEBUG_BUILD_REPOSITORY,
          'idtabledebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_ID_TABLE_DEBUG} cppflags=-DID_TABLE_DEBUG --disable-install-doc")
      }

      # RGENGC_DEBUG=-1
      clone_or_pull(FOR_RGENGC_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RGENGC_DEBUG_BUILD_REPOSITORY,
          'rgengcdebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_RGENGC_DEBUG} cppflags=-DRGENGC_DEBUG=-1 --disable-install-doc")
      }

      # SYMBOL_DEBUG
      clone_or_pull(FOR_SYMBOL_DEBUG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_SYMBOL_DEBUG_BUILD_REPOSITORY,
          'symboldebug',
          "--prefix=#{INSTALL_PREFIX_RUBY_SYMBOL_DEBUG} cppflags=-DSYMBOL_DEBUG --disable-install-doc")
      }

      # RGENGC_CHECK_MODE
      clone_or_pull(FOR_RGENGC_CHECK_MODE_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RGENGC_CHECK_MODE_BUILD_REPOSITORY,
          'rcm',
          "--prefix=#{INSTALL_PREFIX_RUBY_RGENGC_CHECK_MODE} cppflags=-DRGENGC_CHECK_MODE --disable-install-doc")
      }

      # VM_CHECK_MODE
      clone_or_pull(FOR_VM_CHECK_MODE_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_VM_CHECK_MODE_BUILD_REPOSITORY,
          'vcm',
          "--prefix=#{INSTALL_PREFIX_RUBY_VM_CHECK_MODE} cppflags=-DVM_CHECK_MODE --disable-install-doc")
      }

      # USE_EMBED_CI=0
      clone_or_pull(FOR_USE_EMBED_CI_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_USE_EMBED_CI_BUILD_REPOSITORY,
          'umc',
          "--prefix=#{INSTALL_PREFIX_RUBY_USE_EMBED_CI} cppflags=-DUSE_EMBED_CI=0 --disable-install-doc")
      }

      # USE_FLONUM=0
      clone_or_pull(FOR_USE_FLONUM_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_USE_FLONUM_BUILD_REPOSITORY,
          'useflonum',
          "--prefix=#{INSTALL_PREFIX_RUBY_USE_FLONUM} cppflags=-DUSE_FLONUM=0 --disable-yjit --disable-install-doc")
      }

      # USE_GC_MALLOC_OBJ_INFO_DETAILS
      clone_or_pull(FOR_USE_GC_MALLOC_OBJ_INFO_DETAILS_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_USE_GC_MALLOC_OBJ_INFO_DETAILS_BUILD_REPOSITORY,
          'ugmoid',
          "--prefix=#{INSTALL_PREFIX_RUBY_USE_GC_MALLOC_OBJ_INFO_DETAILS} cppflags=-DUSE_GC_MALLOC_OBJ_INFO_DETAILS --disable-install-doc")
      }

      # USE_LAZY_LOAD
      clone_or_pull(FOR_USE_LAZY_LOAD_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_USE_LAZY_LOAD_BUILD_REPOSITORY,
          'ull',
          "--prefix=#{INSTALL_PREFIX_RUBY_USE_LAZY_LOAD} cppflags=-DUSE_LAZY_LOAD --disable-install-doc")
      }

      # USE_SYMBOL_GC=0
      clone_or_pull(FOR_USE_SYMBOL_GC_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_USE_SYMBOL_GC_BUILD_REPOSITORY,
          'usg',
          "--prefix=#{INSTALL_PREFIX_RUBY_USE_SYMBOL_GC} cppflags=-DUSE_SYMBOL_GC=0 --disable-install-doc")
      }

      # USE_THREAD_CACHE=0
      clone_or_pull(FOR_USE_THREAD_CACHE_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_USE_THREAD_CACHE_BUILD_REPOSITORY,
          'utc',
          "--prefix=#{INSTALL_PREFIX_RUBY_USE_THREAD_CACHE} cppflags=-DUSE_THREAD_CACHE=0 --disable-install-doc")
      }

      # USE_RUBY_DEBUG_LOG=1
      clone_or_pull(FOR_USE_RUBY_DEBUG_LOG_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_USE_RUBY_DEBUG_LOG_BUILD_REPOSITORY,
          'urbl',
          "--prefix=#{INSTALL_PREFIX_RUBY_USE_RUBY_DEBUG_LOG} cppflags=-DUSE_RUBY_DEBUG_LOG=1 --disable-install-doc")
      }

      # USE_DEBUG_COUNTER
      # TODO: RUBY_DEBUG_COUNTER_DISABLE=1
      clone_or_pull(FOR_USE_DEBUG_COUNTER_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_USE_DEBUG_COUNTER_BUILD_REPOSITORY,
          'udc',
          "--prefix=#{INSTALL_PREFIX_RUBY_USE_DEBUG_COUNTER} cppflags=-DUSE_DEBUG_COUNTER=1 --disable-install-doc")
      }

      # SHARABLE_MIDDLE_SUBSTRING
      clone_or_pull(FOR_SHARABLE_MIDDLE_SUBSTRING_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_SHARABLE_MIDDLE_SUBSTRING_BUILD_REPOSITORY,
          'sms',
          "--prefix=#{INSTALL_PREFIX_RUBY_SHARABLE_MIDDLE_SUBSTRING} cppflags=-DSHARABLE_MIDDLE_SUBSTRING=1 --disable-install-doc")
      }

      # DEBUG_FIND_TIME_NUMGUESS
      clone_or_pull(FOR_DEBUG_FIND_TIME_NUMGUESS_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_DEBUG_FIND_TIME_NUMGUESS_BUILD_REPOSITORY,
          'dftn',
          "--prefix=#{INSTALL_PREFIX_RUBY_DEBUG_FIND_TIME_NUMGUESS} cppflags=-DDEBUG_FIND_TIME_NUMGUESS --disable-install-doc")
      }

      # DEBUG_INTEGER_PACK
      clone_or_pull(FOR_DEBUG_INTEGER_PACK_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_DEBUG_INTEGER_PACK_BUILD_REPOSITORY,
          'dip',
          "--prefix=#{INSTALL_PREFIX_RUBY_DEBUG_INTEGER_PACK} cppflags=-DDEBUG_INTEGER_PACK --disable-install-doc")
      }

      # ENABLE_PATH_CHECK
      clone_or_pull(FOR_ENABLE_PATH_CHECK_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_ENABLE_PATH_CHECK_BUILD_REPOSITORY,
          'epc',
          "--prefix=#{INSTALL_PREFIX_RUBY_ENABLE_PATH_CHECK} cppflags=-DENABLE_PATH_CHECK --disable-install-doc")
      }

      # GC_DEBUG_STRESS_TO_CLASS
      clone_or_pull(FOR_GC_DEBUG_STRESS_TO_CLASS_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_GC_DEBUG_STRESS_TO_CLASS_BUILD_REPOSITORY,
          'gdstc',
          "--prefix=#{INSTALL_PREFIX_RUBY_GC_DEBUG_STRESS_TO_CLASS} cppflags=-DGC_DEBUG_STRESS_TO_CLASS --disable-install-doc")
      }

      # GC_ENABLE_LAZY_SWEEP=0
      clone_or_pull(FOR_GC_ENABLE_LAZY_SWEEP_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_GC_ENABLE_LAZY_SWEEP_BUILD_REPOSITORY,
          'gels',
          "--prefix=#{INSTALL_PREFIX_RUBY_GC_ENABLE_LAZY_SWEEP} cppflags=-DGC_ENABLE_LAZY_SWEEP=0 --disable-install-doc")
      }

      # GC_PROFILE_DETAIL_MEMORY
      clone_or_pull(FOR_GC_PROFILE_DETAIL_MEMORY_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_GC_PROFILE_DETAIL_MEMORY_BUILD_REPOSITORY,
          'gpdm',
          "--prefix=#{INSTALL_PREFIX_RUBY_GC_PROFILE_DETAIL_MEMORY} cppflags=-DGC_PROFILE_DETAIL_MEMORY --disable-install-doc")
      }

      # GC_PROFILE_MORE_DETAIL
      clone_or_pull(FOR_GC_PROFILE_MORE_DETAIL_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_GC_PROFILE_MORE_DETAIL_BUILD_REPOSITORY,
          'gpmd',
          "--prefix=#{INSTALL_PREFIX_RUBY_GC_PROFILE_MORE_DETAIL} cppflags=-DGC_PROFILE_MORE_DETAIL --disable-install-doc")
      }

      # CALC_EXACT_MALLOC_SIZE
      clone_or_pull(FOR_CALC_EXACT_MALLOC_SIZE_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_CALC_EXACT_MALLOC_SIZE_BUILD_REPOSITORY,
          'cems',
          "--prefix=#{INSTALL_PREFIX_RUBY_CALC_EXACT_MALLOC_SIZE} cppflags=-DCALC_EXACT_MALLOC_SIZE --disable-install-doc")
      }

      # MALLOC_ALLOCATED_SIZE_CHECK
      clone_or_pull(FOR_MALLOC_ALLOCATED_SIZE_CHECK_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_MALLOC_ALLOCATED_SIZE_CHECK_BUILD_REPOSITORY,
          'masc',
          "--prefix=#{INSTALL_PREFIX_RUBY_MALLOC_ALLOCATED_SIZE_CHECK} cppflags=-DMALLOC_ALLOCATED_SIZE_CHECK --disable-install-doc")
      }

      # IBF_ISEQ_ENABLE_LOCAL_BUFFER
      clone_or_pull(FOR_IBF_ISEQ_ENABLE_LOCAL_BUFFER_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_IBF_ISEQ_ENABLE_LOCAL_BUFFER_BUILD_REPOSITORY,
          'iielb',
          "--prefix=#{INSTALL_PREFIX_RUBY_IBF_ISEQ_ENABLE_LOCAL_BUFFER} cppflags=-DIBF_ISEQ_ENABLE_LOCAL_BUFFER --disable-install-doc")
      }

      # RGENGC_ESTIMATE_OLDMALLOC
      clone_or_pull(FOR_RGENGC_ESTIMATE_OLDMALLOC_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RGENGC_ESTIMATE_OLDMALLOC_BUILD_REPOSITORY,
          'reo',
          "--prefix=#{INSTALL_PREFIX_RUBY_RGENGC_ESTIMATE_OLDMALLOC} cppflags=-DRGENGC_ESTIMATE_OLDMALLOC --disable-install-doc")
      }

      # RGENGC_FORCE_MAJOR_GC
      clone_or_pull(FOR_RGENGC_FORCE_MAJOR_GC_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RGENGC_FORCE_MAJOR_GC_BUILD_REPOSITORY,
          'rfmg',
          "--prefix=#{INSTALL_PREFIX_RUBY_RGENGC_FORCE_MAJOR_GC} cppflags=-DRGENGC_FORCE_MAJOR_GC --disable-install-doc")
      }

      # RGENGC_OBJ_INFO
      clone_or_pull(FOR_RGENGC_OBJ_INFO_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RGENGC_OBJ_INFO_BUILD_REPOSITORY,
          'roi',
          "--prefix=#{INSTALL_PREFIX_RUBY_RGENGC_OBJ_INFO} cppflags=-DRGENGC_OBJ_INFO --disable-install-doc")
      }

      # RGENGC_PROFILE
      clone_or_pull(FOR_RGENGC_PROFILE_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RGENGC_PROFILE_BUILD_REPOSITORY,
          'rgengcprofile',
          "--prefix=#{INSTALL_PREFIX_RUBY_RGENGC_PROFILE} cppflags=-DRGENGC_PROFILE --disable-install-doc")
      }

      # VM_DEBUG_BP_CHECK
      clone_or_pull(FOR_VM_DEBUG_BP_CHECK_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_VM_DEBUG_BP_CHECK_BUILD_REPOSITORY,
          'vdbc',
          "--prefix=#{INSTALL_PREFIX_RUBY_VM_DEBUG_BP_CHECK} cppflags=-DVM_DEBUG_BP_CHECK --disable-install-doc")
      }

      # VM_DEBUG_VERIFY_METHOD_CACHE
      clone_or_pull(FOR_VM_DEBUG_VERIFY_METHOD_CACHE_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_VM_DEBUG_VERIFY_METHOD_CACHE_BUILD_REPOSITORY,
          'vdvmc',
          "--prefix=#{INSTALL_PREFIX_RUBY_VM_DEBUG_VERIFY_METHOD_CACHE} cppflags=-DVM_DEBUG_VERIFY_METHOD_CACHE --disable-install-doc")
      }
    end

    Process.waitall
  end

  private

  def clone_or_pull(repo_dir, from_gh = false)
    key = repo_dir.to_sym
    @working_dir[key] = "#{Dir.pwd}/#{repo_dir}"
    wd = @working_dir[key]
    if Dir.exist?("#{wd}/.git")
      g = Git.open(wd, log: Logger.new(STDOUT))
      g.pull
    else
      if from_gh
        Git.clone(GITHUB_RUBY_REPOSITORY, repo_dir)
      else
        Git.clone(@base_ruby_repo, repo_dir)
      end
    end
  end

  def make_and_test(repo_dir, build_type, configure_option)
    wd = @working_dir[repo_dir.to_sym]
    current_dir = Dir.pwd

    build_gz = "#{current_dir}/logs/ruby-#{build_type}-build.#{@now}.log.gz"
    test_gz = "#{current_dir}/logs/ruby-#{build_type}-test.#{@now}.log.gz"

    Dir.chdir(wd) do
      unless File.exist?('configure')
        system('./autogen.sh > /dev/null 2>&1')
        system("./configure #{configure_option} > /dev/null 2>&1")
      end

      system('make clean > /dev/null 2>&1')

      file = File.open(build_gz, 'w')
      system("make 2>&1 | gzip -c > #{build_gz}")
      file.close

      file = File.open(test_gz, 'w')
      system("make test-all 2>&1 | gzip -c > #{test_gz}")
      file.close
    end
  end

  def only_error(option)
    puts "`#{option}` can not be used in conjunction with other options."
  end
end

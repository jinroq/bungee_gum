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

  INSTALL_PREFIX_BASE = "#{Dir.home}/.rubies"
  INSTALL_PREFIX_RUBY = "#{INSTALL_PREFIX_BASE}/ruby-master"
  INSTALL_PREFIX_RUBY_UP = "#{INSTALL_PREFIX_BASE}/ruby-universal-parser"
  INSTALL_PREFIX_RUBY_YJIT = "#{INSTALL_PREFIX_BASE}/ruby-yjit"
  INSTALL_PREFIX_RUBY_FORCE_YJIT = "#{INSTALL_PREFIX_BASE}/ruby-force-yjit"
  INSTALL_PREFIX_RUBY_RJIT = "#{INSTALL_PREFIX_BASE}/ruby-rjit"
  INSTALL_PREFIX_RUBY_FORCE_RJIT = "#{INSTALL_PREFIX_BASE}/ruby-force-rjit"

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

    @opt.on('--with-universalparser', 'Add `--with-universalparser` if you also would like to build with enabled Universal Parser. This is equivalent to adding `cppflags=-DUNIVERSAL_PARSER`.') {|v|
      param[:with][:up] = v
      params << '--with-universalparser'
    }
    @opt.on('--only-universalparser', 'Add `--only-universalparser` if you would like to build with only enabled Universal Parser. This is equivalent to adding `cppflags=-DUNIVERSAL_PARSER`. This option can not be used in conjunction with other options.') {|v|
      param[:only][:up] = v
      params << '--only-universalparser'
    }
    @opt.on('--with-yjit', 'Add `--with-yjit` if you also would like to build with enabled YJIT. This is equivalent to adding `--enable-yjit`.') {|v|
      param[:with][:yjit] = v
      params << '--with-yjit'
    }
    @opt.on('--only-yjit', 'Add `--only-yjit` if you would like to build with only enabled YJIT. This is equivalent to adding `--enable-yjit`. This option can not be used in conjunction with other options.') {|v|
      param[:only][:yjit] = v
      params << '--only-yjit'
    }
    @opt.on('--with-force-yjit', 'Add `--with-force-yjit` if you also would like to build with enabled YJIT. This is equivalent to adding `cppflags=-DYJIT_FORCE_ENABLE`.') {|v|
      param[:with][:force_yjit] = v
      params << '--with-force-yjit'
    }
    @opt.on('--only-force-yjit', 'Add `--only-force-yjit` if you would like to build with only enabled YJIT. This is equivalent to adding `cppflags=-DYJIT_FORCE_ENABLE`. This option can not be used in conjunction with other options.') {|v|
      param[:only][:force_yjit] = v
      params << '--only-force-yjit'
    }
    @opt.on('--with-rjit', 'Add `--with-rjit` if you also would like to build with enabled RJIT. This is equivalent to adding `--enable-rjit --disable-yjit`.') {|v|
      param[:with][:rjit] = v
      params << '--with-rjit'
    }
    @opt.on('--only-rjit', 'Add `--only-rjit` if you would like to build with only enabled RJIT. This is equivalent to adding `--enable-rjit --disable-yjit`. This option can not be used in conjunction with other options.') {|v|
      param[:only][:rjit] = v
      params << '--only-rjit'
    }
    @opt.on('--with-force-rjit', 'Add `--with-force-rjit` if you also would like to build with enabled RJIT. This is equivalent to adding `cppflags=-DRJIT_FORCE_ENABLE`.') {|v|
      param[:with][:force_rjit] = v
      params << '--with-force-rjit'
    }
    @opt.on('--only-force-rjit', 'Add `--only-force-rjit` if you would like to build with only enabled RJIT. This is equivalent to adding `cppflags=-DRJIT_FORCE_ENABLE`. This option can not be used in conjunction with other options.') {|v|
      param[:only][:force_rjit] = v
      params << '--only-force-rjit'
    }
    @opt.on('--all-build', 'Add `--all-build` if you would like to build with all patterns that include `cppflags` option') {|v|
      param[:all_build] = v
      params << '--all-build'
    }
    @opt.parse!(ARGV)

    if param[:only].keys.size > 1 ||
       (param[:only].keys.size == 1 && !param[:with].empty?) ||
       (param[:only].keys.size == 1 && !!param[:all_build])
      only_error('--only-universalparser') if params.include?('--only-universalparser')
      only_error('--only-yjit') if params.include?('--only-yjit')
      only_error('--only-force-yjit') if params.include?('--only-force-yjit')
      only_error('--only-rjit') if params.include?('--only-rjit')
      only_error('--only-force-rjit') if params.include?('--only-force-rjit')

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
      clone_or_pull(FOR_YJIT_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_YJIT_BUILD_REPOSITORY,
          'yjit',
          "--prefix=#{INSTALL_PREFIX_RUBY_YJIT} --enable-yjit --disable-install-doc")
      }
    end

    if param[:only][:force_yjit] || param[:with][:force_yjit] || param[:all_build]
      clone_or_pull(FOR_FORCE_YJIT_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_FORCE_YJIT_BUILD_REPOSITORY,
          'force-yjit',
          "--prefix=#{INSTALL_PREFIX_RUBY_FORCE_YJIT} cppflags=-DYJIT_FORCE_ENABLE --disable-install-doc")
      }
    end

    if param[:only][:rjit] || param[:with][:rjit] || param[:all_build]
      clone_or_pull(FOR_RJIT_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RJIT_BUILD_REPOSITORY,
          'rjit',
          "--prefix=#{INSTALL_PREFIX_RUBY_RJIT} --enable-rjit --disable-yjit --disable-install-doc")
      }
    end

    if param[:only][:force_rjit] || param[:with][:force_rjit] || param[:all_build]
      clone_or_pull(FOR_FORCE_RJIT_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_FORCE_RJIT_BUILD_REPOSITORY,
          'force-rjit',
          "--prefix=#{INSTALL_PREFIX_RUBY_FORCE_RJIT} cppflags=-DRJIT_FORCE_ENABLE --disable-install-doc")
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

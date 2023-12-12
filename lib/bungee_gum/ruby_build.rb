# frozen_string_literal: true

require 'git'
require 'optparse'

class BungeeGum::RubyBuild
  GITHUB_RUBY_REPOSITORY = 'https://github.com/ruby/ruby.git'
  LOCAL_RUBY_REPOSITORY = 'base-ruby-repo'
  FOR_BUILD_REPOSITORY = 'build-ruby-repo'
  FOR_UP_BUILD_REPOSITORY = 'build-up-ruby-repo'
  FOR_YJIT_BUILD_REPOSITORY = 'build-yjit-ruby-repo'
  FOR_RJIT_BUILD_REPOSITORY = 'build-rjit-ruby-repo'

  INSTALL_PREFIX_BASE = "#{Dir.home}/.rubies"
  INSTALL_PREFIX_RUBY = "#{INSTALL_PREFIX_BASE}/ruby-master"
  INSTALL_PREFIX_RUBY_UP = "#{INSTALL_PREFIX_BASE}/ruby-universal-parser"
  INSTALL_PREFIX_RUBY_YJIT = "#{INSTALL_PREFIX_BASE}/ruby-yjit"
  INSTALL_PREFIX_RUBY_RJIT = "#{INSTALL_PREFIX_BASE}/ruby-rjit"

  def initialize
    @base_ruby_repo = "#{Dir.pwd}/#{LOCAL_RUBY_REPOSITORY}"
    @working_dir = {}
    @now = Time.now.strftime('%Y%m%d%H%M%S')
    @opt = OptionParser.new
    @opt.version = '0.0.1'
  end

  def run
    param = {}
    params = []

    param[:with] = {}
    param[:only] = {}
    param[:skip] = {}

    opt.on('--with-universalparser', 'Add `--with-universalparser` if you also would like to build with Universal Parser mode enabled.') {|v|
      param[:with][:up] = v
      params << '--with-universalparser'
    }
    opt.on('--only-universalparser', 'Add `--only-universalparser` if you would like to build with only Universal Parser mode enabled. This option can not be used in conjunction with other options.') {|v|
      param[:only][:up] = v
      params << '--only-universalparser'
    }
    opt.on('--with-yjit', 'Add `--with-yjit` if you also would like to build with YJIT mode enabled.') {|v|
      param[:with][:yjit] = v
      params << '--with-yjit'
    }
    opt.on('--only-yjit', 'Add `--only-yjit` if you would like to build with only YJIT mode enabled. This option can not be used in conjunction with other options.') {|v|
      param[:only][:yjit] = v
      params << '--only-yjit'
    }
    opt.on('--with-rjit', 'Add `--with-rjit` if you also would like to build with RJIT mode enabled.') {|v|
      param[:with][:rjit] = v
      params << '--with-rjit'
    }
    opt.on('--only-rjit', 'Add `--only-rjit` if you would like to build with only RJIT mode enabled. This option can not be used in conjunction with other options.') {|v|
      param[:only][:rjit] = v
      params << '--only-rjit'
    }
    opt.on('--all-build', 'Add `--all-build` if you would like to build with all modes enabled.') {|v|
      param[:all_build] = v
      params << '--all-build'
    }
    opt.parse!(ARGV)

    if param[:only].keys.size > 1 ||
       (param[:only].keys.size == 1 && !param[:with].empty?) ||
       (param[:only].keys.size == 1 && !!param[:all_build])
      puts "`--only-universalparser` can not be used in conjunction with other options." if params.include?('--only-universalparser')
      puts "`--only-yjit` can not be used in conjunction with other options." if params.include?('--only-yjit')
      puts "`--only-rjit` can not be used in conjunction with other options." if params.include?('--only-rjit')

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

    if param[:only][:rjit] || param[:with][:rjit] || param[:all_build]
      clone_or_pull(FOR_RJIT_BUILD_REPOSITORY)
      fork {
        make_and_test(
          FOR_RJIT_BUILD_REPOSITORY,
          'rjit',
          "--prefix=#{INSTALL_PREFIX_RUBY_RJIT} cppflags=-DRJIT_FORCE_ENABLE --disable-install-doc")
      }
    end

    Process.waitall
  end

  private

  attr_accessor :working_dir
  attr_reader :base_ruby_repo, :now, :opt

  def clone_or_pull(repo_dir, from_gh = false)
    key = repo_dir.to_sym
    working_dir[key] = "#{Dir.pwd}/#{repo_dir}"
    wd = working_dir[key]
    if Dir.exist?("#{wd}/.git")
      g = Git.open(wd, :log => Logger.new(STDOUT))
      g.pull
    else
      if from_gh
        Git.clone(GITHUB_RUBY_REPOSITORY, repo_dir)
      else
        Git.clone(base_ruby_repo, repo_dir)
      end
    end
  end

  def make_and_test(repo_dir, build_type, configure_option)
    wd = working_dir[repo_dir.to_sym]
    current_dir = Dir.pwd

    build_gz = "#{current_dir}/logs/ruby-#{build_type}-build.#{now}.log.gz"
    test_gz = "#{current_dir}/logs/ruby-#{build_type}-test.#{now}.log.gz"

    Dir.chdir(wd) do
      unless Dir.exist?("#{current_dir}/configure")
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
end

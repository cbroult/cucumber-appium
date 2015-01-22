require 'net/http'
require 'rspec/expectations'
require 'selenium-webdriver'

ENABLED_NET_HTTP_TIMEOUT = false

class Net::HTTP
  alias_method  :__original_initialize__, :initialize

  def initialize(address, port = nil)
    __original_initialize__(address, port)
    @read_timeout = 300
  end
end if ENABLED_NET_HTTP_TIMEOUT

APP_PATH = '/../../PlainNote/build/Release-iphonesimulator/PlainNote.app'
USERNAME = ENV['SAUCE_USERNAME']
API_KEY = ENV['SAUCE_ACCESS_KEY']

def capabilities
  {
    'deviceName' => 'iPhone 6',
    'platformName' => 'iOS',
    'platformVersion' => '8.1',
    'app' => absolute_app_path
  }
end

def sauce_capabilities
  {
    'appiumVersion' => '1.3.4',
    'app' => 'sauce-storage:PlainNote.zip',
    'deviceName' => 'iPhone Simulator',
    'username' => USERNAME,
    'access-key' => API_KEY,
    #'os' => 'iOS'
    'browserName' => '',
    'platformName' => 'iOS',#'OS X 10.8',
    'platformVersion' => '8.1',
    'name' => 'Running PlainNote wit Cucumber and Appium',
#    'passed' => 'true',
    'idle-timeout' => 300,
    'max-duration' => 600,
    'command-timeout' => 300,
  }
   # 'idle_timeout] = 60  }
end

def absolute_app_path
  File.join(File.dirname(__FILE__), APP_PATH)
end

def server_url
  "http://127.0.0.1:4723/wd/hub"
end

def sauce_url
  "http://#{USERNAME}:#{API_KEY}@ondemand.saucelabs.com:80/wd/hub"
end

def selenium
  @driver ||= Selenium::WebDriver.for(:remote, :desired_capabilities => capabilities, :url => server_url)
end

def sauce
  @sauce ||= Selenium::WebDriver.for(:remote, :desired_capabilities => sauce_capabilities, :url => sauce_url)
end

#After { @sauce.quit }

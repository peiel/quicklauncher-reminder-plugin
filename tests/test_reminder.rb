# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../main'

class ReminderTest < Minitest::Test
  def request(arguments)
    QuickLauncherReminder.response('version' => 1, 'arguments' => arguments)
  end

  def test_relative_times_and_unicode
    assert_equal({ version: 1, action: 'scheduleReminder', text: '喝水', seconds: 600 }, request('10m 喝水'))
    assert_equal 30, request('30秒 检查烤箱')[:seconds]
    assert_equal 7200, request('2H 站起来活动')[:seconds]
    assert_equal 2_592_000, request('30天 提交报告')[:seconds]
  end

  def test_invalid_input_is_an_error
    ['', '10m', '0m 内容', '31天 内容', '1.5h 内容', "1h 内容\n下一行"].each do |input|
      assert_equal 'error', request(input)[:action], input
    end
    assert_equal 'error', request("2m 内容\n下一行")[:action]
    assert_equal 'error', request('1m ' + '字' * 201)[:action]
    assert_equal 'error', QuickLauncherReminder.response('version' => 2)[:action]
  end

  def test_input_is_data_and_does_not_become_code
    result = request('1m "$(touch /tmp/evil)"')
    assert_equal 'scheduleReminder', result[:action]
    assert_equal '"$(touch /tmp/evil)"', result[:text]
  end
end

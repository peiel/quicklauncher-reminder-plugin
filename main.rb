#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'

module QuickLauncherReminder
  LIMIT_SECONDS = 30 * 24 * 60 * 60
  HELP = '用法：remind 10m 喝水（支持 s、m、h、d 或 秒、分钟、小时、天；最长 30 天）'
  FACTORS = { 's' => 1, '秒' => 1, 'm' => 60, '分' => 60, '分钟' => 60,
              'h' => 3600, '小时' => 3600, 'd' => 86_400, '天' => 86_400 }.freeze

  def self.error(text)
    { version: 1, action: 'error', text: text }
  end

  def self.response(request)
    return error(HELP) unless request.is_a?(Hash) && request['version'] == 1 && request['arguments'].is_a?(String)

    input = request['arguments'].strip
    return error('提醒内容不能包含控制字符。') if input.match?(/[[:cntrl:]]/)

    match = /\A(\d{1,8})\s*(分钟|小时|秒|分|天|[smhd])\s+(.+)\z/i.match(input)
    return error(HELP) unless match

    seconds = match[1].to_i * FACTORS.fetch(match[2].downcase)
    return error('提醒时间需大于零且不超过 30 天。') unless (1..LIMIT_SECONDS).cover?(seconds)

    text = match[3].strip
    return error('提醒内容需为 1–200 个字符。') if text.empty? || text.length > 200

    { version: 1, action: 'scheduleReminder', text: text, seconds: seconds }
  end
end

if $PROGRAM_NAME == __FILE__
  begin
    input = STDIN.gets
    request = JSON.parse(input || '')
    puts JSON.generate(QuickLauncherReminder.response(request))
  rescue JSON::ParserError
    puts JSON.generate(QuickLauncherReminder.error(QuickLauncherReminder::HELP))
  end
end

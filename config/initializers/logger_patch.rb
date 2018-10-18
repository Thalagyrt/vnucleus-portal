class ActiveSupport::Logger::SimpleFormatter
  def call(severity, time, progname, msg)
    formatted_time = time.strftime("%Y-%m-%d %H:%M:%S.%L")

    "#{severity[0]}, [#{formatted_time}] [##{$$}] #{msg.strip}\n"
  end
end
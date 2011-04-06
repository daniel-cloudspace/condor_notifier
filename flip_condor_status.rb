require 'rubygems'
require 'serialport'
print ARGV.to_yaml
sp = SerialPort.new ARGV[0], 9600

while true do
  build_status = File.open('build_status').read
  if build_status == "1\n"
    sp.write(1)
  else
    sp.write(0)
  end
  sleep 1
end

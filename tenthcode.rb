# -*- coding: utf-8 -*-
require  'CHaserConnect.rb' #呼び出すおまじない
require 'map.rb'
require 'think.rb'
# 書き換えない
target = CHaserConnect.new("(っ1ワ1ｃ)") # ()の中好きな名前
values = Array.new(10)
random = Random.new # 乱数生成

map = Map.new()
think = Think.new(map,target)

loop do

#---------ここから---------
    values = target.getReady

    if values[0] == 0
        break
    end
#-----ここまで書き換えない-----

    think.first(values)

#---------ここから---------
    if values[0] == 0
        break
    end

end # ループここまで
target.clos
#-----ここまで書き換えない-----
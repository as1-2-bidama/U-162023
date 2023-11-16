# require "E:\U-16\PortableEditor-Pub-1.0.3\Src\tenthcode\map"

class Think
    def initialize(map,target)
        @map = map
        @target = target
        @bef_dir = ""
        @turn = 0
    end
    def first(values)
        @turn += 1
        @map.setMap(values) # valuse:二次元配列,valuse_cp_1:0番目を削除した配列
        if values.slice(1..-1).include?(1)
            move,direction = @map.teki()
        elsif @turn == 3
            move = "look"
            direction = @bef_dir
            @turn = 0
        else
            if values.slice(1..-1).include?(3)
                move,direction = @map.item()
            else
                move,direction = @map.walk()
            end
            if direction != @bef_dir
                move = @map.if_look(move,direction,@bef_dir)
            end
            @bef_dir = direction
        end
        puts "move"
        eval("values = @target.#{move}#{direction}")
        if move == "look"
            @map.look_proc(values)
        end
    end
end
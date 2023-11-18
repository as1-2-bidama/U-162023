class Map
    def initialize()    #コンストラクタ
        #arry: 2次元配列にする配列
        # コミット
        #自分の周辺を2次元配列に落とし込む
        # @file = File.open("test.txt","w")
        @dir_list = ["Up","Left","Right","Down"]
        @move_list = ["put","walk","look","search"]
        @dir_num_cls = [2,4,6,8]
        @dir_num_but = [1,3,7,9]
        @turp_ptr = [2,3,2]
        @dir_num_but_esc = {1=>[6,8],3=>[4,8],7=>[2,6],9=>[2,4]}
        @dir_num_but_item = {1=>[2,4],3=>[2,6],7=>[4,8],9=>[6,8]}
        @map = Array.new(3){Array.new(3, 0)}
        @bef_bef_dir = ""
        @bef_dir = ""
        @look_af,@ok_dir,@search_mu,@but_dir = [],[],[],[]
    end

    def setMap(values)
        Mapclear()
        for i in 1 .. 9 do
            @map[(i-1)/3][(i-1)%3] = values[i]
            File.write("test.txt",values[i],move:"a")
        end
        @values_cp_0 = values.dup # ただのコピー
        @values_cp_0[0] = 0
        mtPut()
    end

    def Mapclear()
        for i in 1 .. 9 do
            @map[(i-1)/3][(i-1)%3] = 0
        end
    end

    def mtPut()
        for i in 0 .. 2 do
            for j in 0 .. 2 do
                print(@map[i][j])
            end
            print("\n")
        end
    end

    def teki()
        coor = @values_cp_0.index(1)
        puts coor
        if coor.even?
            puts "put"
            move = @move_list[0]
            dir = @dir_list[coor/2-1] # ["Up","Left","Right","Down"]
        else
            puts "escape"
            move = @move_list[1]
            dirn = escape(coor)
            if dirn.empty?
                move = @move_list[2]
                dirn = @dir_num_but_item[coor]
                dir = dirn.sample
            elsif dirn.instance_of?(Array)
                dir = dirn.sample
            end
        end
        return move,dir
    end

    def escape(coor) # coor= 1:6,8 3:4,8 7:2,6 9:2,4
        dirn = []
        dir_num = @dir_num_but_esc[coor]
        puts dir_num
        for i in dir_num
            dirn.push(@dir_list[i/2-1])
        end
        puts dirn
        dir = kabe(dirn)
        puts dir
        return dir
    end

    def walk()
        move = @move_list[1]
        dirn = @dir_list.dup
        dirn = kabe(dirn)
        if dirn.instance_of?(Array)
            if @but_dir.include?(@bef_dir)
                puts "not go"
                for i in @but_dir
                    dirn.delete(i)
                end
                if dirn.size < 1
                    move = @move_list[2]
                    dir = @bef_dir
                elsif dirn.size > 0
                    dir = dirn.sample
                end
            elsif dirn.size > 1
                dirn.delete(@dir_list[3-@dir_list.index(@bef_dir)]) if @dir_list.index(@bef_dir) != nil
                puts dirn
                if dirn.include?(@bef_dir)
                    puts "bef_dir"
                    dir = @bef_dir
                else
                    puts "random walk"
                    dir = dirn.sample
                end
            else
                puts "randomrandion"
                dir = dirn.sample
            end
        end
        dir = bef_move(dirn,dir)
        if move == @move_list[1]
            @look_af,@ok_dir,@search_mu,@but_dir = [],[],[],[]
            puts "clear"
        end
        return move,dir
    end

    def kabe(dirn)
        puts dirn
        for i in @dir_num_cls
            dirn.delete(@dir_list[i/2-1]) if @values_cp_0[i] == 2
        end
        puts dirn
        return dirn
    end

    def item()
        dirn = []
        for i in @dir_num_cls
            puts "item crs"
            move = @move_list[1]
            dirn.push(@dir_list[i/2-1]) if @values_cp_0[i] == 3
        end
        if dirn.empty?
            puts "no item crs"
            move = @move_list[1]
            for i in @dir_num_but
                if @values_cp_0[i] == 3
                    for i in @dir_num_but_item[i]
                        dirn.push(@dir_list[i/2-1])
                    end
                end
            end
        elsif @values_cp_0.include?(2)
            puts "check turp"
            move,dirn = turp_check(dirn)
        end
        dirn = kabe(dirn)
        if move == @move_list[2]
            puts "look-ret"
            dir = dirn.sample
            @look_af.push(dir)
        else
            if dirn.include?(@bef_dir)
                puts "item forward"
                dir = @bef_dir
            elsif dirn.empty?
                puts "canno't get"
                dirn = @dir_list.dup
                dirn = kabe(dirn)
                dir = dirn.sample
                puts dirn
            else
                puts "item rabbit"
                dir = dirn.sample
            end
            dir = bef_move(dirn,dir)
            puts "reslut",dir,dirn
        end
        if move == @move_list[1]
            @look_af,@ok_dir,@search_mu,@but_dir = [],[],[],[]
            puts "clear"
        end
        puts dir
        return move,dir
    end

    def bef_move(dirn,dir)
        if @bef_dir != "" and @bef_bef_dir != ""
            puts "a"
            if dir == @dir_list[3-@dir_list.index(@bef_dir)] or 
                @bef_dir == @dir_list[3-@dir_list.index(@bef_bef_dir)]
                puts "b"
                if dirn.size > 1
                    puts "c"
                    dirn.delete(dir)
                end
                dir = dirn.sample
            end
        end
        @bef_dir = dir
        puts "dir",dir,"bef_dir",@bef_dir,"bef_bef_dir",@bef_bef_dir
        if @bef_bef_dir == ""
            puts "d"
            @bef_bef_dir = @bef_dir
        elsif @bef_dir != @dir_list[3-@dir_list.index(@bef_bef_dir)]
            puts "d"
            @bef_bef_dir = @bef_dir
        end
        return dir
    end

    def look_proc(values)
        puts "look_proc"
        setMap(values)
        @look_af.push(@bef_dir)
        num = @dir_num_cls.dup
        num.delete_at(3-@dir_list.index(@bef_dir)) if @dir_list.index(@bef_dir) != nil
        count = 0
        if @map[1][1] == 5
            puts "bec_center"
            @but_dir.push(@bef_dir)
        elsif @values_cp_0.include?(1)
            puts "atemtion!"
            for i in num
                if @values_cp_0[i] == 1
                    puts "ohps"
                    @but_dir.push(@bef_dir)
                end
            end
            puts @but_dir
        else
            for i in num
                if @values_cp_0[i] == 2
                    count+= 1
                else
                    count = 0
                    break
                end
            end
            if count == 3 and @values_cp_0.include?(3)
                puts "nonnnonn"
                @but_dir.push(@bef_dir)
            else
                puts "ok-"
                @ok_dir.push(@bef_dir)
            end
        end
    end

    def if_look(move,direction,bef_dir)
        if move != @move_list[0] and move != @move_list[2]
            move = @move_list[2]
        end
        return move
    end

    def turp_check(dirn)
        dirnn = []
        dirnn.push(@dir_list[0]) if @map[0] == @turp_ptr
        dirnn.push(@dir_list[1]) if @map[2] == @turp_ptr
        dirnn.push(@dir_list[2]) if @map.transpose[0] == @turp_ptr
        dirnn.push(@dir_list[3]) if @map.transpose[2] == @turp_ptr
        if dirnn.size == dirn.size
            puts "look bef"
            for i in [].concat(@but_dir,@ok_dir)
                dirn.delete(i)
            end
            puts "item",dirn
            if dirn.size == 0
                puts "walk turn"
                if not @ok_dir.empty?
                    puts "ok_ret"
                    dirn = @ok_dir.dup
                elsif @ok_dir.empty?
                    puts "no_ret"
                    dirn = @dir_list.dup
                    for i in @but_dir
                        dirn.delete(i)
                    end
                end
                move = @move_list[1]
            else
                puts "loook"
                move = @move_list[2]
            end
        else
            puts "apple"
            for i in dirnn
                dirn.delete(i)
            end
            move = @move_list[1]
        end
        return move,dirn
    end
end